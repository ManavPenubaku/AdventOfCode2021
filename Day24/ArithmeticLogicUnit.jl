using DelimitedFiles

input = readdlm("input.txt")

function RunSubsetInstructions(input,variable_dict_in,x1,x2)
    instructions_1 = input[x1:x2,:]
    check_string = ""
    for number in 1:1:9
        variable_dict = deepcopy(variable_dict_in)
        for instruction in 1:size(instructions_1,1)
            if (haskey(variable_dict,instructions_1[instruction,3]))
                temp_var = variable_dict[instructions_1[instruction,3]]
            else
                temp_var = instructions_1[instruction,3]
            end
            if instructions_1[instruction,1] == "inp"
                variable_dict[instructions_1[instruction,2]] = number
            elseif instructions_1[instruction,1] == "mul"
                variable_dict[instructions_1[instruction,2]] *= temp_var
            elseif instructions_1[instruction,1] == "add"
                variable_dict[instructions_1[instruction,2]] += temp_var
            elseif instructions_1[instruction,1] == "div" && temp_var != 0
                variable_dict[instructions_1[instruction,2]] = floor(Int,variable_dict[instructions_1[instruction,2]]/temp_var)
            elseif instructions_1[instruction,1] == "mod" && temp_var > 0 && variable_dict[instructions_1[instruction,2]] >= 0
                variable_dict[instructions_1[instruction,2]] = mod(variable_dict[instructions_1[instruction,2]],temp_var)
            else
                variable_dict[instructions_1[instruction,2]] = variable_dict[instructions_1[instruction,2]] == temp_var ? 1 : 0
            end
        end
        if variable_dict["z"] == 0
            return string(number)
        elseif x2<=234
            check_string = RunSubsetInstructions(input,variable_dict,x1+18,x2+18)
            if check_string != "0"
                return string(number)*check_string
            end
        end
    end
    return "0"
end

function RunMONAD(input)
    variable_dict = Dict("w" => 0,"x" => 0,"y" => 0,"z" => 0)
    sol1 = RunSubsetInstructions(input,variable_dict,1,18)
end

sol1 = RunMONAD(input)