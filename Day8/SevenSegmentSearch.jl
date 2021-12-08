file = open("input.txt")
lines = readlines(file)

reg = r"(.+) \| (.+)"
input = match.(reg,lines)
patterns = String.(map(x->x.captures[1],input))
digits = String.(map(x->x.captures[2],input))

four_digits = reduce(hcat,split.(digits," "))
sol1 = length(findall((length.(four_digits) .== 2) .| (length.(four_digits) .== 3) .| (length.(four_digits) .== 4) .| (length.(four_digits) .== 7)))
println("Solution to Part 1 is : ",sol1)

pattern_digits = reduce(hcat,split.(patterns," "))

function DecodePatterns(pattern)
    pattern_digit_map = Dict{String,Int}()
    digit_one = String(pattern[findall(length.(pattern) .== 2)[1]])
    pattern_digit_map[digit_one] = 1
    pattern_digit_map[String(pattern[findall(length.(pattern) .== 3)[1]])] = 7
    digit_four = String(pattern[findall(length.(pattern) .== 4)[1]])
    pattern_digit_map[digit_four] = 4
    pattern_digit_map[String(pattern[findall(length.(pattern) .== 7)[1]])] = 8
    six_segment_patterns = findall(length.(pattern) .== 6)
    for n in 1:length(six_segment_patterns)
        if (sum(map(x->occursin(x,pattern[six_segment_patterns[n]]),collect(digit_one))) == 1)
            pattern_digit_map[String(pattern[six_segment_patterns[n]])] = 6
        elseif (sum(map(x->occursin(x,pattern[six_segment_patterns[n]]),collect(digit_four))) == 4)
            pattern_digit_map[String(pattern[six_segment_patterns[n]])] = 9
        else
            pattern_digit_map[String(pattern[six_segment_patterns[n]])] = 0
        end
    end
    five_segment_patterns = findall(length.(pattern) .== 5)
    for n in 1:length(five_segment_patterns)
        if (sum(map(x->occursin(x,pattern[five_segment_patterns[n]]),collect(digit_one))) == 2)
            pattern_digit_map[String(pattern[five_segment_patterns[n]])] = 3
        elseif (sum(map(x->occursin(x,pattern[five_segment_patterns[n]]),collect(digit_four))) == 3)
            pattern_digit_map[String(pattern[five_segment_patterns[n]])] = 5
        else
            pattern_digit_map[String(pattern[five_segment_patterns[n]])] = 2
        end
    end
    return pattern_digit_map
end

function DeconstructNumber(decoded_dict,digits_to_decode)
    pattern_list = collect(keys(decoded_dict))
    decoded_number = 0;
    for i in 1:length(digits_to_decode)
        for j in 1:length(pattern_list)
            if (length(digits_to_decode[i]) == length(pattern_list[j]))
                if (sum(map(x->occursin(x,pattern_list[j]),collect(digits_to_decode[i]))) == length(digits_to_decode[i]))
                    decoded_number += 10^(4-i)*decoded_dict[pattern_list[j]]
                end
            end
        end
    end
    return decoded_number
end

function Part2(pattern_digits,four_digits)
    sol2 = 0;
    for n in 1:size(pattern_digits,2)
        decoded_patterns = DecodePatterns(pattern_digits[:,n])
        sol2 += DeconstructNumber(decoded_patterns,four_digits[:,n])
    end
    return sol2
end

sol2 = Part2(pattern_digits,four_digits)
println("Solution to Part 2 is : ",sol2)