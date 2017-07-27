# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

using AsterReader
using Base.Test

@testset "AsterReader.jl" begin
    include("test_read_aster_mesh.jl")
    include("test_read_aster_results.jl")
end
