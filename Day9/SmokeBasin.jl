file = open("input.txt")
lines = readlines(file)
input = parse.(Int,reduce(hcat,split.(lines,"")))
padded_input = deepcopy(input)
padded_input = [ones(Int,size(input,1),1).*10 padded_input ones(Int,size(input,1),1).*10]
padded_input = [ones(Int,1,size(padded_input,2)).*10;padded_input;ones(Int,1,size(padded_input,2)).*10]

function FindLowestPoints(padded_input)
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

sol1,lowest_point_list = FindLowestPoints(padded_input)
println("Solution to Part 1 is : ",sol1)

smoke_basin = deepcopy(padded_input)
smoke_basin[findall(x->x != 9,smoke_basin)] .= 0
map(x->smoke_basin[lowest_point_list[x,1],lowest_point_list[x,2]] = 1,collect(1:1:size(lowest_point_list,1)))
smoke_basin = smoke_basin[2:end-1,2:end-1]

function MoveInBasin(basin_layout,current_point)
    current_row = current_point[1]
    current_col = current_point[2]
    search_done = 0;
    path = current_row+current_col*100;
    while search_done == 0
        if (current_col != 100 && basin_layout[current_row][current_col+1] != 9 && sum(path .== (current_row+(current_col+1)*100)) == 0)
            current_col += 1
        elseif (current_row != 100 && basin_layout[current_row+1][current_col] != 9 && sum(path .== (current_row+(current_col+1)*100)) == 0)
            current_row +=1
        elseif (current_col != 1 && basin_layout[current_row][current_col-1] != 9)
            current_col -= 1
        elseif (current_row != 1 && basin_layout[current_row-1][current_col] != 9)
            current_row -= 1
        else
            search_done = 1
        end
        append!(path,current_row+current_col*100)
    end
    return length(path)
end

function FindBasins(smoke_basin,lowest_point_list)
    lowest_point_count = size(lowest_point_list,1)
    basin_size = Array{Int}(undef,lowest_point_count,1)
    for n in 1:lowest_point_count
        basin_size[n] = MoveInBasin(smoke_basin,lowest_point_list[n,:])
    end
end
