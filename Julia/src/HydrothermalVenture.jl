cur_dir = pwd()
inp_path = cur_dir * "/input/day5.txt"
file = open(inp_path)
lines = readlines(file)
reg = r"(.+),(.+) -> (.+),(.+)"
input = map(y->parse.(Int,y),map(x->x.captures,match.(reg,lines)))

function Part1(input)
    max = maximum(maximum(input));
    Grid = Array{Int}(undef,max[1],max[1])
    Grid .= 0;
    for n in 1:length(input)
        if input[n][1] == input[n][3]
            if (input[n][2]<=input[n][4])
                Grid[input[n][1],input[n][2]:input[n][4]] .+= 1;
            else
                Grid[input[n][1],input[n][2]:-1:input[n][4]] .+= 1;
            end
        elseif input[n][2] == input[n][4]
            if (input[n][1]<=input[n][3])
                Grid[input[n][1]:input[n][3],input[n][2]] .+= 1;
            else
                Grid[input[n][1]:-1:input[n][3],input[n][2]] .+= 1;
            end
        end
    end
    sol1 = sum(Grid .>= 2);
    return sol1,Grid
end

function Part2(input,Grid)
    sol2 = 0
    x_jump = 1;
    y_jump = 1;
    for n in 1:length(input)
        slope = abs((input[n][2]-input[n][4])/(input[n][1]-input[n][3]))
        if (slope == 1.0)
            x_jump = (input[n][1]>input[n][3]) ? -1 : 1;
            y_jump = (input[n][2]>input[n][4]) ? -1 : 1;
            for (i,j) in zip(input[n][1]:x_jump:input[n][3],input[n][2]:y_jump:input[n][4])
                Grid[i,j] +=1;
            end
        end
    end
    sol2 = sum(Grid .>= 2);
    return sol2
end

sol1,Grid = Part1(input)
println("Solution to Part 1 is : ",sol1)
sol2 = Part2(input,Grid)
println("Solution to Part 2 is : ",sol2)
