# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

module AsterReader
using Logging
using HDF5
include("read_aster_mesh.jl")
include("read_aster_results.jl")
export aster_read_mesh
end
