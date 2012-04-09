#!/usr/bin/env python
from copy import copy
triang_str1 = """
3
7 4
2 4 6
8 5 9 3"""

triang_str2 = """
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23"""

def init_triang(str):
    raw = map( lambda s: map(lambda sn: [int(sn),None],s.split(" ")), str.strip().split("\n") )
    grid = map( copy, [[[0,None]] * (len(raw[-1]) * 2-1)] * len(raw) )
    for i in range(len(raw)):
        start = (len(grid[i]) - len(raw[i])*2 + 1)/2
        for j in range(len(raw[i])):
            grid[i][start + j * 2] = raw[i][j]
    middle = len(grid[0])/2
    return middle, grid

def max_sum(triangle,row,col):
    if row >= len(triangle):
        return 0
    node = triangle[row][col]
    if node[1] != None:
        return node[1]
    m = node[0] + max( max_sum(triangle,row+1,col-1), max_sum(triangle,row+1,col+1) )
    node[1] = m
    return m

if __name__ == '__main__':
    middle, t = init_triang(triang_str2)

    print max_sum(t,0,middle)
#print "\n".join( map( lambda x: " ".join(map(str,x)), t ) )
