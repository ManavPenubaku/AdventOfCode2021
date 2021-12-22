import re

lines = []
with open('input.txt') as f:
    lines = f.readlines()
    m = re.match('^.* x=.*,y=.*,z=.*$',lines)
    print(m)

