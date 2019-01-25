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
        edge [arrowsize=0.5]
        subgraph cluster_1 {
            label="JOHN ⇒"
            rule1_n1[shape=point;label="";xlabel="3";fontsize=10]
            rule1_n2_1[shape=circle;width=0.05;label=""]
            rule1_n2_2[shape=circle;width=0.05;label=""]
            rule1_he1[shape=box;label="John"]
            rule1_he2[shape=box;label="LOVES"]
            {rule1_n2_1} -> rule1_he1 -> {rule1_n1}
            {rule1_n1} -> rule1_he2 -> {rule1_n2_2}
        }
        subgraph cluster_2 {
            label="LOVES ⇒"
            rule2_n1[shape=point;label="";xlabel="4";fontsize=10]
            rule2_n2_1[shape=circle;width=0.05;label=""]
            rule2_n2_2[shape=circle;width=0.05;label=""]
            rule2_he1[shape=box;label="loves"]
            rule2_he2[shape=box;label="MARY"]
            {rule2_n2_1} -> rule2_he1 -> {rule2_n1}
            {rule2_n1} -> rule2_he2 -> {rule2_n2_2}
        }
        subgraph cluster_3 {
            label="MARY ⇒"
            rule3_n1_1[shape=circle;width=0.05;label=""]
            rule3_n1_2[shape=circle;width=0.05;label=""]
            rule3_he1[shape=box;label="Mary"]
            {rule3_n1_1} -> rule3_he1 -> {rule3_n1_2}
        }
        subgraph cluster_4 {
            label="S ⇒"
            rule4_n1_1[shape=circle;width=0.05;label=""]
            rule4_n1_2[shape=circle;width=0.05;label=""]
            rule4_he1[shape=box;label="JOHN"]
            {rule4_n1_1} -> rule4_he1 -> {rule4_n1_2}
        }
    }
    """
    _test_normalized_strings_are_equal(rules_dot,expected)
    _print_dot(rules_dot)
end