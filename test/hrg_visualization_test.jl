using HRGVisualization

function test1
    he1 = HyperEdge("S", ["1"], ["2"])
    he_dot = to_dot(he1)
    println(he_dot)

    he2 = HyperEdge("X", ["1", "3"], ["2", "4"])
    he_dot = to_dot(he2)
    println(he_dot)

    he3 = HyperEdge("Y", ["2", "4"], ["5"])
    he4 = HyperEdge("Z", ["5"], ["6", "7", "8"])
    hg = HyperEdge[]
    map(he -> push!(hg,he), [he1, he2, he3, he4])

    hg_dot = to_dot(hg)
    println(hg_dot)

    rules = HRGrammarRules(
        "S" => [HyperEdge("JOHN", ["_"], ["_"])],
        "JOHN" => [HyperEdge("John", ["_"], ["3"]), HyperEdge("LOVES",["3"], ["_"])],
        "LOVES" => [HyperEdge("loves", ["_"], ["4"]), HyperEdge("MARY", ["4"], ["_"])],
        "MARY" => [HyperEdge("Mary", ["_"], ["_"])]
    )
    rules_dot = to_dot(rules)
    println(rules_dot)
end