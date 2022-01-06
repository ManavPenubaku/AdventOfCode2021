lines = []
with open('../input/day16.txt') as f:
    lines = f.readlines()

hexadecimal_input = lines[0].strip()
bin_input = bin(int(hexadecimal_input,16))

def evaluate_packet_1(type_id,prev,current):
    eval = 0
    if(prev == -1): eval = current
    elif(type_id == 0):eval = prev + current
    elif(type_id == 1):eval = prev * current
    elif(type_id == 2):eval = min(prev,current) 
    elif(type_id == 3):eval = max(prev,current)
    return eval 

def evaluate_packet_2(type_id,prev,current):
    if(prev == -1): eval = current
    elif(type_id == 5):eval = 1 if prev > current else 0
    elif(type_id == 6):eval = 1 if prev < current else 0
    elif(type_id == 7):eval = 1 if prev == current else 0
    return eval

def parse_packet(binary_input,id,check_finish,operator_id):
    packet_ver_start = 1
    cur_pos = 0
    packet_version_sum = 0
    literal_value_list = []
    literal_value = 0
    packet_count = 0
    packet_value = -1
    subpacket_value = 0
    packet_id = 0
    while True:         
        if(id == 2):
            if(packet_count == check_finish):
                break
            elif(cur_pos+3 >= len(binary_input) and check_finish < len(binary_input)):
                cur_pos = min(cur_pos,len(binary_input))
                break
            elif(cur_pos+3 >= len(binary_input) and check_finish > len(binary_input)):
                cur_pos = len(binary_input)   
                break   
        elif(id == 1 and cur_pos+3 >= min(check_finish,len(binary_input))): 
            if (check_finish > len(binary_input)):
                cur_pos = len(binary_input)-1
            else:
                cur_pos = min(cur_pos,len(binary_input))
            break
        
        if(packet_ver_start == 1):
            packet_version_sum += int(binary_input[cur_pos:cur_pos+3],2)
            packet_ver_start = 0
            packet_id_start = 1
            cur_pos += 3
        elif(packet_id_start == 1):
            packet_id = int(binary_input[cur_pos:cur_pos+3],2)
            packet_id_start = 0
            cur_pos += 3
        else:
            if(packet_id == 4):
                while True:
                    literal_value_list.append(binary_input[cur_pos+1:cur_pos+5])
                    if(int(binary_input[cur_pos],2) == 0):
                        literal_value = int(''.join(literal_value_list),2)
                        cur_pos+=5
                        packet_ver_start = 1
                        packet_count+=1
                        literal_value_list = []
                        break
                    else:
                        cur_pos+=5    
            else:
                length_type_id = int(binary_input[cur_pos],2)
                cur_pos+=1
                if(length_type_id == 0):
                    sub_packet_length = min(len(binary_input),int(binary_input[cur_pos:cur_pos+15],2))
                    cur_pos+=15
                    temp_sum,temp_pos,subpacket_value = parse_packet(binary_input[cur_pos:cur_pos+sub_packet_length],1,sub_packet_length,packet_id)
                    packet_count+=1
                    cur_pos += sub_packet_length
                    packet_version_sum += temp_sum
                    packet_ver_start = 1
                elif(length_type_id == 1):
                    sub_packet_count = int(binary_input[cur_pos:cur_pos+11],2)
                    cur_pos+=11
                    temp_sum,temp_pos,subpacket_value = parse_packet(binary_input[cur_pos:],2,sub_packet_count,packet_id)
                    packet_count+=1
                    cur_pos += temp_pos
                    packet_version_sum += temp_sum
                    packet_ver_start = 1        
            
            if(packet_id == 4):
                if(operator_id < 4):
                    packet_value = evaluate_packet_1(operator_id,packet_value,literal_value)
                elif(operator_id > 4):
                    packet_value = evaluate_packet_2(operator_id, packet_value,literal_value)
            else:
                if(operator_id < 4):
                    packet_value = evaluate_packet_1(operator_id,packet_value,subpacket_value)
                elif(operator_id > 4):
                    packet_value = evaluate_packet_2(operator_id, packet_value,subpacket_value)
                else:
                    packet_value = subpacket_value

    return packet_version_sum,cur_pos,packet_value

sol1,packet_pos,sol2 = parse_packet(bin_input[2:], 1, len(bin_input[2:]),4)
print("Solution to Part 1 is : ",sol1)
print("Solution to Part 2 is : ",sol2)
