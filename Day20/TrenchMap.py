from functools import reduce
import copy

lines = []
with open('input.txt') as f:
    lines = f.readlines()

image_enhancer = lines[0]
input_image = lines[2:]

rows = len(input_image) + 8
cols = len(input_image[0].strip()) + 8
binary_image = [[0 for col in range(cols)] for row in range(cols)]

for i in range(4,rows-4):
    for j in range(4,cols-4):
        binary_image[i][j] = 1 if input_image[i-4][j-4] == "#" else 0

new_image = [[0 for col in range(cols)] for row in range(cols)]

for count in range(2):
    for i in range(1,rows-1):
        for j in range(1,cols-1):
            image_section = reduce(lambda a,b:a+b, [binary_image[i-1][j-1:j+2],binary_image[i][j-1:j+2],binary_image[i+1][j-1:j+2]])
            index = 0
            for bit in image_section:
                index = (index << 1) | bit
            new_image[i][j] = 1 if image_enhancer[index] == "#" else 0
    binary_image = copy.deepcopy(new_image)
    for nrow in [0,1,rows-2,rows-1]:
        for ncol in range(cols):
            binary_image[nrow][ncol] = 1

    for ncol in [0,1,cols-2,cols-1]:
        for nrow in range(rows):
            binary_image[nrow][ncol] = 1

    print(binary_image[0])

print("Solution to Part 1 is : ",sum(sum(binary_image[1:-2][1:-2],[])))


    