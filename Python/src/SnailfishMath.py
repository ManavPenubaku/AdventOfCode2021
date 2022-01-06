import math
import copy

with open('../input/day18.txt') as f:
    lines = f.readlines()

def split(equation):
    equation = equation.strip().replace(',','')
    split_equation = [char for char in equation]
    for n in range(len(split_equation)):
        split_equation[n] = split_equation[n] if not split_equation[n].isnumeric() else int(split_equation[n])
    return split_equation

def explode_pair(equation,cur_pos):
    temp_left = equation[cur_pos+1]
    temp_right = equation[cur_pos+2]
    equation[cur_pos] = 0
    del equation[cur_pos+1:cur_pos+4]
    ind_right = next((i for i,v in enumerate(equation[cur_pos+1:]) if isinstance(v,int)),None)
    ind_left = next((i for i,v in enumerate(equation[:cur_pos][::-1]) if isinstance(v,int)),None)
    if ind_left is not None:
        equation[cur_pos-ind_left-1] += temp_left
    if ind_right is not None:
        equation[cur_pos+ind_right+1] += temp_right
        
    return equation

current_sum = split(lines[0])
line_list = lines[1:]

for line in line_list:
    print(line)
    next_line = (split(line))
    line_sum = []
    line_sum.extend('[')
    line_sum.extend(current_sum)
    line_sum.extend(next_line)
    line_sum.extend(']')
    pair_count = 0
    cur_pos = 0
    while cur_pos < len(line_sum)-1:
        pair_count += 1 if line_sum[cur_pos] == "[" else 0
        pair_count -= 1 if line_sum[cur_pos] == "]" else 0
        if(isinstance(line_sum[cur_pos+1],int) and isinstance(line_sum[cur_pos+2],int) and pair_count >= 5):
            line_sum = explode_pair(line_sum, cur_pos)
            pair_count -= 1 
            
        split_indices = [index for index,element in enumerate(line_sum) if (isinstance(element,int) and element >= 10)]
        while split_indices:
            for n in range(len(split_indices)):
                temp_sum = []
                temp_sum.extend(line_sum[0:split_indices[n]])
                temp_sum.extend(['[', math.floor(line_sum[split_indices[n]]/2),math.ceil(line_sum[split_indices[n]]/2),']'])
                temp_sum.extend(line_sum[split_indices[n]+1:])
                pair_count = temp_sum[0:split_indices[n]+1].count('[') - temp_sum[0:split_indices[n]+1].count(']')
                if pair_count >= 5:
                    temp_sum = explode_pair(temp_sum,split_indices[n])
                elif(n < len(split_indices)-1): 
                    split_indices[n+1] += 3           
                line_sum = copy.deepcopy(temp_sum)
                
            split_indices = [index for index,element in enumerate(line_sum) if (isinstance(element,int) and element >= 10)]
            cur_pos = -1
            pair_count = 0          
            
        cur_pos+=1
        
    current_sum = copy.deepcopy(line_sum)
        
print(current_sum)
        
