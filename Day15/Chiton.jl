file = open("example.txt")
lines = readlines(file)

ChitonDensity = rotl90(reverse(parse.(Int,reduce(hcat,split.(lines,""))),dims=2))

function FindPath(ChitonDensity)
    updated_map = [ChitonDensity 20 .* ones(Int,size(ChitonDensity,1),1)]
    updated_map = [updated_map;20 .* ones(Int,1,size(updated_map,2))]
    cost_map = zeros(Int,size(ChitonDensity))
    for i in 1:size(updated_map,1)-1
        for j in 1:size(updated_map,2)-1
            cost_map[i,j] = min(updated_map[i,j+1],updated_map[i+1,j])
        end
    end

    path_risk_map = cost_map .+ ChitonDensity

    destination_flag = 0
    x_pos = 1
    y_pos = 1
    risk_level = 0
    while(destination_flag == 0)
        if (x_pos == size(ChitonDensity,1))
            y_pos+=1
            risk_level += ChitonDensity[x_pos,y_pos]
        elseif (y_pos == size(ChitonDensity,2))
            x_pos+=1
            risk_level += ChitonDensity[x_pos,y_pos]
        else
            if (path_risk_map[x_pos+1,y_pos] < path_risk_map[x_pos,y_pos+1])
                x_pos += 1
                risk_level += ChitonDensity[x_pos,y_pos]
            elseif (path_risk_map[x_pos+1,y_pos] > path_risk_map[x_pos,y_pos+1])
                y_pos += 1
                risk_level += ChitonDensity[x_pos,y_pos]
            else
            #    if (cost_map[x_pos+1,y_pos] < cost_map[x_pos,y_pos+1])
            #         y_pos+=1
            #         risk_level += ChitonDensity[x_pos,y_pos]
            #    elseif (cost_map[x_pos+1,y_pos] > cost_map[x_pos,y_pos+1])
            #         x_pos+=1
            #         risk_level += ChitonDensity[x_pos,y_pos]
            #    end
                println("Can't Move Forward")
            end
        end
        if x_pos == size(ChitonDensity,1) && y_pos == size(ChitonDensity,2)
            destination_flag = 1
        end
    end
    return risk_level
end

sol1 = FindPath(ChitonDensity)