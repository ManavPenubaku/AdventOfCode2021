file = open("input.txt")
lines = readlines(file)
input = parse.(Int,reduce(hcat,split.(lines,"")))


function FindLowestPoints(input)
    padded_input = deepcopy(input)
    padded_input = [ones(Int,size(input,1),1).*10 padded_input ones(Int,size(input,1),1).*10]
    println(size(padded_input))
    padded_input = [ones(Int,1,size(padded_input,2)).*10;padded_input;ones(Int,1,size(padded_input,2)).*10]
    risk_level = 0;
    for i in 2:size(padded_input,1)-1
        for j in 2:size(padded_input,2)-1
            neighbors = [padded_input[i+1,j] padded_input[i-1,j] padded_input[i,j+1] padded_input[i,j-1]]
            if (sum(padded_input[i,j] .< neighbors) == 4)
                risk_level += (padded_input[i,j]+1)
            end
        end
    end 
    return risk_level
end

sol1 = FindLowestPoints(input)