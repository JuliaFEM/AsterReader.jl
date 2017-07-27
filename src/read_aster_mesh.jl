# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

function aster_parse_nodes(section; strip_characters=true)
    nodes = Dict{Any, Vector{Float64}}()
    has_started = false
    for line in split(section, '\n')
        m = matchall(r"[\w.-]+", line)
        if (length(m) != 1) && (!has_started)
            continue
        end
        if length(m) == 1
            if (m[1] == "COOR_2D") || (m[1] == "COOR_3D")
                has_started = true
                continue
            end
            if m[1] == "FINSF"
                break
            end
        end
        if length(m) == 4
            nid = m[1]
            if strip_characters
                nid = matchall(r"\d", nid)
                nid = parse(Int, nid[1])
            end
            nodes[nid] = float(m[2:end])
        end
    end
    return nodes
end


""" Code Aster binary file (.med). """
type MEDFile
    data :: Dict
end

function MEDFile(fn::String)
    return MEDFile(h5read(fn, "/"))
end

function get_mesh_names(med::MEDFile)
    return sort(collect(keys(med.data["FAS"])))
end

""" Convert vector of Int8 to ASCII string. """
function to_ascii(data::Vector{Int8})
    return ascii(unsafe_string(pointer(convert(Vector{UInt8}, data))))
end

function get_mesh(med::MEDFile, mesh_name::String)
    if !haskey(med.data["FAS"], mesh_name)
        warn("Mesh $mesh_name not found from med file.")
        meshes = get_mesh_names(med)
        all_meshes = join(meshes, ", ")
        warn("Available meshes: $all_meshes")
        error("Mesh $mesh_name not found.")
    end
    return med.data["FAS"][mesh_name]
end

""" Return node sets from med file.

Notes
-----
One node set id can have multiple names.

"""
function get_node_sets(med::MEDFile, mesh_name::String)::Dict{Int64, Vector{String}}
    mesh = get_mesh(med, mesh_name)
    node_sets = Dict{Int64, Vector{String}}(0 => ["OTHER"])
    if !haskey(mesh, "NOEUD")
        return node_sets
    end
    for (k, v) in mesh["NOEUD"]
        nset_id = parse(Int, split(k, "_")[2])
        node_sets[nset_id] = collect(to_ascii(d) for d in v["GRO"]["NOM"])
    end
    return node_sets
end

""" Return element sets from med file.

Notes
-----
One element set id can have multiple names.

"""
function get_element_sets(med::MEDFile, mesh_name::String)::Dict{Int64, Vector{String}}
    mesh = get_mesh(med, mesh_name)
    element_sets = Dict{Int64, Vector{String}}()
    if !haskey(mesh, "ELEME")
        return element_sets
    end
    for (k, v) in mesh["ELEME"]
        elset_id = parse(Int, split(k, '_')[2])
        element_sets[elset_id] = collect(to_ascii(d) for d in v["GRO"]["NOM"])
    end
    return element_sets
end

function get_nodes(med::MEDFile, nsets::Dict{Int, Vector{String}}, mesh_name::String)
    increments = keys(med.data["ENS_MAA"][mesh_name])
    @assert length(increments) == 1
    increment = first(increments)
    nodes = med.data["ENS_MAA"][mesh_name][increment]["NOE"]
    node_ids = nodes["NUM"]
    nset_ids = nodes["FAM"]
    nnodes = length(node_ids)
    node_coords = nodes["COO"]
    dim = round(Int, length(node_coords)/nnodes)
    node_coords = reshape(node_coords, nnodes, dim)'
    d = Dict{Int64}{Tuple{Vector{String}, Vector{Float64}}}()
    for i=1:nnodes
        nset = nsets[nset_ids[i]]
        d[node_ids[i]] = (nset, node_coords[:, i])
    end
    return d
end

function get_connectivity(med::MEDFile, elsets::Dict{Int64, Vector{String}}, mesh_name::String)
    if !haskey(elsets, 0)
        elsets[0] = ["OTHER"]
    end
    increments = keys(med.data["ENS_MAA"][mesh_name])
    @assert length(increments) == 1
    increment = first(increments)
    all_elements = med.data["ENS_MAA"][mesh_name][increment]["MAI"]
    d = Dict{Int64, Tuple{Symbol, Vector{String}, Vector{Int64}}}()
    for eltype in keys(all_elements)
        elements = all_elements[eltype]
        elset_ids = elements["FAM"]
        element_ids = elements["NUM"]
        nelements = length(element_ids)
        element_connectivity = elements["NOD"]
        element_dim = round(Int, length(element_connectivity)/nelements)
        element_connectivity = reshape(element_connectivity, nelements, element_dim)'
        for i=1:nelements
            eltype = Symbol(eltype)
            elco = element_connectivity[:, i]
            elset = elsets[elset_ids[i]]
            d[element_ids[i]] = (eltype, elset, elco)
        end
    end
    return d
end

""" Parse code aster .med file.

Paramters
---------
fn
    file name to parse
mesh_name :: optional
    mesh name, if several meshes in one file

Returns
-------
Dict containing fields "nodes" and "connectivity".

"""
function aster_read_mesh(fn, mesh_name=nothing)
    med = MEDFile(fn)
    mesh_names = get_mesh_names(med::MEDFile)
    all_meshes = join(mesh_names, ", ")
    if mesh_name == nothing
        length(mesh_names) == 1 || error("several meshes found from med, pick one: $all_meshes")
        mesh_name = mesh_names[1]
    else
        mesh_name in mesh_names || error("Mesh $mesh_name not found from mesh file $fn. Available meshes: $all_meshes")
    end

    mesh = Dict{String, Dict}()
    mesh["nodes"] = Dict{Int64, Vector{Float64}}()
    mesh["node_sets"] = Dict{String, Vector{Int64}}()
    mesh["elements"] = Dict{Integer, Vector{Integer}}()
    mesh["element_types"] = Dict{Integer, Symbol}()
    mesh["element_sets"] = Dict{String, Vector{Int64}}()
    mesh["surface_sets"] = Dict{String, Vector{Tuple{Int64, Symbol}}}()
    mesh["surface_types"] = Dict{String, Symbol}()

    debug("Code Aster .med reader info:")
    elsets = get_element_sets(med, mesh_name)
    for (k,v) in elsets
        debug("ELSET $k => $v")
    end
    nsets = get_node_sets(med, mesh_name)
    for (k,v) in nsets
        debug("NSET $k => $v")
    end
    for (nid, (nset_, coords)) in get_nodes(med, nsets, mesh_name)
        mesh["nodes"][nid] = coords
        for nset in nset_
            if !haskey(mesh["node_sets"], nset)
                mesh["node_sets"][nset] = []
            end
            push!(mesh["node_sets"][nset], nid)
        end
    end
    for (elid, (eltyp, elset_, elcon)) in get_connectivity(med, elsets, mesh_name)
        mesh["elements"][elid] = elcon
        mesh["element_types"][elid] = eltyp
        for elset in elset_
            if !haskey(mesh["element_sets"], elset)
                mesh["element_sets"][elset] = []
            end
            push!(mesh["element_sets"][elset], elid)
        end
    end
    return mesh
end


