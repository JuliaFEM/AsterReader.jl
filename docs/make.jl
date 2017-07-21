# This file is a part of project JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/AsterReader.jl/blob/master/LICENSE

using Documenter
using AsterReader

makedocs(
    modules = [AsterReader],
    checkdocs = :all,
    strict = true)
