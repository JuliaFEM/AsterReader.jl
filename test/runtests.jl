# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

using Test, AsterReader

@testset "AsterReader.jl" begin
    include("test_read_aster_mesh.jl")
    include("test_read_aster_results.jl")
    include("test_read_gmsh_med.jl")
    include("test_read_file_not_found.jl")
end
