#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000102.py
#

# Las dos siguientes funciones vienen de StackOverflow:
# https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle

def Sign(p1, p2, p3):
    return (p1[0] - p3[0]) * (p2[1] - p3[1]) - (p2[0] - p3[0]) * (p1[1] - p3[1])

def PointInTriangle(pt, v1, v2, v3):
    d1 = Sign(pt, v1, v2);
    d2 = Sign(pt, v2, v3);
    d3 = Sign(pt, v3, v1);

    has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0);
    has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0);

    return not(has_neg and has_pos);

f = open('/home/data/Projects/Python/ProjectEuler/p102_triangles.txt')
lines = f.readlines()
Inside = 0
for line in lines:
    s = line.replace('\n', '')
    px, py, qx, qy, rx, ry = s.split(',')
    px, py, qx, qy, rx, ry = int(px), int(py), int(qx), int(qy), int(rx), int(ry)
    if PointInTriangle((0, 0), (px, py), (qx, qy), (rx, ry)):
        Inside += 1
f.close()

print('ANSWER: ', Inside)
