from collections import defaultdict
from curses.ascii import islower, isupper

graph = defaultdict(list)

def addEdge(graph,u,v):
    graph[u].append(v)

with open('../input/day12.txt') as f:
    for line in f.readlines():
        vertices = (line.strip()).split('-')
        if vertices[1] == 'start' or vertices[0] == 'end':
            addEdge(graph,vertices[1],vertices[0])
        elif vertices[0] == 'start' or vertices[1] == 'end':
            addEdge(graph,vertices[0],vertices[1])
        else:
            addEdge(graph,vertices[0],vertices[1])
            addEdge(graph,vertices[1],vertices[0])

def find_all_paths_p1(graph,start,end,path = []):
    path = path + [start]
    if start == end:
        return [path]
    paths = []
    for node in graph[start]:
        if node not in path or node.isupper():
            newpaths = find_all_paths_p1(graph, node, end,path)
            for newpath in newpaths:
                paths.append(newpath)
    return paths

def find_all_paths_p2(graph,start,end,path = []):
    path = path + [start]
    if start == end:
        return [path]
    paths = []
    for node in graph[start]:
        small_cave_count = 0
        allow_small_cave_visit = 0
        for path_node in path:
            if path_node.islower() and path_node != 'start' and path_node != 'end':
                small_cave_count = max(small_cave_count,path.count(path_node))
        
        if small_cave_count == 1:
            allow_small_cave_visit = 1
        
        if node not in path or node.isupper() or allow_small_cave_visit:
            newpaths = find_all_paths_p2(graph, node, end,path)
            for newpath in newpaths:
                paths.append(newpath)
    return paths

path_list = find_all_paths_p1(graph, 'start', 'end')

print("Solution to Part 1 is : ",len(path_list))

path_list_p2 = find_all_paths_p2(graph, 'start', 'end')
print("Solution to Part 1 is : ",len(path_list_p2))


