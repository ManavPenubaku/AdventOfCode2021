file = open("input.txt")
lines = readlines(file)

polymer_template = lines[1]

polymer_template_dict = Dict()
for n in 1:length(polymer_template)-1
    if (haskey(polymer_template_dict,polymer_template[n:n+1]))
        polymer_template_dict[polymer_template[n:n+1]] += 1
    else
        polymer_template_dict[polymer_template[n:n+1]] = 1
    end
end

pair_insertions = reduce(hcat,split.(lines[3:end]," -> "))
pair_insertion_dict = Dict(String.(pair_insertions[1,:]) .=> String.(pair_insertions[2,:]))

function UpdatePolymer(polymer_dict,insertion_dict)
    updated_polymer_dict = Dict()
    pairs = collect(keys(polymer_dict))
    for n in 1:length(pairs)
        insertion = insertion_dict[pairs[n]]
        new_pair_1 = pairs[n][1] * insertion
        new_pair_2 = insertion * pairs[n][2] 
        if (haskey(updated_polymer_dict,new_pair_1))
            updated_polymer_dict[new_pair_1] += polymer_dict[pairs[n]]
        else
            updated_polymer_dict[new_pair_1] = polymer_dict[pairs[n]]
        end
        if (haskey(updated_polymer_dict,new_pair_2))
            updated_polymer_dict[new_pair_2] += polymer_dict[pairs[n]]
        else
            updated_polymer_dict[new_pair_2] = polymer_dict[pairs[n]]
        end
    end
    return updated_polymer_dict
end

function RepeatUpdates(polymer_template,pair_insertion_dict,step_count)
    for iter in 1:step_count
        polymer_template = UpdatePolymer(polymer_template,pair_insertion_dict)
    end
    element_dict = Dict()
    pairs_final = collect(keys(polymer_template))
    for n in 1:length(polymer_template)
        if (haskey(element_dict,pairs_final[n][1]))
            element_dict[pairs_final[n][1]] += polymer_template[pairs_final[n]]
        else
            element_dict[pairs_final[n][1]] = polymer_template[pairs_final[n]]
        end
        if (haskey(element_dict,pairs_final[n][2]))
            element_dict[pairs_final[n][2]] += polymer_template[pairs_final[n]]
        else
            element_dict[pairs_final[n][2]] = polymer_template[pairs_final[n]]
        end
    end
    return element_dict
end

character_count_p1 = RepeatUpdates(polymer_template_dict,pair_insertion_dict,10)
println("Solution to Part 1 is : ", ceil(Int,(maximum(values(character_count_p1))-minimum(values(character_count_p1)))/2))
character_count_p2 = RepeatUpdates(polymer_template_dict,pair_insertion_dict,40)
println("Solution to Part 2 is : ", ceil(Int,(maximum(values(character_count_p2))/2-minimum(values(character_count_p2))/2)))