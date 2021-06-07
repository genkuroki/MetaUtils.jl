---
jupyter:
  jupytext:
    cell_metadata_json: true
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.2
  kernelspec:
    display_name: Julia 1.7.0-DEV
    language: julia
    name: julia-1.7
---

# MetaUtils

* Author: Gen Kuroki
* Date: 2020-10-11～2020-10-17, 2021-03-20～2021-03-26, 2021-06-07
* Repository: https://github.com/genkuroki/MetaUtils.jl
* File: https://nbviewer.jupyter.org/github/genkuroki/MetaUtils.jl/blob/master/MetaUtils.ipynb

<!-- #region {"toc": true} -->
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Explanatory-examples" data-toc-modified-id="Explanatory-examples-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Explanatory examples</a></span></li><li><span><a href="#Miscellaneous-examples-of-@show_texpr,-etc." data-toc-modified-id="Miscellaneous-examples-of-@show_texpr,-etc.-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Miscellaneous examples of @show_texpr, etc.</a></span><ul class="toc-item"><li><span><a href="#for-loop" data-toc-modified-id="for-loop-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>for loop</a></span></li><li><span><a href="#subtype-trees" data-toc-modified-id="subtype-trees-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>subtype trees</a></span></li><li><span><a href="#function-definition" data-toc-modified-id="function-definition-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>function definition</a></span></li><li><span><a href="#macro-and-LineNumberNode" data-toc-modified-id="macro-and-LineNumberNode-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>macro and LineNumberNode</a></span></li><li><span><a href="#QuoteNode" data-toc-modified-id="QuoteNode-2.5"><span class="toc-item-num">2.5&nbsp;&nbsp;</span>QuoteNode</a></span></li></ul></li><li><span><a href="#Evaluation-of-Lisp-like-tuple-expressions" data-toc-modified-id="Evaluation-of-Lisp-like-tuple-expressions-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Evaluation of Lisp-like tuple expressions</a></span></li><li><span><a href="#Plot-example" data-toc-modified-id="Plot-example-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Plot example</a></span></li><li><span><a href="#Documents" data-toc-modified-id="Documents-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>Documents</a></span></li></ul></div>
<!-- #endregion -->

```julia
VERSION
```

```julia
if isfile("Project.toml")
    using Pkg
    Pkg.activate(".")
    using Revise
end
```

```julia
using MetaUtils
```

## Explanatory examples

```julia
@show_sexpr 2x+1
```

```julia
x = 10; (:call, :+, (:call, :*, 2, :x), 1) |> teval
```

```julia
@show_tree 2x+1
```

```julia
show_tree(:(2x + 1))
```

```julia
print_subtypes(AbstractRange)
```

```julia
show_expr(:(f(x, g(y, z))))
```

```julia
@show_expr 2x+1
```

```julia
x = 10; Expr(:call, :+, 
    Expr(:call, :*, 2, :x), 1) |> eval
```

```julia
show_texpr(:(f(x, g(y, z))))
```

```julia
@show_texpr 2x+1
```

```julia
x = 10; (:call, :+, 
    (:call, :*, 2, :x), 1) |> teval
```

```julia tags=[]
texpr2expr((:call, :sin, (:call, :/, π, 6)))
```

```julia tags=[]
(:call, :sin, (:call, :/, π, 6)) |> teval
```

```julia tags=[]
@teval (:call, :sin, (:call, :/, π, 6))
```

```julia
MetaUtils.@t (:call, :sin, (:call, :/, π, 6))
```

```julia
MetaUtils.@T (:call, :sin, (:call, :/, π, 6))
```

```julia tags=[]
(:sin, (:/, π, 6)) |> teval
```

```julia tags=[]
@teval (:sin, (:/, π, 6))
```

```julia
MetaUtils.@t (:sin, (:/, π, 6))
```

```julia
MetaUtils.@T (:sin, (:/, π, 6))
```

## Miscellaneous examples of @show_texpr, etc.


### for loop

```julia
@show_texpr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia
@show_texpr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end true
```

```julia
@show_tree for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end 2
```

```julia
@show_tree for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia
@show_tree for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end 10 true
```

