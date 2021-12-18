file = open("input.txt")
lines = readlines(file)

ChitonDensity = parse.(Int,reduce(hcat,split.(lines,"")))

function FindPath(ChitonDensity)
    destination_flag = 0
    x_pos = 1
    y_pos = 1
    risk_level = 0
    while destination_flag == 0
        if y_pos == size(ChitonDensity,1)

        elseif x_pos == size(ChitonDensity,2)

        else
            if (ChitonDensity[y_pos+1][x_pos] == ChitonDensity[y_pos][x_pos+1])
                
            end
        end
    end
end