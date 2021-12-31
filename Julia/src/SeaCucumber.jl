using DelimitedFiles
cur_dir = pwd()
inp_path = cur_dir * "/input/day25.txt"
input = readdlm(inp_path)
sea_cucumber_map = rotl90(reverse(reduce(hcat,split.(input,"")),dims=2))

function MoveSeaCucumbers(sea_cucumber_map)
    update_sea_cucumber_map = deepcopy(sea_cucumber_map)
    step_count = 0
    while true
        move_east_indices = findall(update_sea_cucumber_map .== ">" .&& circshift(update_sea_cucumber_map,(0,-1)) .== ".")
        update_sea_cucumber_map[move_east_indices] .= "."
        update_sea_cucumber_map[map(x->CartesianIndex(x[1],mod1(x[2]+1,size(sea_cucumber_map,2))),move_east_indices)] .= ">"
        move_south_indices = findall(update_sea_cucumber_map .== "v" .&& circshift(update_sea_cucumber_map,(-1,0)) .== ".")
        update_sea_cucumber_map[move_south_indices] .= "."
        update_sea_cucumber_map[map(x->CartesianIndex(mod1(x[1]+1,size(sea_cucumber_map,1)),x[2]),move_south_indices)] .= "v"
        step_count += 1
        if (isempty(move_east_indices) && isempty(move_south_indices))
            break
        end
    end
    return step_count
end

sol1 = MoveSeaCucumbers(sea_cucumber_map)
println("Solution to Part 1 is : ",sol1)

