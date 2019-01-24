const Node = Any

struct HyperEdge
    label::String
    source::Array{Node}
    target::Array{Node}
end

const HyperGraph = Array{HyperEdge}

const HRGrammarRules = Dict{String,HyperGraph}
