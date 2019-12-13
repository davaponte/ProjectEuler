#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# 000094.py
#

Sum = 0
c = 3
Abort = False
while not Abort:
    for z in [-1, 1]:
        if Abort:
            continue
        B = c + z
        b = B//2
        a = (c**2 - b**2)**.5
        if (B*a) % 3 == 0:
            L = 2*c + B
            # print(int(a), b, c, B, L)
            if (L > 1000000):
                Abort = True
                break
            Sum += L
    c += 2

print('ANSWER: ', Sum)
