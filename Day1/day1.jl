using DelimitedFiles
input = readdlm("input.txt");

function find_increasing(input)
    temp = input[1];
    increase_count = 0;
    for n in 2:length(input)
        if input[n]>temp
            increase_count+=1;
            temp = input[n];
        else
            temp = input[n];
        end
    end
    return increase_count
end

function find_sliding_increase(input)
    slide_sum =[];
    for n in 1:length(input)-2
        temp_sum = input[n]+input[n+1]+input[n+2];
        slide_sum = append!(slide_sum,temp_sum);
    end
    return slide_sum;
end

sol1 = find_increasing(input)
println("The solution to Part 1 is : ",sol1);
slide_sum = find_sliding_increase(input)
sol2 = find_increasing(slide_sum);
println("The solution to Part 2 is : ",sol2);