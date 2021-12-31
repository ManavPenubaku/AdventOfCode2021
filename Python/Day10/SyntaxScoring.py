lines = []
with open('input.txt') as f:
    lines = f.readlines()

chunks = ['{}','[]','<>','()']
illegal_characters = ['}',']','>',')']

cost_dict = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137
}
correct_dict = {
    '(': 1,
    '[': 2,
    '{': 3,
    '<': 4
}

sol1 = 0
sol2 = []
incomplete_lines = []

for line in lines:
    score = 0
    lines_without_chunks = line
    chunks_present_flag = True
    while chunks_present_flag:
        lines_without_chunks = lines_without_chunks.replace("[]","")
        lines_without_chunks = lines_without_chunks.replace("<>","")
        lines_without_chunks = lines_without_chunks.replace("{}","")
        lines_without_chunks = lines_without_chunks.replace("()","")
        chunks_present_flag = any([substring in lines_without_chunks for substring in chunks])
    result = map(lambda x: lines_without_chunks.find(x), illegal_characters)
    illegal_index = min([100 if x==-1 else x for x in result])
    if illegal_index != 100:
       sol1 += cost_dict[lines_without_chunks[illegal_index]]
    else:
        new_str = lines_without_chunks.strip()
        reversed_line = new_str[::-1]
        for character in range(len(reversed_line)):
            score = score*5 + correct_dict[reversed_line[character]]
        sol2.append(score)

print("Solution to Part 1 is : ",sol1)
middleIndex = int((len(sol2) - 1)/2)
sol2.sort()
print("Solution to Part 2 is : ",sol2[middleIndex])

