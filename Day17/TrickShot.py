import re

lines = []
with open('input.txt') as f:
    lines = f.readlines()

p_targets = re.compile(r'-\d+|\d+')
target_list = []

for line in lines:
    target_list.append(p_targets.findall(line.strip()))

target_x_min = int(target_list[0][0])
target_x_max = int(target_list[0][1])
target_y_min = int(target_list[0][2])
target_y_max = int(target_list[0][3])

sol_p1 = abs(target_y_min+1) * (abs(target_y_min+1)+1)/2
print("Solution to Part 1 is : ",sol_p1)

def simulate_trajectory(xv,yv):
    xpos = 0
    ypos = 0
    while xpos <= target_x_max and ypos >= target_y_min:
        xpos += xv
        ypos += yv
        xv = max(0,xv-1)
        yv = yv-1
        if (target_x_max >= xpos >= target_x_min and target_y_max >= ypos >= target_y_min):
            return 1
    return 0


valid_vel_count = 0
for x_vel in range(13,130):
    for y_vel in range(-150,150):
            valid_vel_count += simulate_trajectory(x_vel, y_vel) 

print("Solution to Part 2 is : ",valid_vel_count)
            