import re
from gi._compat import xrange

lines = []
with open('input.txt') as f:
    lines = f.readlines()

p_coord = re.compile(r'-\d+|\d+')
p_state = re.compile('(on|off)')
cuboid_list = []
state_list = []
for line in lines:
    cuboid_list.append(p_coord.findall(line.strip()))
    state_list.append(p_state.findall(line.strip()))

region = [[[0 for k in xrange(101)]for j in xrange(101)]for i in xrange(101)]

on_cubes = 0;

for n in range(len(state_list)):
    cuboid_indices = list(map(lambda x: int(x)+50,cuboid_list[n]))
    within_bounds = list(map(lambda x: x>=0 and x<=100,cuboid_indices))
    if(sum(within_bounds) == 6):
        if state_list[n][0] == 'on':
            for i in range(cuboid_indices[0],cuboid_indices[1]+1):
                for j in range(cuboid_indices[2],cuboid_indices[3]+1):
                    for k in range(cuboid_indices[4],cuboid_indices[5]+1):
                        if(region[i][j][k] == 0):
                            region[i][j][k] = 1
                            on_cubes+=1
        else:
            for i in range(cuboid_indices[0],cuboid_indices[1]+1):
                for j in range(cuboid_indices[2],cuboid_indices[3]+1):
                    for k in range(cuboid_indices[4],cuboid_indices[5]+1):
                        if(region[i][j][k] == 1):
                            region[i][j][k] = 0
                            on_cubes-=1


print(on_cubes)

def CheckCubeIntersection(cube1,cube2):
    no_intersection = 0
    xmin_int = cube1[0]
    ymin_int  = cube1[2]
    zmin_int = cube1[4]
    if(cube1[0] > cube2[1]):
        no_intersection+=1
    elif(cube1[0] >= cube2[0]):
        xmin_int = cube1[0]
    elif(cube1[1] >= cube2[0]):
        xmin_int = cube2[0]
        
    if(cube1[2] > cube2[3]):
        no_intersection+=1
    elif(cube1[2] >= cube2[2]):
        ymin_int = cube1[2]
    elif(cube2[2] <= cube1[3]):
        ymin_int = cube2[2]
    
    if(cube1[4] > cube2[5]):
        no_intersection+=1
    elif(cube1[4] >= cube2[4]):
        zmin_int = cube1[4]
    elif(cube2[4] <= cube1[5]):
        zmin_int = cube2[4]
        
    if (no_intersection == 3):
        return 0,cube1
    else:
        return 1,[xmin_int,cube1[1],ymin_int,cube1[3],zmin_int,cube1[5]]

non_intersecting_list = [list(map(lambda x: int(x),cuboid_list[0]))]
for n in range(1,20,1):
    cuboid_2 = list(map(lambda x: int(x),cuboid_list[n]))
    for cuboid in non_intersecting_list:
        int_flag,int_coord = CheckCubeIntersection(cuboid,cuboid_2)
        if (int_flag == 0):
            non_intersecting_list.append(cuboid_2)
        else:
            print(int_coord)
        
print(non_intersecting_list)
            
            
            
            
            