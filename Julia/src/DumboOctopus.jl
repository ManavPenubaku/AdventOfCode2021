file = open("/home/manav/AdventOfCode2021/Julia/input/day11.txt")
input = parse.(Int,reduce(hcat,split.(readlines(file),"")))

function SimulateFlashes(input)
    step_count = 1
    total_flashes = 0;
    flash_list = []
    while true
        input .+= 1
        flash_octopus = findall(input .>= 10)
        while (length(flash_octopus) != length(flash_list))
            for n in 1:length(flash_octopus)
                if !(flash_octopus[n] in flash_list)
                    input[max(flash_octopus[n][1]-1,1):min(10,flash_octopus[n][1]+1),max(1,flash_octopus[n][2]-1):min(10,flash_octopus[n][2]+1)] .+= 1
                end
            end
            flash_list = unique(append!(flash_list,flash_octopus))
            flash_octopus = findall(input .>= 10)
        end
        if (length(input) == length(flash_octopus))
            break
        end
        if (step_count <= 100)
            total_flashes+=length(flash_list)
        end
        input[flash_octopus] .= 0 
        flash_list = []
        step_count+=1
    end
    return total_flashes,step_count
end

sol1,sol2 = SimulateFlashes(input)
println("Solution to Part 1 is : ",sol1)
println("Solution to Part 2 is : ",sol2)
