#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000045.py
#  

from math import sqrt

def TriangularNumber(n):
    return n * (n + 1) // 2

def IsTriangular(x):
    n = (sqrt(8 * x + 1) - 1) / 2
    return (n == int(n)), n

# ~ def PentagonalNumber(n):
    # ~ return n * (3 * n - 1) // 2

def IsPentagonal(x):
    n = (sqrt(24 * x + 1) + 1) / 6
    return (n == int(n)), n

# ~ def HexagonalNumber(n):
    # ~ return n * (2 * n - 1)

def IsHexagonal(x):
    n = (sqrt(8 * x + 1) + 1) / 4
    return (n == int(n)), n
    
n = 40755
i = 285

# ~ n = 40470
# ~ i = 284
while True:
    i += 1
    n = TriangularNumber(i)
    Res, Idx = IsPentagonal(n)
    if Res:
        Res, Idx = IsHexagonal(n)
        if Res:
            break

print('ANSWER: ', n)
