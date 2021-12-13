file = open("input.txt")

lines = readlines(file)

dots = parse.(Int,reduce(hcat,split.(lines[1:1004],",")))
cols = maximum(dots[1,:])
rows = maximum(dots[2,:])

fold_instructions = 

sheet = zeros(Int,rows+1,cols+1)
println(size(sheet))
for n in 1:size(dots,2)
    sheet[dots[2,n],dots[1,n]] = 1
end

right_half = sheet[:,657:end]
left_half = sheet[:,4:655]

right_half = reverse(right_half,dims = 2)
folded = (left_half) .| (right_half)
completed_fold = [sheet[:,1:3] folded]

sum(completed_fold .== 1)