"""
# module HRGVisualization

- Julia version: 
- Author: bramb
- Date: 2019-01-24

# Examples

```jldoctest
julia>
```
"""
module HRGVisualization

export to_dot,
       HRGrammarRules,
       HyperEdge

include("types.jl") # the type definitions should come from the main HRG module

function to_dot(he::HyperEdge)
    source = ""
    source_vars = String[]
    for (i,s) in enumerate(he.source)
        shape = node_shape(s)
        line = """    s$i[shape=$shape;label="";xlabel="$s";fontsize=10]"""
        source = source * line
        push!(source_vars,"s$i")
    end
    sv = join(source_vars,",")

    target = ""
    target_vars = String[]
    for (i,t) in enumerate(he.target)
        shape = node_shape(t)
        line = """    t$i[shape=$shape;label="";xlabel="$t";fontsize=10]"""
        target = target * line
        push!(target_vars,"t$i")
    end
    tv = join(target_vars,",")

    dot = """
    digraph HyperEdge {
        rankdir=LR
        labelloc=b
        color=white
        $source
        he[shape=box;label="$(he.label)"]
        $target
        {$sv} -> he -> {$tv} [arrowsize=0.5]
    }
    """
    return dot
end

function to_dot(hg::HyperGraph)
    hypergraph = hypergraph_as_dot(hg)

    dot = """
    digraph HyperGraph {
        rankdir=LR
        labelloc=b
        color=white
        $hypergraph
    }
    """
    return dot
end

function to_dot(rules::HRGrammarRules)
    replacements = ""

    for (i,lhs) in enumerate(reverse(collect(keys(rules))))
        rhs = rules[lhs]
        hypergraph = hypergraph_as_dot(rhs,"rule_$(i)_")

        cluster = """
        subgraph cluster_$i {
            label="$lhs ⇒"
            $hypergraph
        }
        """
        replacements = replacements * cluster
    end

    dot = """
    digraph HRG_Rules {
        rankdir=LR

        //replacement hypergraphs
        $replacements
    }
    """
    return dot
end

function hypergraph_as_dot(hg::HyperGraph, prefix::String="")
    hyperedges = ""
    node_vars = Dict{Node,String}()
    node_set = Set()
    for (i,he) in enumerate(hg)
        map(n -> push!(node_set,n), vcat(he.source,he.target))
        line = """    $(prefix)he$i[shape=box;label="$(he.label)"]"""
        hyperedges = hyperedges * line
    end

    external_node_counter = 1
    nodes = ""
    for (i,n) in enumerate(sort(collect(node_set)))
        var = "$(prefix)n$i"
        node_vars[n] = var
        shape = node_shape(n)
        line = """    $var[shape=$shape;label="";xlabel="$n";fontsize=10]"""
        nodes = nodes * line
    end

    edges = ""
    for (i,he) in enumerate(hg)
        source_vars = [node_vars[s] for s in he.source]
        sv = join(source_vars,",")

        target_vars = [node_vars[t] for t in he.target]
        tv = join(target_vars,",")

        line = """    {$sv} -> $(prefix)he$i -> {$tv} [arrowsize=0.5]"""
        edges = edges * line
    end

    dot = """
    // nodes
    $nodes
    // hyper-edges
    $hyperedges
    // edges
    $edges
    """
end

function node_shape(label::String)
    return label == "_" ? "circle;width=0.05" : "point"
end

end