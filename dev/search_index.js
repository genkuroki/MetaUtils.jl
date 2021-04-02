var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = MetaUtils","category":"page"},{"location":"#MetaUtils","page":"Home","title":"MetaUtils","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [MetaUtils]","category":"page"},{"location":"#MetaUtils.MetaUtils","page":"Home","title":"MetaUtils.MetaUtils","text":"MetaUtils\n\ncontains utilities for metaprogramming in Julia.\n\nexport @show_sexpr, \n    @show_tree, \n    print_subtypes, \n    show_expr, @show_expr, \n    show_texpr, @show_texpr, \n    texpr2expr, teval, @teval\n\n\n\n\n\n","category":"module"},{"location":"#MetaUtils.expr_indent","page":"Home","title":"MetaUtils.expr_indent","text":"const expr_indent = 4\n\nis the default indent of showing expressions.\n\n\n\n\n\n","category":"constant"},{"location":"#MetaUtils.print_subtypes-Tuple{Type}","page":"Home","title":"MetaUtils.print_subtypes","text":"print_subtypes(T::Type; kwargs...)\nprint_subtypes(io::IO, T::Type; kwargs...)\nprint_subtypes(f, io::IO, T::Type; kwargs...)\n\nprints the subtypes of T by AbstractTrees.print_tree.\n\nExample\n\njulia> print_subtypes(AbstractRange)\nAbstractRange\n├─ LinRange\n├─ OrdinalRange\n│  ├─ AbstractUnitRange\n│  │  ├─ Base.IdentityUnitRange\n│  │  ├─ Base.OneTo\n│  │  ├─ Base.Slice\n│  │  └─ UnitRange\n│  └─ StepRange\n└─ StepRangeLen\n\n\n\n\n\n","category":"method"},{"location":"#MetaUtils.show_expr-Tuple{IO,Any,Any}","page":"Home","title":"MetaUtils.show_expr","text":"show_expr([io::IO,], ex)\n\nshows expression ex as a Julia style expression.\n\nExamples\n\njulia> show_expr(:(f(x, g(y, z))))\nExpr(:call, :f, :x, \n    Expr(:call, :g, :y, :z))\n\n\n\n\n\n","category":"method"},{"location":"#MetaUtils.show_texpr-Tuple{IO,Any}","page":"Home","title":"MetaUtils.show_texpr","text":"show_texpr([io::IO,], ex)\n\nYet another Meta.show_sexpr.  It shows expression ex as a lisp style expression.\n\nRemark: The indentation is different from Meta.show_sexpr.\n\nExamples\n\njulia> show_texpr(:(f(x, g(y, z))))\nExpr(:call, :f, :x, \n    Expr(:call, :g, :y, :z))\n\n\n\n\n\n","category":"method"},{"location":"#MetaUtils.teval","page":"Home","title":"MetaUtils.teval","text":"teval(texpr, m::Module=Main)\n\nevaluates the lisp-like tuple expression texpr.\n\nExample: Calculation of sin(π/6)\n\njulia> (:call, :sin, (:call, :/, π, 6)) |> teval\n0.49999999999999994\n\nIn some cases, you can omit :call.\n\njulia> (:sin, (:/, π, 6)) |> teval\n0.49999999999999994\n\n\n\n\n\n","category":"function"},{"location":"#MetaUtils.texpr2expr","page":"Home","title":"MetaUtils.texpr2expr","text":"texpr2expr(x, m::Module=Main)\n\nconverts a lisp-like tuple expression x to the executable expression of Julia.\n\nExample: The expression of sin(π/6)\n\njulia> texpr2expr((:call, :sin, (:call, :/, π, 6)))\n:(sin(π / 6))\n\n\n\n\n\n","category":"function"},{"location":"#MetaUtils.@T-Tuple{Any}","page":"Home","title":"MetaUtils.@T","text":"MetaUtils.@T texpr\n\nshows show(texpr), show_texpr(texpr), the Julia expression, and the value of the lisp-like tuple expression texpr.\n\nExample:\n\njulia> MetaUtils.@T (:call, :sin, (:call, :/, π, 6))\n(:call, :sin, (:call, :/, π, 6))\n→ (:call, :sin, \n    (:call, :/, π, 6))\n→ :(sin(π / 6))\n→ 0.49999999999999994\n\n\n\n\n\n","category":"macro"},{"location":"#MetaUtils.@show_expr","page":"Home","title":"MetaUtils.@show_expr","text":"@show_expr(expr, linenums=false)\n\nshows the Juia style expression of expr and prints the line number nodes if linenums is true.  This is the macro version of show_expr.\n\nExample\n\njulia> @show_expr 2x+1\nExpr(:call, :+, \n    Expr(:call, :*, 2, :x), 1)\n\neval function can evaluate the output of @show_expr. \n\njulia> x = 10; Expr(:call, :+, \n    Expr(:call, :*, 2, :x), 1) |> eval\n21\n\n\n\n\n\n","category":"macro"},{"location":"#MetaUtils.@show_sexpr","page":"Home","title":"MetaUtils.@show_sexpr","text":"@show_sexpr(expr, linenums=false)\n\nshows the lisp style S-expression of expr and prints the line number nodes if linenums is true.  This is the macro version of Meta.show_sexpr.\n\nExample\n\njulia> @show_sexpr 2x+1\n(:call, :+, (:call, :*, 2, :x), 1)\n\nteval function can evaluate the output of @show_sexpr. \n\njulia> x = 10; (:call, :+, (:call, :*, 2, :x), 1) |> teval\n21\n\n\n\n\n\n","category":"macro"},{"location":"#MetaUtils.@show_texpr","page":"Home","title":"MetaUtils.@show_texpr","text":"@show_texpr(expr, linenums=false)\n\nYet another @show_sexpr.  It shows the lisp style S-expression of expr and prints the line number nodes if linenums is true.\n\nRemark: The indentation is different from @show_sexpr.\n\nExample\n\njulia> @show_texpr 2x+1\n(:call, :+, \n    (:call, :*, 2, :x), 1)\n\nteval function can evaluate the output of @show_texpr.\n\njulia> x = 10; (:call, :+, \n    (:call, :*, 2, :x), 1) |> teval\n21\n\n\n\n\n\n","category":"macro"},{"location":"#MetaUtils.@show_tree","page":"Home","title":"MetaUtils.@show_tree","text":"@show_tree(expr, maxdepth=10, linenums=false)\n\nshows the tree form of the expression expr with maxdepth and prints the line number nodes if linenums is true.\n\nExample\n\njulia> @show_tree 2x+1\nExpr(:call)\n├─ :+\n├─ Expr(:call)\n│  ├─ :*\n│  ├─ 2\n│  └─ :x\n└─ 1\n\n\n\n\n\n","category":"macro"},{"location":"#MetaUtils.@t-Tuple{Any}","page":"Home","title":"MetaUtils.@t","text":"MetaUtils.@t texpr\n\nshows the Julia expression and the value of the lisp-like tuple expression texpr.\n\nExample:\n\njulia> MetaUtils.@t (:call, :sin, (:call, :/, π, 6))\n:(sin(π / 6))\n→ 0.49999999999999994\n\n\n\n\n\n","category":"macro"},{"location":"#MetaUtils.@teval-Tuple{Any}","page":"Home","title":"MetaUtils.@teval","text":"@teval texpr\n\nevaluates the lisp-like tuple expression texpr.\n\nExample: Calculation of sin(π/6)\n\njulia> @teval (:call, :sin, (:call, :/, π, 6))\n0.49999999999999994\n\nIn some cases, you can omit :call.\n\njulia> @teval (:sin, (:/, π, 6))\n0.49999999999999994\n\n\n\n\n\n","category":"macro"}]
}
