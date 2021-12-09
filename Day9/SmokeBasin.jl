file = open("input.txt")
lines = readlines(file)
input = parse.(Int,reduce(hcat,split.(lines,"")))


function FindLowestPoints(input)
    padded_input = deepcopy(input)
    padded_input = [ones(Int,size(input,1),1).*10 padded_input ones(Int,size(input,1),1).*10]
    padded_input = [ones(Int,1,size(padded_input,2)).*10;padded_input;ones(Int,1,size(padded_input,2)).*10]
    risk_level = 0;
    lowest_point_array = Array{Int}(undef,1,2)
    for i in 2:size(padded_input,1)-1
        for j in 2:size(padded_input,2)-1
            neighbors = [padded_input[i+1,j] padded_input[i-1,j] padded_input[i,j+1] padded_input[i,j-1]]
            if (sum(padded_input[i,j] .< neighbors) == 4)
                risk_level += (padded_input[i,j]+1)
                lowest_point_array = vcat(lowest_point_array,[i j])
            end
        end
    end 
    return risk_level,lowest_point_array[2:end,:]
end

sol1,lowest_point_list = FindLowestPoints(input)

smoke_basin = deepcopy(input)
smoke_basin[findall(x->x != 9,smoke_basin)] .= 0

open("smoke_basin.txt","w") do file
    for n in 1:size(smoke_basin,1)
        println(join(string.(smoke_basin[:,n])))
    end
end