using StatsBase

file = open("input.txt")
lines = readlines(file)

polymer_template = lines[1]

pair_insertions = reduce(hcat,split.(lines[3:end]," -> "))
pair_insertion_dict = Dict(String.(pair_insertions[1,:]) .=> String.(pair_insertions[2,:]))

function UpdatePolymer(polymer,pairs_dict)
    updated_polymer = deepcopy(polymer)
    for n in 1:length(polymer)-1
        updated_polymer = updated_polymer[1:2*n-1] * pairs_dict[polymer[n:n+1]] * updated_polymer[2*n:end]
    end
    return updated_polymer
end

function RepeatUpdates(polymer_template,pair_insertion_dict,step_count)
    for iter in 1:step_count
        polymer_template = UpdatePolymer(polymer_template,pair_insertion_dict)
        println(iter)
    end
    character_counts = countmap(polymer_template)
    println("Solution to Part 1 is : ",maximum(values(character_counts))-minimum(values(character_counts)))
end

RepeatUpdates(polymer_template,pair_insertion_dict,10)
println(polymer_template)
RepeatUpdates(polymer_template,pair_insertion_dict,40)