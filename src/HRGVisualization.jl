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

export to_dot, HRGrammarRules, HyperEdge, test

include("types.jl") # the type definitions should come from the main HRG module

function to_dot(he::HyperEdge)
    source = ""
    source_vars = String[]
    for (i,s) in enumerate(he.source)
        line = """
        s$i[shape=circle;width=0.05;label="";xlabel="$s";fontsize=10]
        """
        source = source * line
        push!(source_vars,"s$i")
    end
    sv = join(source_vars,",")

    target = ""
    target_vars = String[]
    for (i,t) in enumerate(he.target)
        line = """
        t$i[shape=circle;width=0.05;label="";xlabel="$t";fontsize=10]
        """
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
end

function to_dot(hg::HyperGraph)
    hyperedges = ""
    node_vars = Dict{Node,String}()
    node_set = Set()
    for (i,he) in enumerate(hg)
        map(n -> push!(node_set,n), vcat(he.source,he.target))
        line = """
        he$i[shape=box;label="$(he.label)"]
        """
        hyperedges = hyperedges * line
    end

    nodes = ""
    for (i,n) in enumerate(sort(collect(node_set)))
        var = "n$i"
        node_vars[n] = var
        line = """
        $var[shape=circle;width=0.05;label="";xlabel="$n";fontsize=10]
        """
        nodes = nodes * line
    end

    edges = ""
    for (i,he) in enumerate(hg)
        source_vars = [node_vars[s] for s in he.source]
        sv = join(source_vars,",")

        target_vars = [node_vars[t] for t in he.target]
        tv = join(target_vars,",")

        line = """
        {$sv} -> he$i -> {$tv} [arrowsize=0.5]
        """
        edges = edges * line
    end

    dot = """
    digraph HyperGraph {
    rankdir=LR
    labelloc=b
    color=white

    // nodes
    $nodes
    // hyper-edges
    $hyperedges
    // edges
    $edges
    }
    """
end

function to_dot(hg::HRGrammarRules)
    dot = """
    Hello Rules
    """
end

function test()
    println("Hello HRG and dev World ")
end

end