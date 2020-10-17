"""
    MetaUtils

contains utilities for metaprogramming in Julia.

```julia
export @show_sexpr, 
    @show_tree, 
    print_tree, 
    show_expr, @show_expr, 
    show_texpr, @show_texpr, 
    texpr2expr, teval, @teval
```
"""
module MetaUtils

export @show_sexpr, 
    @show_tree, 
    print_tree, 
    show_expr, @show_expr, 
    show_texpr, @show_texpr, 
    texpr2expr, teval, @teval

using InteractiveUtils: subtypes
using AbstractTrees

"""
    @show_sexpr(expr, linenums=false)

shows the lisp style S-expression of `expr` and prints the line number nodes if `linenums` is true.  This is the macro version of `Meta.show_sexpr`.

## Example

```julia
julia> @show_sexpr 2x+1
(:call, :+, (:call, :*, 2, :x), 1)
```

`teval` function can evaluate the output of `@show_sexpr`. 
```julia
julia> x = 10; (:call, :+, (:call, :*, 2, :x), 1) |> teval
21
```
"""
macro show_sexpr(expr, linenums=false)
    linenums || Base.remove_linenums!(expr)
    :(Meta.show_sexpr($(QuoteNode(expr))))
end

AbstractTrees.printnode(io::IO, expr::Expr) = show(io, expr.head)

"""
    @show_tree(expr, maxdepth=10, linenums=false)

shows the tree form of the expression `expr` with maxdepth and prints the line number nodes if `linenums` is true.

## Example
```julia
julia> @show_tree 2x+1
:call
├─ :+
├─ :call
│  ├─ :*
│  ├─ 2
│  └─ :x
└─ 1
```
"""
macro show_tree(expr, maxdepth=10, linenums=false)
    linenums || Base.remove_linenums!(expr)
    :(print_tree($(QuoteNode(expr)), $(esc(maxdepth))))
end

AbstractTrees.children(T::Type) = subtypes(T)

"""
    print_tree(T::Type, maxdepth=5; kwargs...)

prints the subtree of the type `T`.

## Example
```julia
julia> print_tree(AbstractRange)
AbstractRange
├─ LinRange
├─ OrdinalRange
│  ├─ AbstractUnitRange
│  │  ├─ IdentityUnitRange
│  │  ├─ OneTo
│  │  ├─ Slice
│  │  └─ UnitRange
│  └─ StepRange
└─ StepRangeLen
```
"""
print_tree

"""
    const expr_indent = 4

is the default indent of showing expressions.
"""
const expr_indent = 4

"""
    show_expr([io::IO,], ex)

shows expression `ex` as a Julia style expression.

# Examples
```julia
julia> show_expr(:(f(x, g(y, z))))
Expr(:call, :f, :x, 
    Expr(:call, :g, :y, :z))
```
"""
show_expr(io::IO, ex, inner; indent=expr_indent, head="Expr") = show(io, ex)
show_expr(io::IO, ex; indent=expr_indent, head="Expr") = show_expr(io, ex, 0; indent, head)
show_expr(ex; indent=expr_indent, head="Expr") = show_expr(stdout, ex; indent, head)

function show_expr(io::IO, ex::LineNumberNode, inner; indent=expr_indent, head="Expr")
    print(io, "LineNumberNode(")
    show(io, ex.line); print(io, ", ")
    show(io, ex.file); print(io, ')')
end

# See https://github.com/JuliaLang/julia/issues/6104#issuecomment-37262662
function show_expr(io::IO, ex::QuoteNode, inner; indent=expr_indent, head="Expr")
    print(io, "QuoteNode", "(")
    show_expr(io, ex.value, inner+indent; indent, head)
    print(io, ')')
end

function show_expr(io::IO, ex::Expr, inner; indent=expr_indent, head="Expr")
    iszero(inner) || print(io, "\n")
    print(io, " "^inner, head, "(")
    show_expr(io, ex.head, inner+indent; indent, head)
    for arg in ex.args
        print(io, ", ")
        show_expr(io, arg, inner+indent; indent, head)
    end
    isempty(ex.args) && print(io, ',')
    print(io, ')')
end

"""
    @show_expr(expr, linenums=false)

shows the Juia style expression of `expr` and prints the line number nodes if `linenums` is true.  This is the macro version of `show_expr`.

## Example

```julia
julia> @show_expr 2x+1
Expr(:call, :+, 
    Expr(:call, :*, 2, :x), 1)
```

`eval` function can evaluate the output of `@show_expr`. 

```julia
julia> x = 10; Expr(:call, :+, 
    Expr(:call, :*, 2, :x), 1) |> eval
21
```
"""
macro show_expr(expr, linenums=false)
    linenums || Base.remove_linenums!(expr)
    :(show_expr($(QuoteNode(expr))))
