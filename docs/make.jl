using MetaUtils
using Documenter

makedocs(;
    modules=[MetaUtils],
    authors="genkuroki <genkuroki@gmail.com> and contributors",
    repo="https://github.com/genkuroki/MetaUtils.jl/blob/{commit}{path}#L{line}",
    sitename="MetaUtils.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://genkuroki.github.io/MetaUtils.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/genkuroki/MetaUtils.jl",
)
