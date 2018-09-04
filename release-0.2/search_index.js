var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#AsterReader.jl-1",
    "page": "Introduction",
    "title": "AsterReader.jl",
    "category": "section",
    "text": "Pages = [\"index.md\", \"api.md\"]Package can be used to read Code Aster .med and .rmed file formats. To read Code Aster .med file (exported using SALOME), one has to writeaster_read_mesh(fn)where fn is the name of the mesh file. Result is a simple dictionary.In case of several mesh exists in a single file, one must provide also mesh name, e.g.aster_read_mesh(fn, mesh_name=\"my_mesh\")Package can also be used to read results from .rmed files. This is still highly experimental feature and can be used mainly to compare calculation results done using Code Aster to results produced by own FE code."
},

{
    "location": "api.html#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": ""
},

{
    "location": "api.html#API-documentation-1",
    "page": "API",
    "title": "API documentation",
    "category": "section",
    "text": ""
},

{
    "location": "api.html#AsterReader.aster_read_mesh",
    "page": "API",
    "title": "AsterReader.aster_read_mesh",
    "category": "function",
    "text": "Parse code aster .med file.\n\nParamters\n\nfn     file name to parse mesh_name :: optional     mesh name, if several meshes in one file\n\nReturns\n\nDict containing fields \"nodes\" and \"connectivity\".\n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.MEDFile",
    "page": "API",
    "title": "AsterReader.MEDFile",
    "category": "type",
    "text": "Code Aster binary file (.med). \n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.RMEDFile",
    "page": "API",
    "title": "AsterReader.RMEDFile",
    "category": "type",
    "text": "Code Aster result file (.rmed). \n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.aster_read_data-Tuple{AsterReader.RMEDFile,Any}",
    "page": "API",
    "title": "AsterReader.aster_read_data",
    "category": "method",
    "text": "Read nodal field from rmed file. \n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.aster_read_nodes-Tuple{AsterReader.RMEDFile}",
    "page": "API",
    "title": "AsterReader.aster_read_nodes",
    "category": "method",
    "text": "Return nodes from result med file. \n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.get_element_sets-Tuple{AsterReader.MEDFile,String}",
    "page": "API",
    "title": "AsterReader.get_element_sets",
    "category": "method",
    "text": "Return element sets from med file.\n\nNotes\n\nOne element set id can have multiple names.\n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.get_node_sets-Tuple{AsterReader.MEDFile,String}",
    "page": "API",
    "title": "AsterReader.get_node_sets",
    "category": "method",
    "text": "Return node sets from med file.\n\nNotes\n\nOne node set id can have multiple names.\n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.parse_node_id-Tuple{Any}",
    "page": "API",
    "title": "AsterReader.parse_node_id",
    "category": "method",
    "text": "parse_node_id(node_name)\n\nReturn id number from node name. Usually the node name contains the id number, i.e. N123 => 123 and so on.\n\n\n\n\n\n"
},

{
    "location": "api.html#AsterReader.to_ascii-Tuple{Array{Int8,1}}",
    "page": "API",
    "title": "AsterReader.to_ascii",
    "category": "method",
    "text": "Convert vector of Int8 to ASCII string. \n\n\n\n\n\n"
},

{
    "location": "api.html#Index-1",
    "page": "API",
    "title": "Index",
    "category": "section",
    "text": "DocTestSetup = quote\n    using AsterReader\nendModules = [AsterReader]"
},

]}
