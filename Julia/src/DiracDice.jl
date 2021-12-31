function PlayDiracDice1(position_p1,position_p2)
    score_p1 = 0
    score_p2 = 0
    roll_count = 0
    dice_rolls = collect(1:1:100)
    while score_p1 < 1000 && score_p2 < 1000
        dice_indices = map(x->mod1(x,100),collect(roll_count*3 + 1 : 1 : roll_count*3 + 3))
        dice_sum = sum(dice_rolls[dice_indices])
        if mod(roll_count,2) == 0
            position_p1 = mod1(position_p1+dice_sum,10)
            score_p1 = score_p1 + position_p1
        else
            position_p2 = mod1(position_p2+dice_sum,10)
            score_p2 = score_p2 + position_p2
        end
        roll_count += 1
    end
    return roll_count*3*score_p2
end

function PlayDiracDice2(position_p1,position_p2)
    universe_dict = Dict([0,position_p1,0,position_p2] => 1)
    universe_outcomes = Dict(1 => 0, 2 => 0)
    roll_count = 1
    dice_values_dict = Dict(3 => 1,4 => 3,5 => 6,6 => 7,7 => 6,8 => 3,9 => 1)
    while !isempty(universe_dict)
        temp_dict = Dict()
        temp_position = 0
        temp_score = 0
        if (isodd(roll_count))
            for (key,value) in universe_dict
                for (dice_key,dice_value) in dice_values_dict
                    temp_position = mod1(key[2] + dice_key,10)
                    temp_score = key[1] + temp_position
                    if (haskey(temp_dict,[temp_score,temp_position,key[3],key[4]]))
                        temp_dict[[temp_score,temp_position,key[3],key[4]]] += value * dice_value
                    else
                        temp_dict[[temp_score,temp_position,key[3],key[4]]] = value * dice_value
                    end           
                end
            end
            universe_dict = deepcopy(temp_dict)
            games_won = filter(kv->kv.first[1] >= 21,universe_dict)
            for (key,value) in games_won
                delete!(universe_dict, key)
                universe_outcomes[1] = universe_outcomes[1] + value
            end
        else
            for (key,value) in universe_dict
                for (dice_key,dice_value) in dice_values_dict
                    temp_position = mod1(key[4] + dice_key,10)
                    temp_score = key[3] + temp_position
                    if (haskey(temp_dict,[key[1],key[2],temp_score,temp_position]))
                        temp_dict[[key[1],key[2],temp_score,temp_position]] += value * dice_value
                    else
                        temp_dict[[key[1],key[2],temp_score,temp_position]] = value * dice_value
                    end
                end
            end
            universe_dict = deepcopy(temp_dict)
            games_won = filter(kv->kv.first[3] >= 21,universe_dict)
            for (key,value) in games_won
                delete!(universe_dict, key)
                universe_outcomes[2] = universe_outcomes[2] + value
            end
        end
        roll_count += 1
    end
    return universe_outcomes
end

sol1 = PlayDiracDice1(4,7)
println("Solution to Part 1 is : ",sol1)

sol2 = PlayDiracDice2(4,7)
println("Solution to Part 2 is : ", maximum(values(sol2)))



