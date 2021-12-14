file = open("input.txt")

lines = readlines(file)

dots = parse.(Int,reduce(hcat,split.(lines[1:1004],",")))
cols = maximum(dots[1,:])
rows = maximum(dots[2,:])

fold_instructions = split.(lines[1006:end],"=")
creases = map(x->parse.(Int,x[2]),fold_instructions)
fold_direction = map(x->x[1][end],fold_instructions)

sheet = zeros(Int,rows+1,cols+1)
for n in 1:size(dots,2)
    sheet[dots[2,n]+1,dots[1,n]+1] = 1
end

function FoldSheet(sheet,creases,fold_direction)
    sol1 = 0
    sol2 = 0
    for n in 1:length(creases)
        if fold_direction[n] == 'x'
            right_half = sheet[:,creases[n]+2:end]
            left_half = sheet[:,1:creases[n]]
            if size(left_half,2) > size(right_half,2)
                diff_size = size(left_half,2) - size(right_half,2)
                right_half = [right_half zeros(Int,size(right_half,1),diff_size)]
            elseif size(left_half,2) < size(right_half,2)
                diff_size = size(right_half,2) - size(left_half,2)
                left_half = [zeros(Int, size(left_half,1),diff_size) left_half]
            end
            right_half = reverse(right_half,dims=2)
            sheet = (left_half) .| (right_half)
        elseif fold_direction[n] == 'y'
            top_half = sheet[1:creases[n],:]
            bottom_half = sheet[creases[n]+2:end,:]
            if size(top_half,1) > size(bottom_half,1)
                diff_size = size(top_half,1) - size(bottom_half,1)
                bottom_half = [bottom_half;zeros(Int, diff_size, size(bottom_half,2))]
            elseif size(top_half,2) < size(bottom_half,2)
                diff_size = size(bottom_half,2) - size(top_half,2)
                top_half = [zeros(Int, diff_size,size(top_half,2));top_half]
            end
            bottom_half = reverse(bottom_half,dims = 1)
            sheet = top_half .| bottom_half
        end
        if n == 1
            sol1 = sum(sheet .== 1)
        end
    end
    sol2 = sum(sheet .== 1)
    for n in 1:size(sheet,1)
        println(join(sheet[n,:]))
    end
    return sol1,sol2
end

p1,p2 = FoldSheet(sheet,creases,fold_direction)