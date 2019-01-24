#=
test_rules_visualization.jl:
- Julia version: 
- Author: bramb
- Date: 2019-01-24
=#

using Test

include("util.jl")

@testset "rules_visualization" begin
    using HRGVisualization
    rules = HRGrammarRules(
        "S" => [HyperEdge("JOHN", ["_"], ["_"])],
        "JOHN" => [HyperEdge("John", ["_"], ["3"]), HyperEdge("LOVES",["3"], ["_"])],
        "LOVES" => [HyperEdge("loves", ["_"], ["4"]), HyperEdge("MARY", ["4"], ["_"])],
        "MARY" => [HyperEdge("Mary", ["_"], ["_"])]
    )
    rules_dot = to_dot(rules)
    expected = """
    digraph HRG_Rules {
        rankdir=LR
        //replacement hypergraphs
        subgraph cluster_1 {
            label="LOVES ⇒"
            // nodes
            rule_1_n1[shape=point;label="";xlabel="4";fontsize=10]
            rule_1_n2[shape=circle;width=0.05;label="";xlabel="_";fontsize=10]
            // hyper-edges
            rule_1_he1[shape=box;label="loves"]
            rule_1_he2[shape=box;label="MARY"]
            // edges
            {rule_1_n2} -> rule_1_he1 -> {rule_1_n1} [arrowsize=0.5]
            {rule_1_n1} -> rule_1_he2 -> {rule_1_n2} [arrowsize=0.5]
        }
        subgraph cluster_2 {
            label="MARY ⇒"
            // nodes
            rule_2_n1[shape=circle;width=0.05;label="";xlabel="_";fontsize=10]
            // hyper-edges
            rule_2_he1[shape=box;label="Mary"]
            // edges
            {rule_2_n1} -> rule_2_he1 -> {rule_2_n1} [arrowsize=0.5]
        }
        subgraph cluster_3 {
            label="JOHN ⇒"
            // nodes
            rule_3_n1[shape=point;label="";xlabel="3";fontsize=10]
            rule_3_n2[shape=circle;width=0.05;label="";xlabel="_";fontsize=10]
            // hyper-edges
            rule_3_he1[shape=box;label="John"]
            rule_3_he2[shape=box;label="LOVES"]
            // edges
            {rule_3_n2} -> rule_3_he1 -> {rule_3_n1} [arrowsize=0.5]
            {rule_3_n1} -> rule_3_he2 -> {rule_3_n2} [arrowsize=0.5]
        }
        subgraph cluster_4 {
            label="S ⇒"
            // nodes
            rule_4_n1[shape=circle;width=0.05;label="";xlabel="_";fontsize=10]
            // hyper-edges
            rule_4_he1[shape=box;label="JOHN"]
            // edges
            {rule_4_n1} -> rule_4_he1 -> {rule_4_n1} [arrowsize=0.5]
        }
    }
    """
    _test_normalized_strings_are_equal(rules_dot,expected)
    _print_dot(rules_dot)
end