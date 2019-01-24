#=
test_rules_visualization.jl:
- Julia version: 
- Author: bramb
- Date: 2019-01-24
=#

using Test

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
    """
    @test rules_dot == expected
    println(rules_dot)
end