file = open("input.txt")
lines = readlines(file);
input = split.(lines,"");

function Part1(input)
    gamma = [];
    epsilon = [];
    for n in 1:length(input[1])
        ones = findall(x->x.=="1",map(y->y[n][:],input))
        if (length(ones) > convert(Int,length(input)/2))
            append!(gamma,"1")
            append!(epsilon,"0")
        else
            append!(gamma,"0")
            append!(epsilon,"1")
        end
    end
    return parse(Int,join(gamma),base=2)*parse(Int,join(epsilon),base=2)
end

function Part2(input)

end

sol1 = Part1(input);
println("Solution to Part 1 is : ",sol1)
sol2 = Part2(input);
println("Solution to Part 2 is : ",sol2)