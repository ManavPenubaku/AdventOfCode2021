cur_dir = pwd()
inp_path = cur_dir * "/input/day7.txt"
file = open(inp_path)
lines = readlines(file)

input = parse.(Int,String.(reduce(hcat,split.(lines,","))))

function FindCheapestOutcome(input)
    possible_endpoints = collect(minimum(input):1:maximum(input))
    fuel_cost = map(x->sum(abs.(input.-x)),possible_endpoints);
    return fuel_cost[findall(x->x.==minimum(fuel_cost),fuel_cost)]
end

function FindCheapestOutcome2(input)
    possible_endpoints = collect(minimum(input):1:maximum(input))
    fuel_cost = map(x->abs.(input.-x),possible_endpoints);
    fuel_cost_progression = map(x->sum((x.*(2 .+ (x.-1)))./2),fuel_cost)
    return fuel_cost_progression[findall(x->x.==minimum(fuel_cost_progression),fuel_cost_progression)]
end

sol1 = FindCheapestOutcome(input)
println("Solution for Part 1 is : ",sol1[1])
sol2 = FindCheapestOutcome2(input)
println("Solution for Part 2 is : ",convert(Int,sol2[1]))