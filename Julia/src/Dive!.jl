using DelimitedFiles
input = readdlm("/home/manav/AdventOfCode2021/Julia/input/day2.txt");

function FindPosition(input)
    pos = [0,0];
    pos2 = [0,0];
    aim = 0;
    for n in 1:size(input,1)
        if input[n,1] == "forward"
            pos[1] += input[n,2]
            pos2[1] += input[n,2]
            pos2[2] += aim*input[n,2];
        elseif input[n,1] == "up"
            pos[2] -= input[n,2]
            aim -= input[n,2]
        elseif input[n,1] == "down"
            pos[2] += input[n,2]
            aim += input[n,2]
        end
    end
    return prod(pos),prod(pos2)
end

sol1,sol2 = FindPosition(input);
println("Solution to Part 1 is : ",sol1)
println("Solution to Part 2 is : ",sol2)