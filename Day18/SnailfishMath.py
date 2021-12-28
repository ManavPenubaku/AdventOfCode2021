import math

lines = []
with open('input.txt') as f:
    lines = f.readlines()
    
current_line = lines[0].strip()
line_list = lines[1:]
for line in line_list:
    pair_count = 0
    add_line = line.strip()
    current_line = "[" + current_line + "," + add_line + "]"
    cur_pos = 0
    shift_index = 1
    while cur_pos < len(current_line):
        pair_count += 1 if current_line[cur_pos] == "[" else 0
        pair_count -= 1 if current_line[cur_pos] == "]" else 0
        split_flag = 0
        left_insert = ""
        right_insert = ""
        if(current_line[cur_pos].isnumeric() and current_line[cur_pos+2].isnumeric() and pair_count >= 5):
            temp_left = current_line[cur_pos]
            temp_right = current_line[cur_pos+2]
            current_line = current_line[0:cur_pos-1] + "0" + current_line[cur_pos+4:]
            cur_pos-=1
            ind_right = next((i for i,v in enumerate(current_line[cur_pos+1:]) if v.isnumeric()),None)
            ind_left = next((i for i,v in enumerate(current_line[:cur_pos][::-1]) if v.isnumeric()),None)
            if ind_left is not None:
                left_neighbor = int(current_line[cur_pos-ind_left-1]) + int(temp_left)
                if left_neighbor >= 10:
                    split_flag = 1
                    left_insert = "[" + str(math.floor(left_neighbor/2)) + "," + str(math.ceil(left_neighbor/2)) + "]"
                else:
                    left_insert = str(left_neighbor)
                current_line = current_line[0:cur_pos-ind_left-1] + left_insert + current_line[cur_pos-ind_left :]
            if ind_right is not None:
                shift_index = 1 if len(left_insert) == 0 else len(left_insert)
                right_neighbor = int(current_line[cur_pos+ind_right+shift_index]) + int(temp_right)
                if right_neighbor >= 10:
                    split_flag = 1
                    right_insert = "[" + str(math.floor(right_neighbor/2)) + "," + str(math.ceil(right_neighbor/2)) + "]"
                else:
                    right_insert = str(right_neighbor)    
                current_line = current_line[0:cur_pos+ind_right+shift_index] + right_insert + current_line[cur_pos+ind_right+shift_index+1:]
            
            cur_pos = -1 if split_flag==1 else cur_pos-1
            pair_count = 0 if split_flag==1 else pair_count-1
            
        cur_pos+=1
        
print(current_line)
        