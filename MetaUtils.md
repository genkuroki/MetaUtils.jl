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
    display_name: Julia 1.5.2
    language: julia
    name: julia-1.5
---

# MetaUtils

* Author: Gen Kuroki
* Date: 2020-10-11

<!-- #region {"toc": true} -->
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Explanatory-examples" data-toc-modified-id="Explanatory-examples-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Explanatory examples</a></span></li><li><span><a href="#Miscellaneous-examples-of-@show_sexpr,-etc." data-toc-modified-id="Miscellaneous-examples-of-@show_sexpr,-etc.-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Miscellaneous examples of @show_sexpr, etc.</a></span></li><li><span><a href="#Evaluation-of-lisp-like-tuple-expressions" data-toc-modified-id="Evaluation-of-lisp-like-tuple-expressions-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Evaluation of lisp-like tuple expressions</a></span><ul class="toc-item"><li><span><a href="#Miscellaneous-examples-of-MetaUtils.@t" data-toc-modified-id="Miscellaneous-examples-of-MetaUtils.@t-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>Miscellaneous examples of MetaUtils.@t</a></span></li><li><span><a href="#More-lisp-like-example" data-toc-modified-id="More-lisp-like-example-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>More lisp-like example</a></span></li></ul></li><li><span><a href="#Documents" data-toc-modified-id="Documents-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Documents</a></span></li></ul></div>
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

```julia
methods(eval)
```

## Explanatory examples

```julia
@show_sexpr 2x+1
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
show_Sexpr(:(f(x, g(y, z))))
```

```julia
@show_Sexpr 2x+1
```

```julia
texpr2expr((:call, :sin, (:call, :/, π, 6)))
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

## Miscellaneous examples of @show_sexpr, etc.

```julia
@show_sexpr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia
@show_sexpr for k in 1:10
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
@show_Sexpr for k in 1:10
    x = k*(k+1) ÷ 2
    println("k(k+1)/2 = ", x)
end
```

```julia
print_tree(Number)
```

```julia
print_tree(AbstractVector)
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

eq(x, y) = x == y

struct Nil end
const nil = Nil()
Base.show(io::IO, ::Nil) = print(io, "nil")
null(x) = false
null(::Nil) = true

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
        (:if, (:eq, :v, (:tuple,)),
            :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), 
                (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    (:quote, :Orange), 
    (:tuple, 
        (:tuple, (:quote, :Apple),  120), 
        (:tuple, (:quote, :Orange), 210), 
        (:tuple, (:quote, :Lemmon), 180), :nil)) |> texpr2expr
```

```julia
MetaUtils.@t (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)),
            :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), 
                (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    (:quote, :Orange), 
    (:tuple, 
        (:tuple, (:quote, :Apple),  120), 
        (:tuple, (:quote, :Orange), 210), 
        (:tuple, (:quote, :Lemmon), 180), :nil))
```

```julia
MetaUtils.@T (:call, 
    (:->, (:tuple, :assoc, :k, :v), :(assoc(k,v))), 
    (:function, :(f(k,v)), 
        (:if, (:eq, :v, (:tuple,)),
            :nil, 
            (:elseif, (:eq, (:car, (:car, :v)), :k), 
                (:car, :v), 
                (:call, :f, :k, (:cdr, :v))))), 
    (:quote, :Orange), 
    (:tuple, 
        (:tuple, (:quote, :Apple),  120), 
        (:tuple, (:quote, :Orange), 210), 
        (:tuple, (:quote, :Lemmon), 180), :nil))
```

## Documents

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
@doc show_Sexpr
```

```julia
@doc @show_Sexpr
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