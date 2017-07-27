# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

using Base.Test
using AsterReader: RMEDFile, aster_read_data

datadir = first(splitext(basename(@__FILE__)))

@testset "read nodal field from result rmed file" begin
    rmedfile = joinpath(datadir, "rings.rmed")
    rmed = RMEDFile(rmedfile)
    temp = aster_read_data(rmed, "TEMP")
    @test isapprox(temp[15], 1.0)
    @test isapprox(temp[95], 2.0)
end
