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
            
            
            
            
            
            