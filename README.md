# MetaUtils - Utilities for metaprogramming in Julia

<!--
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://genkuroki.github.io/MetaUtils.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://genkuroki.github.io/MetaUtils.jl/dev)
[![Build Status](https://travis-ci.com/genkuroki/MetaUtils.jl.svg?branch=master)](https://travis-ci.com/genkuroki/MetaUtils.jl)
-->

This package provides the utilities not found in InteractiveUtils and Meta modules.  This is the renamed and enhanced version of the deprecated package [InteractiveUtilsPlus.jl](https://github.com/genkuroki/InteractiveUtilsPlus.jl).

## Installation

Add this package by REPL package manager:

```julia
julia> ]
pkg> add https://github.com/genkuroki/MetaUtils.jl
```

Or, add this package using Pkg.jl.

```julia
julia> using Pkg; Pkg.add(url="https://github.com/genkuroki/MetaUtils.jl")
```

## Examples

For the detaild usage, see the Jupyter notebook [MetaUtils.ipynb](https://nbviewer.jupyter.org/github/genkuroki/MetaUtils.jl/blob/master/MetaUtils.ipynb).

```julia
julia> using MetaUtils
```

```julia
julia> @show_sexpr 2x+1
(:call, :+, (:call, :*, 2, :x), 1)
```

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

```julia
julia> show_expr(:(f(x, g(y, z))))
Expr(:call, :f, :x, 
    Expr(:call, :g, :y, :z))
```

```julia
julia> @show_expr 2x+1
Expr(:call, :+, 
    Expr(:call, :*, 2, :x), 1)
```

```julia
julia> show_Sexpr(:(f(x, g(y, z))))
Expr(:call, :f, :x, 
    Expr(:call, :g, :y, :z))
```

```julia
julia> @show_Sexpr 2x+1
(:call, :+, 
    (:call, :*, 2, :x), 1)
```

```julia
julia> @teval (:call, :sin, (:call, :/, π, 6))
0.49999999999999994
```

```julia
julia> @teval (:sin, (:/, π, 6))
0.49999999999999994
```

```julia
julia> MetaUtils.@t (:call, :sin, (:call, :/, π, 6))
:(sin(π / 6))
→ 0.49999999999999994
```

```julia
julia> MetaUtils.@T (:call, :sin, (:call, :/, π, 6))
(:call, :sin, (:call, :/, π, 6))
→ (:call, :sin, 
    (:call, :/, π, 6))
→ :(sin(π / 6))
→ 0.49999999999999994
```
