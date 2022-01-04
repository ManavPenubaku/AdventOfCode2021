using StatsBase
using LinearAlgebra

file = open("input.txt")
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

function KabschUmeyamaTransform(A,B)
    mu_a = mean(A)
    mu_b = mean(B)
    H = zeros(3,3)
    for n in 1:size(A,1)
        H .+= (A[n] .- mu_a) * transpose(B[n] .- mu_b)
    end
    F = svd(H./size(A,1))
    d = sign(det(H))
    S = Diagonal([1,1,d])
    R = F.U * S * F.Vt

    t = mu_a - R*mu_b
    return round.(Int,R),round.(Int,t)
end

function UpdateScannerDictionary(scanner,scanner_2,beacons_1,beacons_2,beacons_overlap,scanner_position,scanner_rotation)
    A = map(x->beacons_1[:,x[2]],beacons_overlap)
    B = map(x->beacons_2[:,x[1]],beacons_overlap)
    R,t = KabschUmeyamaTransform(A,B)
    scanner_position[(scanner,scanner_2)] = t
    scanner_rotation[(scanner,scanner_2)] = R

    if (scanner_2 == 0)
        scanner_position[(scanner_2,scanner)] = round.(Int,-inv(R) * t)
        scanner_rotation[(scanner_2,scanner)] = round.(inv(R))
    end
    return scanner_position,scanner_rotation
end

function CountBeacons(scanner_dict)
    scanner_position = Dict()
    scanner_rotation = Dict()
    scanner = 0
    beacons = scanner_dict[scanner]
    for (scanner,beacons) in scanner_dict
        for (scanner_2,beacons_2) in scanner_dict
            if (scanner_2 != scanner && !(haskey(scanner_position,(scanner,scanner_2)) || haskey(scanner_position,(scanner_2,scanner))))
                for axes in 1:1:3
                    dist = reduce(hcat,map(x->beacons_2[axes,:] .- x,beacons[1,:]))
                    find_overlap = countmap(reduce(vcat,dist))
                    if findmax(find_overlap)[1] >= 12
                        overlapping_beacons = findall(dist .== findmax(find_overlap)[2])
                        scanner_position,scanner_rotation = UpdateScannerDictionary(scanner,scanner_2,beacons,beacons_2,overlapping_beacons,scanner_position,scanner_rotation)
                    end
                    dist_flip = reduce(hcat,map(x->beacons_2[axes,:] .+ x,beacons[1,:]))
                    find_overlap_flip = countmap(reduce(vcat,dist_flip))
                    if findmax(find_overlap_flip)[1] >= 12
                        overlapping_beacons_flip = findall(dist_flip .== findmax(find_overlap_flip)[2])
                        scanner_position,scanner_rotation = UpdateScannerDictionary(scanner,scanner_2,beacons,beacons_2,overlapping_beacons_flip,scanner_position,scanner_rotation)
                    end
                end
            end
        end
    end

    while true
        ref_0_keys = keys(filter(kv->kv.first[1] == 0 ,scanner_position))
        if length(collect(ref_0_keys)) == length(ScannerDict)-1
            break
        else
            for key_parent in ref_0_keys
                ref_child_keys = keys(filter(kv->kv.first[1] == key_parent[2] && kv.first[2] != 0 ,scanner_position))
                for key_child in ref_child_keys
                    if (!haskey(scanner_position,(0,key_child[2])))
                        scanner_position[(0,key_child[2])] = scanner_position[(0,key_child[1])] .+ scanner_rotation[(0,key_child[1])] * scanner_position[key_child]
                        scanner_rotation[(0,key_child[2])] = scanner_rotation[(0,key_child[1])] * scanner_rotation[key_child]
                    end
                end
                ref_child_keys = keys(filter(kv->kv.first[1] != 0 && kv.first[2] == key_parent[2] ,scanner_position))
                for key_child in ref_child_keys
                    if (!haskey(scanner_position,(0,key_child[1])))
                        scanner_position[(0,key_child[1])] = round.(Int,scanner_position[(0,key_child[2])] .- scanner_rotation[(0,key_child[2])] * inv(scanner_rotation[key_child]) * scanner_position[key_child])
                        scanner_rotation[(0,key_child[1])] = round.(Int,scanner_rotation[(0,key_child[2])] * inv(scanner_rotation[key_child]))
                    end
                end
            end
        end
    end

    beacon_number = 0
    beacon_dict = Dict()
    for (key,values) in scanner_dict
        for n in 1:size(values,2)
            if (key == 0)
                beacon_number += 1
                beacon_dict[values[:,n]] = beacon_number
            else
                temp_beacon_position = scanner_rotation[(0,key)] * values[:,n] + scanner_position[(0,key)]
                if (!haskey(beacon_dict,temp_beacon_position))
                    beacon_number += 1
                    beacon_dict[temp_beacon_position] = beacon_number
                end
            end
        end
    end
    return beacon_dict,scanner_position
end

A,B = CountBeacons(ScannerDict)