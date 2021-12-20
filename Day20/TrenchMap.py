lines = []
with open('input.txt') as f:
    lines = f.readlines()

image_enhancer = lines[0]

input_image = lines[2:]

print(input_image[0][1])

    