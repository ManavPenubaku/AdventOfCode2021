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
            append!(epsilon, "1");
        end
    end
    return parse(Int,join(gamma),base=2)*parse(Int,join(epsilon),base=2)
end

function Part2(input)
    oxygen_generator_rating = deepcopy(input);
    co2_scrubber_rate = deepcopy(input);
    for n in 1:length(input[1])
        oxygen_ones = findall(x->x.=="1",map(y->y[n][:],oxygen_generator_rating))
        oxygen_zeros = findall(x->x.=="0",map(y->y[n][:],oxygen_generator_rating))
        if (size(oxygen_generator_rating,1)>1)
            if (length(oxygen_ones) >= length(oxygen_zeros))
                oxygen_generator_rating = oxygen_generator_rating[oxygen_ones]
            else
                oxygen_generator_rating = oxygen_generator_rating[oxygen_zeros]
            end
        end
        co2_ones = findall(x->x.=="1",map(y->y[n],co2_scrubber_rate))
        co2_zeros = findall(x->x.=="0",map(y->y[n],co2_scrubber_rate))
        if (size(co2_scrubber_rate,1)>1)
            if (length(co2_zeros) <= length(co2_ones))
                co2_scrubber_rate = co2_scrubber_rate[co2_zeros]
            else
                co2_scrubber_rate = co2_scrubber_rate[co2_ones]
            end
        end
    end
    return parse(Int,join(oxygen_generator_rating[1]),base=2)*parse(Int,join(co2_scrubber_rate[1]),base=2)
end

sol1 = Part1(input);
println("Solution to Part 1 is : ",sol1)
sol2 = Part2(input);
println("Solution to Part 2 is : ",sol2)