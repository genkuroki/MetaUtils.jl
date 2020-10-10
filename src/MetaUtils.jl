"""
    MetaUtils

Utilities for metaprogramming in Julia.

Exported: @show_sexpr, @show_tree, print_tree, show_expr, @show_expr, show_Sexpr, @show_Sexpr
"""
module MetaUtils

export @show_sexpr, @show_tree, print_tree, 
    show_expr, @show_expr, show_Sexpr, @show_Sexpr, 
    texpr2expr, @teval

using InteractiveUtils: subtypes
using AbstractTrees

"""
    @show_sexpr(expr, linenums=false)

shows the lisp style S-expression of `expr` and prints the line number nodes if `linenums` is true.

## Example

```julia
julia> @show_sexpr 2x+1
(:call, :+, (:call, :*, 2, :x), 1)
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
    show_expr([io::IO,], ex)

shows expression `ex` as a Julia style expression.

# Examples
```julia
julia> show_expr(:(f(x, g(y, z))))
Expr(:call, :f, :x, 
    Expr(:call, :g, :y, :z))
```
"""
show_expr(ex; indent=expr_indent, head="Expr") =
    show_expr(stdout, ex; indent, head)
show_expr(io::IO, ex; indent=expr_indent, head="Expr") =
    show_expr(io, ex, 0; indent, head)
show_expr(io::IO, ex, inner; indent=expr_indent, head="Expr") =
    show(io, ex)

const expr_indent = 4

function show_expr(io::IO, ex::QuoteNode, inner; indent=expr_indent, head="Expr")
    print(io, "(:quote, ")
    show_expr(io, ex.value, inner+indent; indent)
    print(io, ')')
end
function show_expr(io::IO, ex::Expr, inner; indent=expr_indent, head="Expr")
    print(io, (iszero(inner) ? "" : "\n"), " "^inner, "$head(")
    show_expr(io, ex.head, inner+indent; indent, head)
    for arg in ex.args
        print(io, ", ")
        show_expr(io, arg, inner+indent; indent, head)
    end
    if isempty(ex.args)
        print(io, ",)")
    else
        print(io, ')')
    end
end

"""
    @show_expr(expr, linenums=false)

shows the Juia style expression of `expr` and prints the line number nodes if `linenums` is true.

## Example

```julia
julia> @show_expr 2x+1
Expr(:call, :+, 
    Expr(:call, :*, 2, :x), 1)
```
"""
macro show_expr(expr, linenums=false)
    linenums || Base.remove_linenums!(expr)
    :(show_expr($(QuoteNode(expr))))
end

"""
    show_Sexpr([io::IO,], ex)

Yet another `Meta.show_sexpr`.  It shows expression `ex` as a lisp style expression.

Remark: The indentation is different from `Meta.show_sexpr`.

# Examples
```julia
julia> show_Sexpr(:(f(x, g(y, z))))
Expr(:call, :f, :x, 
    Expr(:call, :g, :y, :z))
```
"""
show_Sexpr(io::IO, ex; indent=expr_indent) = show_expr(io, ex; indent, head="")
show_Sexpr(ex; indent=expr_indent) = show_Sexpr(stdout, ex; indent)

"""
    @show_Sexpr(expr, linenums=false)

Yet another `@show_sexpr`.  It shows the lisp style S-expression of `expr` and prints the line number nodes if `linenums` is true.

Remark: The indentation is different from `@show_sexpr`.

## Example

```julia
julia> @show_Sexpr 2x+1
(:call, :+, 
    (:call, :*, 2, :x), 1)
```
"""
macro show_Sexpr(expr, linenums=false)
    linenums || Base.remove_linenums!(expr)
    :(show_Sexpr($(QuoteNode(expr))))
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

function texpr2expr(t::Tuple)
    isempty(t) && return :(())
    @assert t[1] isa Symbol "The first element of "*sprint(show, t)*" is not a Symbol."
    e = texpr2expr.(t)
    if isdefined(Main, e[1])
        f = Base.MainInclude.eval(e[1])
        !isa(f, Core.Builtin) && isa(f, Function) && return Expr(:call, e...)
    end
    Expr(e...)
end

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
    texpr2expr(Base.MainInclude.eval(texpr))
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
    expr = texpr2expr(Base.MainInclude.eval(x))
    show(expr); print("\n→ "); show(Core.eval(Main, expr))
end

"""
    MetaUtils.@T texpr

shows `show(texpr)`, `show_Sexpr(texpr)`, the Julia expression, and the value of the lisp-like tuple expression `texpr`.

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
    code = Base.MainInclude.eval(x)
    expr = texpr2expr(code)
    show(code)
    print("\n→ "); show_Sexpr(expr); print("\n→ ")
    show(expr); print("\n→ "); show(Core.eval(Main, expr))
end

end
