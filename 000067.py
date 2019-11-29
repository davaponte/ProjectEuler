#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000018.py
#

f = open('p067_triangle.txt')
lines = f.read()
f.close()


triangle = [[int(cell) for cell in line.split()] for line in lines.split('\n') if line != '']

def PrintData():
    print('***DATA***')
    for l in triangle:
        print(l)

bottom = len(triangle) - 1
# ~ print(bottom)

for row in range(bottom, -1, -1):
    NewUpperRow = []
    for col in range(len(triangle[row]) - 1):
        a = triangle[row][col] + triangle[row - 1][col]
        b = triangle[row][col + 1] + triangle[row - 1][col]
        NewUpperRow.append(max(a, b))
        # ~ print(col, end=' ')
    # ~ print()
    # ~ print(NewUpperRow)
    triangle[row - 1] = NewUpperRow

print('ANSWER: ', triangle[0][0])
