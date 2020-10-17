using MetaUtils
using Test

x = 10

@testset "MetaUtils.jl" begin
    @test (@teval (:call, :+, (:call, :*, 2, :x), 1)) == 21
    @test (@teval (:+, (:*, 2, :x), 1)) == 21
    @test sprint(show_expr, :(2x + 1)) == 
        "Expr(:call, :+, \n    Expr(:call, :*, 2, :x), 1)"
    @test sprint(show_texpr, :(2x + 1)) == 
        "(:call, :+, \n    (:call, :*, 2, :x), 1)"
    @test sprint(print_tree, AbstractFloat) ==
        "AbstractFloat\n├─ BigFloat\n├─ Float16\n├─ Float32\n└─ Float64\n"
end
