using MetaUtils
using Test

@testset "MetaUtils.jl" begin
    @test (:call, :+, (:call, :*, 2, :x), 1) |> texpr2expr == :(2x + 1)
    @test (:+, (:*, 2, :x), 1) |> texpr2expr == :(2x + 1)
    @test sprint(show_expr, :(2x + 1)) == 
        "Expr(:call, :+, \n    Expr(:call, :*, 2, :x), 1)"
    @test sprint(show_texpr, :(2x + 1)) == 
        "(:call, :+, \n    (:call, :*, 2, :x), 1)"
end
