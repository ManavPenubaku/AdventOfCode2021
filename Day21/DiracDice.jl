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
    universe_positions = Dict(1 => [position_p1,position_p2])
    universe_scores = Dict(1 => [0,0])
    universe_dict_p1 = Dict([0,position_p1] => 1)
    universe_dict_p2 = Dict([0,position_p2] => 1)
    universe_outcomes = Dict(1 => 0,2 => 0)
    roll_count = 1
    temp_position = 0
    dice_values_dict = Dict(3 => 1,4 => 3,5 => 6,6 => 7,7 => 6,8 => 3,9 => 1)
    while !isempty(universe_dict_p1)
        temp_p1 = deepcopy(universe_dict_p1)
        temp_p2 = deepcopy(universe_dict_p2)
        temp_value = 0
        if (isodd(roll_count))
            for (key,value) in temp_p1
                if (key[1] < 21)
                    for (dice_key,dice_value) in dice_values_dict
                        temp_position = mod1(key[2] + dice_key,10)
                        temp_score = key[1] + temp_position
                        universe_dict_p1[[temp_score,temp_position]] = value*dice_value
                        delete!(universe_dict_p1,key)
                        # println(universe_dict_p1)
                        if (temp_score >= 21)
                            delete_key = collect(keys(filter(kv->kv.first[1] == key[1],universe_dict_p2)))
                            if !isempty(delete_key)
                                delete!(universe_dict_p2,delete_key[1])
                            else
                                println(value)
                            end

                        end
                    end
                else
                    delete!(universe_dict_p1,key)
                end
            end
            universe_outcomes[1] += temp_value
            for (key,value) in universe_dict_p2
                universe_dict_p2[key] = value * 27
                # if (total_universe_count != 0) 
                #     universe_dict_p2[key] = value * game_in_progress * 27 /total_universe_count
                # else
                #     delete!(universe_dict_p2,key)
                # end
            end
        else
            for (key,value) in temp_p2
                if (key[1] < 21)
                    for (dice_key,dice_value) in dice_values_dict
                        temp_position = mod1(key[2] + dice_key,10)
                        temp_score = key[1] + temp_position
                        universe_dict_p2[[temp_score,temp_position]] = value*dice_value
                        delete!(universe_dict_p2,key)
                        if (temp_score >= 21)
                            temp_value += value
                            delete_key = collect(keys(filter(kv->kv.first[1] == key[1],universe_dict_p1)))
                            if !isempty(delete_key)
                                delete!(universe_dict_p1,delete_key[1])
                            else
                                println(value)
                            end
                        end
                    end
                else
                    delete!(universe_dict_p2,key)
                end
            end
            universe_outcomes[2] += temp_value
            for (key,value) in universe_dict_p1
                universe_dict_p1[key] = value * 27
                # if (total_universe_count != 0)
                #     universe_dict_p1[key] = value * 27 * game_in_progress /total_universe_count
                # else
                #     delete!(universe_dict_p1,key)
                # end
            end
        end
        roll_count += 1
        println(roll_count)
        # universe_indices_1 = collect(1:1:length(universe_positions))
        # universe_indices_2 = collect(length(universe_positions)+1:1:2*length(universe_positions))
        # universe_indices_3 = collect(2*length(universe_positions)+1:1:3*length(universe_positions))
        # temp_position_p1 = deepcopy(universe_positions)
        # temp_scores_p1 = deepcopy(universe_scores)
        # if isodd(ceil(roll_count/3))
        #     setindex!.(Ref(universe_positions),map(x->[x[1].+1,x[2]],values(temp_position_p1)),universe_indices_1)
        #     setindex!.(Ref(universe_positions),map(x->[x[1].+2,x[2]],values(temp_position_p1)),universe_indices_2)
        #     setindex!.(Ref(universe_positions),map(x->[x[1].+3,x[2]],values(temp_position_p1)),universe_indices_3)
        #     setindex!.(Ref(universe_scores),map(x->x,values(temp_scores_p1)),universe_indices_1)
        #     setindex!.(Ref(universe_scores),map(x->x,values(temp_scores_p1)),universe_indices_2)
        #     setindex!.(Ref(universe_scores),map(x->x,values(temp_scores_p1)),universe_indices_3)
        #     if (mod(roll_count,3) == 0)
        #         map!(x->[mod1(x[1],10),x[2]],values(universe_positions))
        #         setindex!.(Ref(universe_scores),map((x,y)->[x[1]+y[1],x[2]],values(universe_scores),values(universe_positions)),[universe_indices_1;universe_indices_2;universe_indices_3])
        #     end
        # else
        #     setindex!.(Ref(universe_positions),map(x->[x[1],x[2].+1],values(temp_position_p1)),universe_indices_1)
        #     setindex!.(Ref(universe_positions),map(x->[x[1],x[2].+2],values(temp_position_p1)),universe_indices_2)
        #     setindex!.(Ref(universe_positions),map(x->[x[1],x[2].+3],values(temp_position_p1)),universe_indices_3)
        #     setindex!.(Ref(universe_scores),map(x->x,values(temp_scores_p1)),universe_indices_1)
        #     setindex!.(Ref(universe_scores),map(x->x,values(temp_scores_p1)),universe_indices_2)
        #     setindex!.(Ref(universe_scores),map(x->x,values(temp_scores_p1)),universe_indices_3)
        #     if (mod(roll_count,3) == 0)
        #         map!(x->[x[1],mod1(x[2],10)],values(universe_positions))
        #         setindex!.(Ref(universe_scores),map((x,y)->[x[1],x[2]+y[2]],values(universe_scores),values(universe_positions)),[universe_indices_1;universe_indices_2;universe_indices_3])
        #     end
        # end
        # result = filter(kv->(kv.second[1] >= 21 && !haskey(universe_outcomes,kv.first)),universe_scores)
        # universe_keys_p1 = collect(keys(result))
        # println(length(universe_positions))
        # setindex!.(Ref(universe_outcomes),1,universe_keys_p1)
        # map(x->delete!(universe_scores,x),universe_keys_p1)
        # map(x->delete!(universe_positions,x),universe_keys_p1)
        # result2 = filter(kv->(kv.second[2] >= 21 && !haskey(universe_outcomes,kv.first)),universe_scores)
        # universe_keys_p2 = collect(keys(result2))
        # setindex!.(Ref(universe_outcomes),2,universe_keys_p2)
        # map(x->delete!(universe_scores,x),universe_keys_p2)
        # map(x->delete!(universe_positions,x),universe_keys_p2)
        # println(length(universe_positions))
    end
    return universe_outcomes
end

sol1 = PlayDiracDice1(4,7)
println("Solution for Part 1 is : ",sol1)

sol2 = PlayDiracDice2(4,8)