```julia
Meta.@dump for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia tags=[]
@show_expr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia tags=[]
@show_texpr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

### subtype trees

```julia
print_subtypes(AbstractRange)
```

```julia
print_subtypes(Number)
```

```julia
print_subtypes(AbstractVector)
```

### function definition

```julia
@show_texpr function f(x::T) where T<:Number
    sin(x)
end
```

```julia
@show_tree function f(x::T) where T<:Number
    sin(x)
end
```

```julia
@show_expr function f(x::T) where T<:Number
    sin(x)
end
```

```julia
@show_texpr function f(x::T) where T<:Number
    sin(x)
end
```

### macro and LineNumberNode

```julia
@show_tree @show float(π)
```

```julia
@show_sexpr @show float(π)
```

```julia
@teval (:macrocall, Symbol("@show"), :(#= In[34]:1 =#), (:call, :float, :π))
```

```julia
@show_expr @show float(π)
```

```julia
Expr(:macrocall, Symbol("@show"), LineNumberNode(@__LINE__, @__FILE__), 
    Expr(:call, :float, :π)) |> show_expr
```

```julia
Expr(:macrocall, Symbol("@show"), LineNumberNode(@__LINE__, @__FILE__), 
    Expr(:call, :float, :π)) |> eval
```

```julia
@show_texpr @show float(π)
```

```julia
(:macrocall, Symbol("@show"), LineNumberNode(@__LINE__, @__FILE__), 
    (:call, :float, :π)) |> teval
```

```julia
@teval (:macrocall, Symbol("@show"), LineNumberNode(@__LINE__, @__FILE__),  
    (:call, :float, :π))
```

### QuoteNode

```julia
QuoteNode(:(sin(x)))
```

```julia
QuoteNode(:(sin(x))) |> Meta.show_sexpr
```

```julia
QuoteNode(:(sin(x))) |> show_expr
```

```julia
QuoteNode(:(sin(x))) |> show_texpr
```

```julia
QuoteNode(
    (:call, :sin, :x)) |> texpr2expr == QuoteNode(:(sin(x)))
```

```julia
@teval QuoteNode(
    (:call, :sin, :x))
```

## Evaluation of Lisp-like tuple expressions

If you want more Lisp-like examamples, see [LispLikeEval.ipynb](https://nbviewer.jupyter.org/github/genkuroki/LispLikeEval.jl/blob/master/LispLikeEval.ipynb).

```julia
using MetaUtils: @t, @T
```

```julia
# Define and run a function f(x) = sin(x)

@t (:(=), :(f(x)), (:sin, :x))
println()
@t (:f, (:/, π, 6))
```

```julia
# Define and run a function f(x) = sin(x)

@T (:(=), :(f(x)), (:sin, :x))
println()
@T (:f, (:/, π, 6))
```

```julia
# Define and run a function g(x) = sin(x)

@t (:block,
    (:function, :(g(x)), (:sin, :x)),
    (:call, :g, (:/, π, 6)))
```

```julia
# Define and run a function g(x) = sin(x)

@T (:block,
    (:function, :(g(x)), (:sin, :x)),
    (:call, :g, (:/, π, 6)))
```

```julia
# Calculation of pi by the Monte Carlo method

@t (:block, 
    (:function, :(pi_mc(N)), 
        (:block, 
            (:(=), :c, 0), 
            (:for, (:(=), :i, (:(:), 1, :N)), 
                (:block, 
                    (:+=, :c, 
                        (:call, :ifelse, 
                            (:≤, (:+, (:^, (:rand,), 2), (:^, (:rand,), 2)), 1), 
                            1, 0)))), 
            (:/, (:*, 4, :c), :N))), 
    (:call, :pi_mc, (:^, 10, 8)))
```

```julia
# quote

@t (:quote, (:sin, :x))
```

```julia
# tuple

@t (:tuple, 1, 2, 3)
```

## Plot example

```julia
begin
    using Plots
    n = 20
    x = range(-π, π; length=20)
    noise = 0.3randn(n)
    y = sin.(x) + noise
    X = x .^ (0:3)'
    b = X\y
    f(x) = evalpoly(x, b)
    xs = range(-π, π; length=400)
    plot(; legend=:topleft)
    scatter!(x, y; label="sample")
    plot!(xs, sin.(xs); label="sin(x)", color=:blue, ls=:dash)
    plot!(xs, f.(xs); label="degree-3 polynomial", color=:red, lw=2)
end
```

```julia
@show_texpr begin
    using Plots
    n = 20
    x = range(-π, π; length=20)
    noise = 0.3randn(n)
    y = sin.(x) + noise
    X = x .^ (0:3)'
    b = X\y
    f(x) = evalpoly(x, b)
    xs = range(-π, π; length=400)
    plot(; legend=:topleft)
    scatter!(x, y; label="sample")
    plot!(xs, sin.(xs); label="sin(x)", color=:blue, ls=:dash)
    plot!(xs, f.(xs); label="degree-3 polynomial", color=:red, lw=2)
end
```

```julia
@teval (:block, 
    (:using, (:., :Plots)), 
    (:(=), :n, 20), 
    (:(=), :x, (:range, (:parameters, (:kw, :length, 20)), (:-, :π), :π)), 
    (:(=), :noise, (:*, 0.3, (:randn, :n))), 
    (:(=), :y, (:+, (:., :sin, (:tuple, :x)), :noise)), 
    (:(=), :X, (:call, :.^, :x, (Symbol("'"), (:call, :(:), 0, 3)))),  
    (:(=), :b, (:\, :X, :y)), 
    (:(=), (:call, :f, :x), (:block, (:call, :evalpoly, :x, :b))),
    (:(=), :xs, (:range, (:parameters, (:kw, :length, 400)), (:-, :π), :π)), 
    (:plot, (:parameters, (:kw, :legend, QuoteNode(:topleft)))), 
    (:scatter!, (:parameters, (:kw, :label, "sample")), :x, :y), 
    (:plot!, (:parameters, 
            (:kw, :label, "sin(x)"), 
            (:kw, :color, QuoteNode(:blue)), 
            (:kw, :ls, QuoteNode(:dash))), 
        :xs, (:., :sin, (:tuple, :xs))), 
    (:plot!, (:parameters, 
            (:kw, :label, "degree-3 polynomial"), 
            (:kw, :color, QuoteNode(:red)), 
            (:kw, :lw, 2)), 
        :xs, (:., :f, (:tuple, :xs))))
```

```julia
(:block, 
    (:using, (:., :Plots)), 
    (:(=), :n, 20), 
    (:(=), :x, (:range, (:parameters, (:kw, :length, 20)), (:-, :π), :π)), 
    (:(=), :noise, (:*, 0.3, (:randn, :n))), 
    (:(=), :y, (:+, (:., :sin, (:tuple, :x)), :noise)), 
    (:(=), :X, (:call, :.^, :x, (Symbol("'"), (:call, :(:), 0, 3)))),  
    (:(=), :b, (:\, :X, :y)), 
    (:(=), (:call, :f, :x), (:block, (:call, :evalpoly, :x, :b))),
    (:(=), :xs, (:range, (:parameters, (:kw, :length, 400)), (:-, :π), :π)), 
    (:plot, (:parameters, (:kw, :legend, QuoteNode(:topleft)))), 
    (:scatter!, (:parameters, (:kw, :label, "sample")), :x, :y), 
    (:plot!, (:parameters, 
            (:kw, :label, "sin(x)"), 
            (:kw, :color, QuoteNode(:blue)), 
            (:kw, :ls, QuoteNode(:dash))), 
        :xs, (:., :sin, (:tuple, :xs))), 
    (:plot!, (:parameters, 
            (:kw, :label, "degree-3 polynomial"), 
            (:kw, :color, QuoteNode(:red)), 
            (:kw, :lw, 2)), 
        :xs, (:., :f, (:tuple, :xs)))) |> texpr2expr |> 
x -> display("text/markdown", "```julia\n$x\n```")
```

## Documents

```julia
@doc MetaUtils
```

```julia
@doc @show_sexpr
```

```julia
@doc @show_tree
```

```julia
@doc show_tree
```

```julia
@doc print_subtypes
```

```julia
@doc show_expr
```

```julia
@doc @show_expr
```

```julia
@doc show_texpr
```

```julia
@doc @show_texpr
```

```julia
@doc teval
```

```julia
@doc @teval
```

```julia
@doc MetaUtils.@t
```

```julia
@doc MetaUtils.@T
```

```julia

```
