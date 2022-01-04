using StatsBase

file = open("example.txt")
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

function UpdateBeaconDictionary(beacons_1,beacons_2,beacons_overlap,beacondict,beacon_number)
    for n in 1:1:size(beacons_overlap,1)
        println(beacons_2[:,beacons_overlap[n][1]])
        println(beacons_1[:,beacons_overlap[n][2]])
        sleep(0.5)
        if (haskey(beacondict,beacons_2[:,beacons_overlap[n][1]]))
            beacondict[beacons_1[:,beacons_overlap[n][2]]] = beacondict[beacons_2[:,beacons_overlap[n][1]]]
        elseif (haskey(beacondict,beacons_1[:,beacons_overlap[n][2]]))
            beacondict[beacons_2[:,beacons_overlap[n][1]]] = beacondict[beacons_1[:,beacons_overlap[n][2]]]
        else 
            beacon_number += 1
            beacondict[beacons_1[:,beacons_overlap[n][2]]] = beacon_number
            beacondict[beacons_2[:,beacons_overlap[n][1]]] = beacon_number
        end
    end
    return beacondict,beacon_number
end

function CountBeacons(scanner_dict)
    beacondict = Dict()
    scanner_position = Dict(0 => [0,0,0])
    beacon_number = 0
    for (scanner,beacons) in scanner_dict
        for (scanner_2,beacons_2) in scanner_dict
            if (scanner_2 != scanner)
                for axes in 1:1:3
                    dist = reduce(hcat,map(x->beacons[axes,:] .- x,beacons_2[2,:]))
                    find_overlap = countmap(reduce(vcat,dist))
                    if findmax(find_overlap)[1] >= 12
                        overlapping_beacons = findall(dist .== findmax(find_overlap)[2])
                        beacondict,beacon_number = UpdateBeaconDictionary(beacons_2,beacons,overlapping_beacons,beacondict,beacon_number)
                    end

                    dist_flip = reduce(hcat,map(x->beacons[axes,:] .+ x,beacons_2[2,:]))
                    find_overlap_flip = countmap(reduce(vcat,dist_flip))
                    if findmax(find_overlap_flip)[1] >= 12
                        overlapping_beacons_flip = findall(dist_flip .== findmax(find_overlap_flip)[2])
                        beacondict,beacon_number = UpdateBeaconDictionary(beacons_2,beacons,overlapping_beacons_flip,beacondict,beacon_number)
                    end
                end
            end
        end
    end

    beacon_count = 0
    for (scanner,beacons) in scanner_dict
        for n in 1:1:size(beacons,2)
            if !haskey(beacondict,beacons[:,n])
                beacon_count += 1 
            end
        end
    end
    beacon_count += maximum(values(beacondict))
    return beacondict,beacon_count
end

BeaconDict,beacon_count = CountBeacons(ScannerDict)