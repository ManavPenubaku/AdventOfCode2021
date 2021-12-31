import re
import copy

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

def CheckCubeIntersection(cube1,cube2):
    xmin_int = max(cube1[0],cube2[0])
    xmax_int = min(cube1[1],cube2[1])
    ymin_int = max(cube1[2],cube2[2])
    ymax_int = min(cube1[3],cube2[3])
    zmin_int = max(cube1[4],cube2[4])
    zmax_int = min(cube1[5],cube2[5])
    if xmin_int <= xmax_int and ymin_int <= ymax_int and zmin_int <= zmax_int : 
        return 1,tuple([xmin_int,xmax_int,ymin_int,ymax_int,zmin_int,zmax_int])
    else:
        return 0,cube1
    
def ExecuteRebootSteps(step_count,state_list,cuboid_list):
    first_cube = tuple(map(lambda x: int(x),cuboid_list[0]))
    volume_dict = {first_cube : 1}
    for n in range(1,step_count,1):
        cuboid2 = tuple(map(lambda x: int(x),cuboid_list[n]))
        new_volume_dict = copy.deepcopy(volume_dict)
        for cuboid,sign in volume_dict.items():
            int_flag,int_coord = CheckCubeIntersection(cuboid,cuboid2)
            if (int_flag == 1):
                if int_coord in new_volume_dict:
                    new_volume_dict[int_coord] -= sign 
                else:
                    new_volume_dict[int_coord] = -sign
        if state_list[n][0] == 'on':
            if(cuboid2 in new_volume_dict):
                new_volume_dict[cuboid2] += 1
            else:
                new_volume_dict[cuboid2] = 1
        volume_dict = copy.deepcopy(new_volume_dict)
        volume_dict = dict(filter(lambda x : x[1] != 0,volume_dict.items()))     
    total_volume = 0
    for cuboid,sign in volume_dict.items():
        volume = (cuboid[1]-cuboid[0]+1)*(cuboid[3]-cuboid[2]+1)*(cuboid[5]-cuboid[4]+1)
        signed_volume = sign * volume
        total_volume += signed_volume
    return total_volume

volume_p1 = ExecuteRebootSteps(20, state_list,cuboid_list)
print("Solution to Part 1 is : ",volume_p1)
volume_p2 = ExecuteRebootSteps(len(state_list), state_list, cuboid_list)
print("Solution to Part 2 is : ",volume_p2)
            

        
            
            