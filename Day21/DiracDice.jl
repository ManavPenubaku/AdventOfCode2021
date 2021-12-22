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
    
end

sol1 = PlayDiracDice1(4,7)
println("Solution for Part 1 is : ",sol1)

sol2 = PlayDiracDice2(4,7)



