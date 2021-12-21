from functools import reduce
import copy

lines = []
with open('input.txt') as f:
    lines = f.readlines()

image_enhancer = lines[0].strip()
input_image = lines[2:]

rows = 3 * len(input_image)
cols = 3 * len(input_image[0].strip())
binary_image = [[0 for col in range(cols)] for row in range(cols)]

for i in range(len(input_image),rows-len(input_image)):
    for j in range(len(input_image),cols-len(input_image)):
        binary_image[i][j] = 1 if input_image[i-len(input_image)][j-len(input_image)] == "#" else 0

def RunImageEnhancement(binary_image,image_enhancer,reps):
    new_image = [[0 for col in range(cols)] for row in range(cols)]
    for count in range(reps):
        for i in range(1,rows-1):
            for j in range(1,cols-1):
                image_section = reduce(lambda a,b:a+b, [binary_image[i-1][j-1:j+2],binary_image[i][j-1:j+2],binary_image[i+1][j-1:j+2]])
                index = 0
                for bit in image_section:
                    index = (index << 1) | bit
                new_image[i][j] = 1 if image_enhancer[index] == "#" else 0
        binary_image = copy.deepcopy(new_image)
        for nrow in [0,rows-1]:
            for ncol in range(cols):
                if count%2 == 0:
                    binary_image[nrow][ncol] = 1 if image_enhancer[0] == "#" else 0
                else:
                    binary_image[nrow][ncol] = 1 if image_enhancer[-1] == "#" else 0
        
        for ncol in [0,cols-1]:
            for nrow in range(rows):
                if count%2 ==0:
                    binary_image[nrow][ncol] = 1 if image_enhancer[0] == "#" else 0
                else:
                    binary_image[nrow][ncol] = 1 if image_enhancer[-1] == "#" else 0
    return binary_image

binary_image_p1 = RunImageEnhancement(binary_image,image_enhancer,2)
print("Solution to Part 1 is : ",sum(sum(binary_image_p1[1:-1][1:-1],[])))
binary_image_p2 = RunImageEnhancement(binary_image,image_enhancer,50)
print("Solution to Part 1 is : ",sum(sum(binary_image_p2[1:-1][1:-1],[])))



    