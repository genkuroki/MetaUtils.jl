---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.1'
      jupytext_version: 1.2.1
  kernelspec:
    display_name: Julia MKL depwarn -O3 1.5.2
    language: julia
    name: julia-mkl-depwarn--o3-1.5
---

# MetaUtils

* Author: Gen Kuroki
* Date: 2020-10-11～2020-10-17
* Repository: https://github.com/genkuroki/MetaUtils.jl
* File: https://nbviewer.jupyter.org/github/genkuroki/MetaUtils.jl/blob/master/MetaUtils.ipynb

<!-- #region {"toc": true} -->
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Explanatory-examples" data-toc-modified-id="Explanatory-examples-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Explanatory examples</a></span></li><li><span><a href="#Miscellaneous-examples-of-@show_texpr,-etc." data-toc-modified-id="Miscellaneous-examples-of-@show_texpr,-etc.-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Miscellaneous examples of @show_texpr, etc.</a></span><ul class="toc-item"><li><span><a href="#for-loop" data-toc-modified-id="for-loop-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>for loop</a></span></li><li><span><a href="#type-trees" data-toc-modified-id="type-trees-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>type trees</a></span></li><li><span><a href="#function-definition" data-toc-modified-id="function-definition-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>function definition</a></span></li><li><span><a href="#macro-and-LineNumberNode" data-toc-modified-id="macro-and-LineNumberNode-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>macro and LineNumberNode</a></span></li><li><span><a href="#QuoteNode" data-toc-modified-id="QuoteNode-2.5"><span class="toc-item-num">2.5&nbsp;&nbsp;</span>QuoteNode</a></span></li></ul></li><li><span><a href="#Evaluation-of-lisp-like-tuple-expressions" data-toc-modified-id="Evaluation-of-lisp-like-tuple-expressions-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Evaluation of lisp-like tuple expressions</a></span><ul class="toc-item"><li><span><a href="#Miscellaneous-examples-of-MetaUtils.@t" data-toc-modified-id="Miscellaneous-examples-of-MetaUtils.@t-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>Miscellaneous examples of MetaUtils.@t</a></span></li><li><span><a href="#More-lisp-like-example" data-toc-modified-id="More-lisp-like-example-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>More lisp-like example</a></span></li></ul></li><li><span><a href="#Documents" data-toc-modified-id="Documents-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Documents</a></span></li></ul></div>
<!-- #endregion -->

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
print_tree(AbstractRange)
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

```julia
texpr2expr((:call, :sin, (:call, :/, π, 6)))
```

```julia
(:call, :sin, (:call, :/, π, 6)) |> teval
```

```julia
@teval (:call, :sin, (:call, :/, π, 6))
```

```julia
MetaUtils.@t (:call, :sin, (:call, :/, π, 6))
```

```julia
MetaUtils.@T (:call, :sin, (:call, :/, π, 6))
```

```julia
(:sin, (:/, π, 6)) |> teval
```

```julia
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

```julia
@show_expr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia
@show_texpr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

### type trees

```julia
print_tree(Number)
```

```julia
print_tree(AbstractVector)
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

## Evaluation of lisp-like tuple expressions


### Miscellaneous examples of MetaUtils.@t

```julia
using MetaUtils: @t
```

```julia
# Define and run a function f(x) = sin(x)

@t (:(=), :(f(x)), (:sin, :x))
@t (:f, (:/, π, 6))
```

```julia
# Define and run a function g(x) = sin(x)

@t (:block,
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

### More lisp-like example

```julia
# Lisp-like functions

struct Nil end
const nil = Nil()
Base.show(io::IO, ::Nil) = print(io, "nil")
null(x) = false
null(::Nil) = true

eq(x, y) = x == y
eq(x::Tuple, ::Nil) = x == ()
eq(::Nil, y::Tuple) = y == ()

cons(x, y) = (x, y)
cons(x, y::Tuple) = (x, y...)

car(x) = nil
car(x::Tuple) = x[begin]

cdr(x) = nil
cdr(x::Tuple) = length(x) == 2 ? x[begin+1] : x[begin+1:end]

caar(x) = car(car(x))
cadr(x) = car(cdr(x))
cdar(x) = cdr(car(x))
cddr(x) = cdr(cdr(x))

@show null(nil)
@show null(1)
@show eq((1,2), (1,2))
@show eq(nil, ())
@show eq((), nil)
@show cons(1, 2)
@show cons(1, (2, 3))
@show cons((1, 2), 3)
@show cons((1, 2), (3, 4, 5))
@show car(1)
@show cdr(1)
@show car((1, 2))
@show cdr((1, 2))
@show car(((1, 2), (3, (4, 5)), 6, nil))
@show cdr(((1, 2), (3, (4, 5)), 6, nil))
@show caar(((1, 2), (3, (4, 5)), 6, nil))
@show cadr(((1, 2), (3, (4, 5)), 6, nil))
@show cdar(((1, 2), (3, (4, 5)), 6, nil))
@show cddr(((1, 2), (3, (4, 5)), 6, nil))
;
```

<!-- #region -->
https://nbviewer.jupyter.org/gist/genkuroki/b60908cca4f4978b8adcaa7955e7b5b6

**example 4**

```lisp
((lambda (assoc k v) (assoc k v))
 '(lambda (k v)
    (cond ((eq v '()) nil)
          ((eq (car (car v)) k)
           (car v))
          ('t (assoc k (cdr v)))))
 'Orange
 '((Apple . 120) (Orange . 210) (Lemmon . 180)))
=> (:Orange . 210)
```
<!-- #endregion -->

```julia
(:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)), :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    QuoteNode(:Orange), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil)) |> texpr2expr
```

```julia
MetaUtils.@t (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)), :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    QuoteNode(:Apple), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil))
```

```julia
MetaUtils.@t (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)), :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    QuoteNode(:Orange), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil))
```

```julia
MetaUtils.@t (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)), :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    QuoteNode(:Lemmon), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil))
```

```julia
MetaUtils.@t (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)), :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    QuoteNode(:Melon), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil))
```

```julia
MetaUtils.@T (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)), :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    QuoteNode(:Orange), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil))
```

```julia
@show_texpr (((assoc, k, v)->assoc(k, v)))(
    function f(k, v)
        if eq(v, ())              nil
        elseif eq(car(car(v)), k) car(v)
        else                      f(k, cdr(v)) end
    end, 
    :Orange, 
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
(((assoc, k, v)->assoc(k, v)))(
    function f(k, v)
        if eq(v, ())              nil
        elseif eq(car(car(v)), k) car(v)
        else                      f(k, cdr(v)) end
    end, 
    :Apple, 
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
(((assoc, k, v)->assoc(k, v)))(
    function f(k, v)
        if eq(v, ())              nil
        elseif eq(car(car(v)), k) car(v)
        else                      f(k, cdr(v)) end
    end, 
    :Orange, 
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
(((assoc, k, v)->assoc(k, v)))(
    function f(k, v)
        if eq(v, ())              nil
        elseif eq(car(car(v)), k) car(v)
        else                      f(k, cdr(v)) end
    end, 
    :Lemmon, 
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
(((assoc, k, v)->assoc(k, v)))(
    function f(k, v)
        if eq(v, ())              nil
        elseif eq(car(car(v)), k) car(v)
        else                      f(k, cdr(v)) end
    end, 
    :Melon, 
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
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
@doc print_tree
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
