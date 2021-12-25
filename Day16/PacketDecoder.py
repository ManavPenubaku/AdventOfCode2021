from future.backports.xmlrpc.client import Binary
from PIL.features import check
from _operator import sub
lines = []
with open('example.txt') as f:
    lines = f.readlines()

hexadecimal_input = lines[0].strip()
bin_input = bin(int(hexadecimal_input,16))

def parse_packet(binary_input,id,check_finish):
    packet_ver_start = 1
    cur_pos = 0
    packet_version_sum = 0
    literal_value = []
    packet_count = 0;
    while True:
        if(packet_ver_start == 1):
            print(binary_input[cur_pos:cur_pos+3])
            packet_version_sum += int(binary_input[cur_pos:cur_pos+3],2)
            packet_ver_start = 0
            packet_id_start = 1
            cur_pos += 3
        elif(packet_id_start == 1):
            packet_id = int(binary_input[cur_pos:cur_pos+3],2)
            packet_id_start = 0
            cur_pos += 3
        elif(packet_id == 4):
            while True:
                if len(binary_input[cur_pos:cur_pos+5]) == 5:
                    literal_value.append(binary_input[cur_pos+1:cur_pos+5])
                else:
                    break
                
                if(int(binary_input[cur_pos],2) == 0):
                    cur_pos+=5
                    packet_ver_start = 1
                    packet_count+=1
                    break
                else:
                    cur_pos+=5
        else:
            length_type_id = int(binary_input[cur_pos],2)
            cur_pos+=1
            if(length_type_id == 0):
                sub_packet_length = int(binary_input[cur_pos:cur_pos+15],2)
                cur_pos+=15
                temp_sum,temp_pos = parse_packet(binary_input[cur_pos:cur_pos+sub_packet_length],1,sub_packet_length)
                packet_count+=1
                cur_pos += sub_packet_length
                packet_version_sum += temp_sum
                packet_ver_start = 1
            elif(length_type_id == 1):
                sub_packet_count = int(binary_input[cur_pos:cur_pos+11],2)
                cur_pos+=11
                temp_sum,temp_pos = parse_packet(binary_input[cur_pos:],2,sub_packet_count)
                packet_count+=1
                cur_pos += temp_pos+1
                packet_version_sum += temp_sum
                packet_ver_start = 1
                
        if(id==2 and (packet_count == check_finish)):
            break
        elif(id==1 and cur_pos+11 >= min(check_finish,len(binary_input))):
            break
    return packet_version_sum,cur_pos

sol1,sol2 = parse_packet(bin_input[2:], 1, len(bin_input[2:]))
print("Solution to Part 1 is : ",sol1)
