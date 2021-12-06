file = open("input.txt")
lines = readlines(file)
input = sort(vec(parse.(Int,reduce(hcat,split.(lines,",")))))

function RecurseLanternFish(spawn_days)
    fish_count = 0;
    count = 1;
    while count<=length(spawn_days)
        if (length(spawn_days) == 1)
            fish_count = 1;
        else
            fish_count = fish_count+1+RecurseLanternFish(collect((spawn_days[count]-9):-7:1));
        end
        count+=1;
    end
    return fish_count
end

function SpawnLanternFish(input,day_count)
    total_fish = [];
    unique_start_day = unique(input)
    for i in 1:length(unique_start_day)
        spawned_fish = collect((day_count- unique_start_day[i]):-7:1)
        append!(total_fish,RecurseLanternFish(spawned_fish)+1)
    end
    output = deepcopy(input)
    map(x->output[output.==x].=total_fish[x],unique_start_day)
    return sum(output)
end

sol1 = SpawnLanternFish(input,80)
println("Solution to Part 1 is : ",sol1)
sol2 = SpawnLanternFish(input,256)
println("Solution to Part 2 is : ",sol2)