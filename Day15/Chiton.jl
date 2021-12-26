file = open("example.txt")
lines = readlines(file)

ChitonDensity = rotl90(reverse(parse.(Int,reduce(hcat,split.(lines,""))),dims=2))

function FindPath(ChitonDensity)
    row_count = size(ChitonDensity,1)
    col_count = size(ChitonDensity,2)
    cost_map = min.(circshift(ChitonDensity,(0,-1))[1:row_count-1,1:col_count-1],circshift(ChitonDensity,(-1,0))[1:row_count-1,1:col_count-1])
    cost_map = [cost_map ChitonDensity[2:row_count,col_count]]
    cost_map = vcat(cost_map,transpose([ChitonDensity[row_count,2:col_count];ChitonDensity[row_count,col_count]]))
    
    return cost_map_2 .* cost_map .* ChitonDensity
   
    path_risk_map = cost_map .* ChitonDensity
    destination_flag = 0
    x_pos = 1
    y_pos = 1
    risk_level = 0
    temp_x_pos = 1
    temp_y_pos = 1

    max_value = 8
    while(destination_flag == 0)
        println(x_pos, " ",y_pos)
        if (x_pos == size(ChitonDensity,1))
            y_pos+=1
            risk_level += ChitonDensity[x_pos,y_pos]
        elseif (y_pos == size(ChitonDensity,2))
            x_pos+=1
            risk_level += ChitonDensity[x_pos,y_pos]
        else
            # println(path_risk_map[x_pos+1,y_pos+1])
            # println(path_risk_map[x_pos+1,y_pos])
            # println(path_risk_map[x_pos+2,y_pos])
            # println(path_risk_map[x_pos,y_pos+2])
            # println(path_risk_map[x_pos+2,y_pos+1])
            # println(path_risk_map[x_pos+1,y_pos+2])
            # sleep(0.5)
            if (path_risk_map[x_pos+1,y_pos] < path_risk_map[x_pos,y_pos+1]) && ChitonDensity[x_pos+1,y_pos] <= 8
                x_pos += 1
                risk_level += ChitonDensity[x_pos,y_pos]
            elseif (path_risk_map[x_pos+1,y_pos] > path_risk_map[x_pos,y_pos+1]) && ChitonDensity[x_pos,y_pos+1] <= 8
                y_pos += 1
                risk_level += ChitonDensity[x_pos,y_pos]
            else
                temp_x_pos = x_pos+1
                temp_y_pos = y_pos+1
                if (temp_x_pos == size(ChitonDensity,1))
                    risk_level += ChitonDensity[x_pos,y_pos+1] + ChitonDensity[x_pos,y_pos+2]
                    y_pos += 2
                elseif (temp_y_pos == size(ChitonDensity,2))
                    risk_level += ChitonDensity[x_pos+1,y_pos] + ChitonDensity[x_pos+2,y_pos]
                    x_pos += 2
                elseif (path_risk_map[temp_x_pos,temp_y_pos] < path_risk_map[x_pos,y_pos+1]) && ChitonDensity[temp_x_pos,temp_y_pos] <= max_value
                    x_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                    y_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                elseif (path_risk_map[temp_x_pos+1,temp_y_pos] < path_risk_map[temp_x_pos,temp_y_pos+1]) && ChitonDensity[temp_x_pos+1,temp_y_pos]<= max_value
                    x_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                    x_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                    y_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                elseif (path_risk_map[temp_x_pos+1,temp_y_pos] > path_risk_map[temp_x_pos,temp_y_pos+1]) && ChitonDensity[temp_x_pos,temp_y_pos+1]<= max_value
                    y_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                    y_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                    x_pos += 1
                    risk_level += ChitonDensity[x_pos,y_pos]
                elseif (path_risk_map[x_pos+2,y_pos] < path_risk_map[x_pos,y_pos+2]) && ChitonDensity[x_pos+2,y_pos] <= max_value
                    risk_level += ChitonDensity[x_pos+1,y_pos] + ChitonDensity[x_pos+2,y_pos]
                    x_pos += 2
                elseif (path_risk_map[x_pos+2,y_pos] > path_risk_map[x_pos,y_pos+2]) && ChitonDensity[x_pos,y_pos+2] <= max_value
                    risk_level += ChitonDensity[x_pos,y_pos+1] + ChitonDensity[x_pos,y_pos+2]
                    y_pos += 2
                else
                    println("Can't Move Forward")
                end
            end
        end
        if x_pos == size(ChitonDensity,1) && y_pos == size(ChitonDensity,2)
            destination_flag = 1
        end
    end
    return risk_level
end

sol1 = FindPath(ChitonDensity)