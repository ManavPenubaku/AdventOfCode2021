using DataStructures

cur_dir = pwd()
inp_path = cur_dir * "/input/day15.txt"
file = open(inp_path)
lines = readlines(file)

ChitonDensity = rotl90(reverse(parse.(Int,reduce(hcat,split.(lines,""))),dims=2))

function ConstructGraph(CaveDensity)
    neighbor_dict = Dict()
    cost_dict = Dict()
    for i in 1:size(CaveDensity,1)
        for j in 1:size(CaveDensity,2)
            if i == size(CaveDensity,1) && j!= size(CaveDensity,2)
                neighbor_dict[(i,j)] = [(i,j+1) (i-1,j)]
                cost_dict[(i,j),(i,j+1)] = CaveDensity[i,j+1]
                cost_dict[(i,j),(i-1,j)] = CaveDensity[i-1,j]
            elseif i != size(CaveDensity,1) && j == size(CaveDensity,2)
                neighbor_dict[(i,j)] = [(i+1,j) (i,j-1)]
                cost_dict[(i,j),(i+1,j)] = CaveDensity[i+1,j]
                cost_dict[(i,j),(i,j-1)] = CaveDensity[i,j-1]
            elseif i > 1 && i < size(CaveDensity,1) && j>1 && j < size(CaveDensity,2)
                neighbor_dict[(i,j)] = [(i,j+1) (i+1,j) (i-1,j) (i,j-1)]
                cost_dict[(i,j),(i+1,j)] = CaveDensity[i+1,j] 
                cost_dict[(i,j),(i,j+1)] = CaveDensity[i,j+1]
                cost_dict[(i,j),(i,j-1)] = CaveDensity[i,j-1]
                cost_dict[(i,j),(i-1,j)] = CaveDensity[i-1,j]
            elseif i != size(CaveDensity,1) && j != size(CaveDensity,2)
                neighbor_dict[(i,j)] = [(i,j+1) (i+1,j)]
                cost_dict[(i,j),(i+1,j)] = CaveDensity[i+1,j] 
                cost_dict[(i,j),(i,j+1)] = CaveDensity[i,j+1]
            end
        end
    end
    return neighbor_dict,cost_dict
end

function DijkstraSearch(neighbor_dict,cost_dict,start,goal)
    pq = PriorityQueue()
    enqueue!(pq, start, 0)
    cost_so_far = Dict()
    cost_so_far[start] = 0
    while !isempty(pq)
        current = dequeue!(pq)
        if current == goal
            break
        end
        for next in neighbor_dict[current]
            new_cost = cost_so_far[current] + cost_dict[(current,next)]
            if !haskey(cost_so_far,next) || new_cost < cost_so_far[next]
                cost_so_far[next] = new_cost
                priority = new_cost
                enqueue!(pq,next,priority)
            end
        end
    end
    return cost_so_far[goal]
end

NeighborDict,CostDict = ConstructGraph(ChitonDensity)
sol1 = DijkstraSearch(NeighborDict,CostDict,(1,1),(size(ChitonDensity,1),size(ChitonDensity,2)))
println("Solution to Part 1 is : ",sol1)

ChitonDensityRepeatX = reduce(hcat,map(x->mod1.(ChitonDensity.+x,9),collect(0:1:4)))
FullCaveDensity = reduce(vcat,map(x->mod1.(ChitonDensityRepeatX.+x,9),collect(0:1:4)))
NeighborDict2,CostDict2 = ConstructGraph(FullCaveDensity)
sol2 = DijkstraSearch(NeighborDict2,CostDict2,(1,1),(size(FullCaveDensity,1),size(FullCaveDensity,2)))
println("Solution to Part 2 is : ",sol2)