using DelimitedFiles

input = readdlm("input.txt")

function RunSubsetInstructions(input,variable_dict_in,x1,x2)
    instructions_1 = input[x1:x2,:]
    variable_dict_out = Dict()
    println(x2)
    if instructions_1[6,3] <= 0
        max_value = 9 - instructions_1[6,3]
        min_value = 1 - instructions_1[6,3]
        variable_dict_in = filter(p->min_value <= mod(p.second["z"],26) <= max_value,variable_dict_in)
        # max_mod = maximum(map(x->mod(x["z"],26),collect(values(variable_dict_in))))
        # highest_digit = max_mod + instructions_1[6,3]
        # range = highest_digit
        # variable_dict_in = filter(p-> mod(p.second["z"],26) == max_mod, variable_dict_in)
        min_mod = minimum(map(x->mod(x["z"],26),collect(values(variable_dict_in))))
        lowest_digit = min_mod + instructions_1[6,3]
        range = lowest_digit
        variable_dict_in = filter(p-> mod(p.second["z"],26) == min_mod, variable_dict_in)
    else
        range = 1:1:9
    end

    for (model_number, values) in variable_dict_in
        for number in range
            copy_values = deepcopy(values)
            for instruction in 1:size(instructions_1,1)
                if (haskey(copy_values,instructions_1[instruction,3]))
                    temp_var = copy_values[instructions_1[instruction,3]]
                else
                    temp_var = instructions_1[instruction,3]
                end
                if instructions_1[instruction,1] == "inp"
                    copy_values[instructions_1[instruction,2]] = number
                elseif instructions_1[instruction,1] == "mul"
                    copy_values[instructions_1[instruction,2]] *= temp_var
                elseif instructions_1[instruction,1] == "add"
                    copy_values[instructions_1[instruction,2]] += temp_var
                elseif instructions_1[instruction,1] == "div" && temp_var != 0
                    copy_values[instructions_1[instruction,2]] = floor(Int,copy_values[instructions_1[instruction,2]]/temp_var)
                elseif instructions_1[instruction,1] == "mod" && temp_var > 0 && values[instructions_1[instruction,2]] >= 0
                    copy_values[instructions_1[instruction,2]] = mod(copy_values[instructions_1[instruction,2]],temp_var)
                else
                    copy_values[instructions_1[instruction,2]] = copy_values[instructions_1[instruction,2]] == temp_var ? 1 : 0
                end
            end
            variable_dict_out[model_number * string(number)] = copy_values
        end
    end
    
    if x2<=234
        RunSubsetInstructions(input,variable_dict_out,x1+18,x2+18)
    else
        return variable_dict_out
    end
end

function RunMONAD(input)
    variable_dict = Dict("" => Dict("w" => 0,"x" => 0,"y" => 0,"z" => 0))
    model_number_list = RunSubsetInstructions(input,variable_dict,1,18)
    sol1 = filter(p->p.second["z"] == 0,model_number_list)
    return sol1
end

sol1 = RunMONAD(input)