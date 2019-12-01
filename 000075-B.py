#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000075-B.py
#

from math import sqrt

def FindWays(L):
    Ways = 0
    for a in range(int(sqrt(L)), L // 2):
        for b in range(a, L // 2):
            c = sqrt(a**2 + b**2)
            if (a + b + c == L):
                # print(a, b, int(c))
                Ways += 1
                if (Ways > 1):
                    return 0
    return Ways

Acum = 0
for L in range(12, 500): # [12, 24, 30, 36, 40, 48, 120]:
    Acum += FindWays(L)

print(Acum)
