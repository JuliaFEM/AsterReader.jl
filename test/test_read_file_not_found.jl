# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

using Test, AsterReader

@test_throws ErrorException aster_read_mesh("not_found.med")
