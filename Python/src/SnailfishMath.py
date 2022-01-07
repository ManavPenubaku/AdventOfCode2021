import math
import copy

with open('../input/day18.txt') as f:
    lines = f.readlines()

def convertEquationToList(equation):
    equation = equation.strip().replace(',','')
    list_equation = [char for char in equation]
    for n in range(len(list_equation)):
        list_equation[n] = list_equation[n] if not list_equation[n].isnumeric() else int(list_equation[n])
    return list_equation

def explode(equation):
    cur_pos = 0
    while cur_pos < len(equation) - 2:
        if(isinstance(equation[cur_pos],int) and isinstance(equation[cur_pos+1],int)):
            pair_count = equation[0:cur_pos].count('[') - equation[0:cur_pos].count(']')
            if pair_count >= 5:
                temp_left = equation[cur_pos]
                temp_right = equation[cur_pos+1]
                equation[cur_pos-1] = 0
                del equation[cur_pos:cur_pos+3]
                ind_right = next((i for i,v in enumerate(equation[cur_pos:]) if isinstance(v,int)),None)
                ind_left = next((i for i,v in enumerate(equation[:cur_pos-1][::-1]) if isinstance(v,int)),None)
                if ind_left is not None:
                    equation[cur_pos-ind_left-2] += temp_left
                if ind_right is not None:
                    equation[cur_pos+ind_right] += temp_right
                cur_pos-=2
        cur_pos+=1
    return equation

def split(equation):
    split_indices = [index for index,element in enumerate(equation) if (isinstance(element,int) and element >= 10)]
    split_equation = []
    if split_indices:
        first_split = split_indices[0]
        split_equation.extend(equation[0:first_split])
        split_equation.extend(['[', math.floor(equation[first_split]/2),math.ceil(equation[first_split]/2),']'])
        split_equation.extend(equation[first_split+1:])
    else:
        split_equation = copy.deepcopy(equation)
    return split_equation
    
def reduce(equation):
    exploded_equation = explode(equation)
    if exploded_equation != equation:
        equation = reduce(exploded_equation)
    else:
        equation = split(exploded_equation)
        if equation != exploded_equation:
            exploded_equation = reduce(equation)
    return exploded_equation

def findMagnitude(equation):
    while len(equation) > 1:
        equation = magnitude(equation)
    return equation[0]

def magnitude(eq):
    cur_pos = 0
    while cur_pos < len(eq) - 1:
        if(isinstance(eq[cur_pos],int) and isinstance(eq[cur_pos+1],int)):
            pair_magnitude = eq[cur_pos] * 3 + eq[cur_pos+1] * 2
            eq[cur_pos-1] = pair_magnitude
            del eq[cur_pos:cur_pos+3]
            cur_pos -= 2
        cur_pos+=1
    return eq

current_sum = convertEquationToList(lines[0])
line_list_p1 = lines[1:]
for line in line_list_p1:
    next_line = (convertEquationToList(line))
    line_sum = []
    line_sum.extend('[')
    line_sum.extend(current_sum)
    line_sum.extend(next_line)
    line_sum.extend(']')
    current_sum = reduce(line_sum)

magnitude_sum = findMagnitude(current_sum)
print("Solution to Part 1 is : ",magnitude_sum)

max_magnitude = 0        
for line_1 in lines:
    line_list_1 = convertEquationToList(line_1)
    for line_2 in lines:
        line_list_2 = convertEquationToList(line_2)
        line_sum = []
        line_sum.extend('[')
        line_sum.extend(line_list_1)
        line_sum.extend(line_list_2)
        line_sum.extend(']')
        max_magnitude = max(max_magnitude,findMagnitude(reduce(line_sum)))

print("Solution to Part 2 is : ",max_magnitude)