end

"""
    show_texpr([io::IO,], ex)

Yet another `Meta.show_sexpr`.  It shows expression `ex` as a lisp style expression.

Remark: The indentation is different from `Meta.show_sexpr`.

# Examples
```julia
julia> show_texpr(:(f(x, g(y, z))))
Expr(:call, :f, :x, 
    Expr(:call, :g, :y, :z))
```
"""
show_texpr(io::IO, ex; indent=expr_indent) = show_expr(io, ex; indent, head="")
show_texpr(ex; indent=expr_indent) = show_texpr(stdout, ex; indent)

"""
    @show_texpr(expr, linenums=false)

Yet another `@show_sexpr`.  It shows the lisp style S-expression of `expr` and prints the line number nodes if `linenums` is true.

Remark: The indentation is different from `@show_sexpr`.

## Example

```julia
julia> @show_texpr 2x+1
(:call, :+, 
    (:call, :*, 2, :x), 1)
```

`teval` function can evaluate the output of `@show_texpr`.

```julia
julia> x = 10; (:call, :+, 
    (:call, :*, 2, :x), 1) |> teval
21
```
"""
macro show_texpr(expr, linenums=false)
    linenums || Base.remove_linenums!(expr)
    :(show_texpr($(QuoteNode(expr))))
end

"""
    texpr2expr(x)

converts a lisp-like tuple expression `x` to the executable expression of Julia.

Example: The expression of `sin(π/6)`

```julia
julia> texpr2expr((:call, :sin, (:call, :/, π, 6)))
:(sin(π / 6))
```
"""
texpr2expr(x) = x
texpr2expr(q::QuoteNode) = QuoteNode(texpr2expr(q.value))

function texpr2expr(t::Tuple)
    isempty(t) && return :(())
    @assert t[1] isa Symbol "The first element of "*sprint(show, t)*" is not a Symbol."
    e = texpr2expr.(t)
    if isdefined(Main, e[1])
        f = Main.eval(e[1])
        !isa(f, Core.Builtin) && isa(f, Function) && return Expr(:call, e...)
    end
    Expr(e...)
end

"""
    teval(texpr)

evaluates the lisp-like tuple expression `texpr`.

Example: Calculation of `sin(π/6)`

```julia
julia> (:call, :sin, (:call, :/, π, 6)) |> teval
0.49999999999999994
```

In some cases, you can omit `:call`.

```julia
julia> (:sin, (:/, π, 6)) |> teval
0.49999999999999994
```
"""
teval(texpr) = Main.eval(texpr2expr(texpr))

"""
    @teval texpr

evaluates the lisp-like tuple expression `texpr`.

Example: Calculation of `sin(π/6)`

```julia
julia> @teval (:call, :sin, (:call, :/, π, 6))
0.49999999999999994
```

In some cases, you can omit `:call`.

```julia
julia> @teval (:sin, (:/, π, 6))
0.49999999999999994
```
"""
macro teval(texpr)
    esc(texpr2expr(Core.eval(__module__, texpr)))
end

"""
    MetaUtils.@t texpr

shows the Julia expression and the value of the lisp-like tuple expression `texpr`.

Example:

```julia
julia> MetaUtils.@t (:call, :sin, (:call, :/, π, 6))
:(sin(π / 6))
→ 0.49999999999999994
```
"""
macro t(x)
    expr = texpr2expr(Core.eval(__module__, x))
    show(expr); print("\n→ "); show(Core.eval(__module__, expr))
    print("\n")
end

"""
    MetaUtils.@T texpr

shows `show(texpr)`, `show_texpr(texpr)`, the Julia expression, and the value of the lisp-like tuple expression `texpr`.

Example:
```julia
julia> MetaUtils.@T (:call, :sin, (:call, :/, π, 6))
(:call, :sin, (:call, :/, π, 6))
→ (:call, :sin, 
    (:call, :/, π, 6))
→ :(sin(π / 6))
→ 0.49999999999999994
```
"""
macro T(x)
    code = Core.eval(__module__, x)
    expr = texpr2expr(code)
    show(code)
    print("\n→ "); show_texpr(expr); print("\n→ ")
    show(expr); print("\n→ "); show(Core.eval(__module__, expr))
    print("\n")
end

end
