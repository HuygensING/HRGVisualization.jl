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
    source_buf = IOBuffer()
    source_vars = String[]
    for (i,s) in enumerate(he.source)
        shape = _node_shape(s)
        line = """
            s$i[shape=$shape;label="";xlabel="$s";fontsize=10]
        """
        print(source_buf,line)
        push!(source_vars,"s$i")
    end
    sv = join(source_vars,",")

    target_buf = IOBuffer()
    target_vars = String[]
    for (i,t) in enumerate(he.target)
        shape = _node_shape(t)
        line = """
            t$i[shape=$shape;label="";xlabel="$t";fontsize=10]
        """
        print(target_buf,line)
        push!(target_vars,"t$i")
    end
    tv = join(target_vars,",")

    source = String(take!(source_buf))
    target = String(take!(target_buf))
    dot = """
    digraph HyperEdge {
        rankdir=LR
        labelloc=b
        color=white
        edge [arrowsize=0.5]
        $source
        he[shape=box;label="$(he.label)"]
        $target
        {$sv} -> he -> {$tv}
    }
    """
    return dot
end

function to_dot(hg::HyperGraph)
    hypergraph = _hypergraph_as_dot(hg)

    dot = """
    digraph HyperGraph {
        rankdir=LR
        labelloc=b
        color=white
        edge [arrowsize=0.5]
        $hypergraph
    }
    """
    return dot
end

function to_dot(rules::HRGrammarRules)
    replacements_buf = IOBuffer()

    for (i,lhs) in enumerate(sort(collect(keys(rules))))
        rhs = rules[lhs]
        hypergraph = _hypergraph_as_dot(rhs,"rule$(i)_")

        cluster = """
        subgraph cluster_$i {
            label="$lhs ⇒"
            $hypergraph
        }
        """
        print(replacements_buf,cluster)
    end

    replacements = String(take!(replacements_buf))
    dot = """
    digraph HRG_Rules {
        rankdir=LR
        edge [arrowsize=0.5]
        $replacements
    }
    """
    return dot
end

function _hypergraph_as_dot(hg::HyperGraph, prefix::String="")
    hyperedges_buf = IOBuffer()
    node_vars = Dict{Node,String}()
    node_set = Set()

    # collect all source and target nodes of all the hyperedges in the hypergraph, and count the external nodes "_"
    for (i,he) in enumerate(hg)
        map(n -> push!(node_set,n), vcat(he.source,he.target))
        # the "_" stands for a unique external node, so these should be handled differently
        # we can keep a placeholder in the node_vars

        line = """
        $(prefix)he$i[shape=box;label="$(he.label)"]
        """
        print(hyperedges_buf,line)
    end

    external_node_count = _external_node_count(hg)
    nodes_buf = IOBuffer()
    for (i,n) in enumerate(sort(collect(node_set)))
        var = "$(prefix)n$i"
        node_vars[n] = var
        if (n == "_")
            for j in 1:external_node_count
                node_def = """
                $(var)_$(j)[shape=circle;width=0.05;label=""]
                """
                print(nodes_buf,node_def)
            end
        else
            node_def = """
            $(var)[shape=point;label="";xlabel="$n";fontsize=10]
            """
            print(nodes_buf,node_def)
        end
    end

    edges_buf = IOBuffer()
    external_node_counter = 0
    for (i,he) in enumerate(hg)
        source_vars = []
        for s in he.source
            source_var = node_vars[s]
            if s == "_"
                external_node_counter = external_node_counter + 1
                source_var = "$(source_var)_$(external_node_counter)"
            end
            push!(source_vars,source_var)
        end
        sv = join(source_vars,",")

        target_vars = []
        for t in he.target
            target_var = node_vars[t]
            if t == "_"
                external_node_counter = external_node_counter + 1
                target_var = "$(target_var)_$(external_node_counter)"
            end
            push!(target_vars,target_var)
        end
        tv = join(target_vars,",")

        line = """
            {$sv} -> $(prefix)he$i -> {$tv}
        """
        print(edges_buf,line)
    end

    nodes = String(take!(nodes_buf))
    hyperedges = String(take!(hyperedges_buf))
    edges = String(take!(edges_buf))
    dot = """
    $nodes
    $hyperedges
    $edges
    """
    return dot
end

function _node_shape(label::String)
    return label == "_" ? "" : "point"
end

function _external_node_count(hg::HyperGraph)
    nodes = String[]
    for he in hg
        nodes = vcat(nodes, vcat(he.source,he.target))
    end
    return count(n -> (n == "_"), nodes)
end

end