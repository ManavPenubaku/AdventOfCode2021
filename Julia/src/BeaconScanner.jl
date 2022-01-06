using LinearAlgebra

cur_dir = pwd()
inp_path = cur_dir * "/input/day19_example.txt"
file = open(inp_path)
lines = readlines(file)

ScannerDict = Dict()
scanner_count = 0
for line in lines
    if contains(line,"scanner")
        local scanner_string = split(line," ")
        global scanner_count = parse(Int,scanner_string[3])
        ScannerDict[scanner_count] = []
    elseif line != ""
        append!(ScannerDict[scanner_count],parse.(Int,split(line,",")))
    end
end

for (key,values) in ScannerDict
    ScannerDict[key] = reshape(values,3,convert(Int,length(values)/3))
end

function GenerateRotations()
    A = [0 0 -1; 0 1 0; 1 0 0]
    B = [1 0 0; 0 0 -1; 0 1 0]
    C = [0 -1 0; 1 0 0; 0 0 1]
    return unique([A^i*B^j*C^k for i in 0:3 for j in 0:3 for k in 0:3])
end

function FindOverlappingScanners(scanner_dict)
    scanner = 0
    beacons = scanner_dict[scanner]
    scanner_dist_dict = Dict()
    scanner_pairs = Set()

    for (scanner,beacons) in scanner_dict
        dist_A = []
        for i in 1:size(beacons,2)
            for j in i+1:size(beacons,2)
                append!(dist_A,sum(abs.(beacons[:,i].-beacons[:,j])))
            end
        end
        scanner_dist_dict[scanner] = Set(dist_A)
    end

    for i in 0:1:length(scanner_dict)-1
        for j in 0:1:length(scanner_dict)-1
            if (i != j && length(intersect(scanner_dist_dict[i],scanner_dist_dict[j])) >= 66 && !in((j,i),scanner_pairs))
                push!(scanner_pairs, (i,j))
            end
        end
    end

    return scanner_pairs
end

function MapScanners(scanner_pairs,scanner_dict,rotation_matrices)
    scanner_positions = Dict()
    scanner_rotations = Dict()
    for pair in scanner_pairs
        beacons_ref = scanner_dict[pair[1]]
        beacons_mutate = scanner_dict[pair[2]]
        for rotate in rotation_matrices
            counts = Dict()
            beacons_compare = reduce(hcat,map(x->rotate * x,eachcol(beacons_mutate)))
            for i in 1:size(beacons_ref,2)
                for j in 1:size(beacons_compare,2)
                    distance = beacons_ref[:,i] - beacons_compare[:,j]
                    if (haskey(counts,distance))
                        counts[distance] += 1
                    else
                        counts[distance] = 1
                    end

                    if counts[distance] == 12
                        scanner_rotations[pair] = rotate
                        scanner_positions[pair] = distance
                    end
                end
            end
        end
    end

    ## Compute the rotation and translation with respect to scanner 0
    while true
        ref_0_keys = keys(filter(kv->kv.first[1] == 0 ,scanner_positions))
        if length(collect(ref_0_keys)) == length(scanner_dict)-1
            break
        else
            for key_parent in ref_0_keys
                ref_child_keys = keys(filter(kv->kv.first[1] == key_parent[2] && kv.first[2] != 0 ,scanner_positions))
                for key_child in ref_child_keys
                    if (!haskey(scanner_positions,(0,key_child[2])))
                        scanner_positions[(0,key_child[2])] = scanner_positions[(0,key_child[1])] .+ scanner_rotations[(0,key_child[1])] * scanner_positions[key_child]
                        scanner_rotations[(0,key_child[2])] = scanner_rotations[(0,key_child[1])] * scanner_rotations[key_child]
                    end
                end
                ref_child_keys = keys(filter(kv->kv.first[1] != 0 && kv.first[2] == key_parent[2] ,scanner_positions))
                for key_child in ref_child_keys
                    if (!haskey(scanner_positions,(0,key_child[1])))
                        scanner_positions[(0,key_child[1])] = round.(Int,scanner_positions[(0,key_child[2])] .- scanner_rotations[(0,key_child[2])] * inv(scanner_rotations[key_child]) * scanner_positions[key_child])
                        scanner_rotations[(0,key_child[1])] = round.(Int,scanner_rotations[(0,key_child[2])] * inv(scanner_rotations[key_child]))
                    end
                end
            end
        end
    end
    return scanner_positions,scanner_rotations
end

function FindUniqueBeacons(scanner_dict,scanner_positions,scanner_rotations)
    beacon_dict = Dict()
    for (key,values) in scanner_dict
        for n in 1:size(values,2)
            if (key == 0)
                beacon_dict[values[:,n]] = 1
            else
                temp_beacon_position = scanner_rotations[(0,key)] * values[:,n] + scanner_positions[(0,key)]
                if (!haskey(beacon_dict,temp_beacon_position))
                    beacon_dict[temp_beacon_position] = 1
                end
            end
        end
    end
    return length(beacon_dict)
end

function ComputeManhattans(scanner_positions)
    scanner_positions_0 = filter(kv->kv.first[1] == 0 ,scanner_positions)
    max_manhattan_distance = 0
    for (~,position_1) in scanner_positions_0
        for (~,position_2) in scanner_positions_0
            max_manhattan_distance = max(max_manhattan_distance, sum(abs.(position_1 .- position_2)))
        end
    end
    return max_manhattan_distance
end

ScannerPairs = FindOverlappingScanners(ScannerDict)
RotationMatrices = GenerateRotations()
ScannerPositions,ScannerRotations = MapScanners(ScannerPairs,ScannerDict,RotationMatrices)
BeaconCount = FindUniqueBeacons(ScannerDict,ScannerPositions,ScannerRotations)
println("Solution to Part 1 is : ",BeaconCount)
LargestDistance = ComputeManhattans(ScannerPositions)
println("Solution to Part 2 is : ",LargestDistance)