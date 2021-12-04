file = open("input.txt")
lines = readlines(file)

number_sequence = parse.(Int,split(lines[1],","))

function GetBingoBoards(lines)
    bingo_board_indices = findall(x->x.!="",lines[3:end])
    bingo_board_count = convert(Int,length(bingo_board_indices)/5)
    bingo_boards = Array{Int64,3}(undef,5,5,bingo_board_count)
    bingo_board_counter = 1;
    for i in 3:6:length(lines)
        split_numbers = split.(lines[i:i+4]," ")
        # Look for possible whitespace
        split_numbers_proper = map(x->findall(x.!=""),split_numbers)
        for j in 1:length(split_numbers)
            bingo_boards[j,:,bingo_board_counter] = parse.(Int,split_numbers[j][split_numbers_proper[j]])
        end
        bingo_board_counter+=1
    end
    return bingo_boards
end

function Part1(bingo_boards,number_sequence)
    matching_mask = BitArray(undef,size(bingo_boards))
    matching_mask .= 0;
    final_number = 0;
    sol1 = 0;
    for n in 1:length(number_sequence)
        matching_mask = (matching_mask) .| (bingo_boards.== number_sequence[n])
        completed = findall(x->x.==5,sum(matching_mask,dims=2))
        append!(completed,findall(x->x.==5,sum(matching_mask,dims=1)))
        println(completed)
        println(n)
        if (!isempty(completed))
            final_number = number_sequence[n]
            winning_board = bingo_boards[:,:,completed[1][3]]
            println(winning_board)
            winning_mask = matching_mask[:,:,completed[1][3]]
            sol1 = final_number * sum(winning_board[findall(winning_mask.!=1)])
            break
        end
    end
    return sol1
end

bingo_boards = GetBingoBoards(lines)
sol1 =  Part1(bingo_boards,number_sequence)