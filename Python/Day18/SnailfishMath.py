import math
import copy

with open('example.txt') as f:
    lines = f.readlines()

def split(equation):
    equation = equation.strip().replace(',','')
    split_equation = [char for char in equation]
    for n in range(len(split_equation)):
        split_equation[n] = split_equation[n] if not split_equation[n].isnumeric() else int(split_equation[n])
    return split_equation

current_sum = split(lines[0])
line_list = lines[1:]

for line in line_list:
    next_line = (split(line))
    line_sum = []
    line_sum.extend('[')
    line_sum.extend(current_sum)
    line_sum.extend(next_line)
    line_sum.extend(']')
    pair_count = 0
    cur_pos = 0
    shift_index = 1
    while cur_pos < len(line_sum)-2:
        pair_count += 1 if line_sum[cur_pos] == "[" else 0
        pair_count -= 1 if line_sum[cur_pos] == "]" else 0
        split_flag = 0
        if(isinstance(line_sum[cur_pos+1],int) and isinstance(line_sum[cur_pos+2],int) and pair_count >= 5):
            print(line_sum)
            temp_left = line_sum[cur_pos+1]
            temp_right = line_sum[cur_pos+2]
            line_sum[cur_pos] = 0
            del line_sum[cur_pos+1:cur_pos+4]
            ind_right = next((i for i,v in enumerate(line_sum[cur_pos+1:]) if isinstance(v,int)),None)
            ind_left = next((i for i,v in enumerate(line_sum[:cur_pos][::-1]) if isinstance(v,int)),None)
            
            if ind_left is not None:
                line_sum[cur_pos-ind_left-1] += temp_left
            
            if ind_right is not None:
                line_sum[cur_pos+ind_right+1] += temp_right
            
            cur_pos = -1
            pair_count = 0  
        elif(isinstance(line_sum[cur_pos],int) and line_sum[cur_pos] >= 10):
            print(line_sum)
            temp_sum = []
            temp_sum.extend(line_sum[0:cur_pos])
            temp_sum.extend(['[', math.floor(line_sum[cur_pos]/2),math.ceil(line_sum[cur_pos]/2),']'])
            temp_sum.extend(line_sum[cur_pos+1:])
            line_sum = copy.deepcopy(temp_sum)
            cur_pos = -1
            pair_count = 0
            
        cur_pos+=1
        
    current_sum = copy.deepcopy(line_sum)
        
print(current_sum)
        
