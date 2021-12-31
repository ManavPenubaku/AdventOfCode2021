cur_dir = pwd()
inp_path = cur_dir * "/input/day9.txt"
file = open(inp_path)
lines = readlines(file)
input = rotl90(reverse(parse.(Int,reduce(hcat,split.(lines,""))),dims=2))
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
lowest_point_list .-= 1

function BreadthFirstSearch(grid,source)
    basin_size = Dict(source => 1)
    queue = [source]
    dRow = [-1 0 1 0]
    dCol = [0 -1 0 1]
    while !isempty(queue)
        current = splice!(queue,1)
        for n in 1:4
            xindex = current[1] + dRow[n]
            yindex = current[2] + dCol[n]
            neighbor = [xindex,yindex]
            if (1<= xindex <= size(grid,1)) && (1 <= yindex <= size(grid,2)) && !haskey(basin_size,neighbor) && grid[xindex,yindex] != 9
                basin_size[neighbor] = basin_size[current] + 1
                push!(queue,neighbor)
            end
        end
    end
    return length(basin_size)
end

function FindBasins(smoke_basin,lowest_point_list)
    lowest_point_count = size(lowest_point_list,1)
    basin_size = Array{Int}(undef,lowest_point_count)
    for n in 1:size(lowest_point_list,1)
        append!(basin_size,BreadthFirstSearch(smoke_basin,lowest_point_list[n,:]))
    end
    basin_size = sort(basin_size)
    return prod(basin_size[end-2:end])
end

sol2 = FindBasins(smoke_basin,lowest_point_list)
println("Solution to Part 2 is : ",sol2)