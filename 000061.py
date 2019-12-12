#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000061.py
#

from itertools import permutations as perm

def Triangle(n):
    return n * (n + 1) // 2

def Square(n):
    return n**2

def Pentagonal(n):
    return n * (3 * n - 1) // 2

def Hexagonal(n):
    return n * (2 * n - 1)

def Heptagonal(n):
    return n * (5 * n - 3) // 2

def Octagonal(n):
    return n * (3 * n - 2)

def F(o, n):
    if o == 3:
        R = Triangle(n)
    elif o == 4:
        R = Square(n)
    elif o == 5:
        R = Pentagonal(n)
    elif o == 6:
        R = Hexagonal(n)
    elif o == 7:
        R = Heptagonal(n)
    elif o == 8:
        R = Octagonal(n)
    return R

def Find(P1, P2, P3, P4, P5, P6):
    for i1, p1 in P1.items():
        for i2, p2 in P2.items():
            if str(p1)[2:] == str(p2)[:2]:
                for i3, p3 in P3.items():
                    if str(p2)[2:] == str(p3)[:2]:
                        for i4, p4 in P4.items():
                            if str(p3)[2:] == str(p4)[:2]:
                                for i5, p5 in P5.items():
                                    if str(p4)[2:] == str(p5)[:2]:
                                        for _, p6 in P6.items():
                                            if str(p5)[2:] == str(p6)[:2]:
                                                if str(p6)[2:] == str(p1)[:2]:
                                                    return([p1, p2, p3, p4, p5, p6], sum([p1, p2, p3, p4, p5, p6]))

P = []
P.append({n: F(3, n) for n in range(45, 141)})
P.append({n: F(4, n) for n in range(32, 100)})
P.append({n: F(5, n) for n in range(26, 81)})
P.append({n: F(6, n) for n in range(23, 71)})
P.append({n: F(7, n) for n in range(21, 64)})
P.append({n: F(8, n) for n in range(19, 59)})

L = [n for n in range(1, 6)]
Perm = perm(L)

for a, b, c, d, e in Perm:
    Response = Find(P[0], P[a], P[b], P[c], P[d], P[e])
    if Response:
        print(Response[0])
        print('ANSWER: ', Response[1])
        break
