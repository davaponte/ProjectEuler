#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000074.py
#

from math import factorial

Tope = 10
F = [factorial(x) for x in range(Tope)]

Exactly60Loops = 0
for n in range(1, 1000000):
    Number = n
    # print(Number)
    Loops = 0
    while True:
        Number = sum(F[int(x)] for x in str(Number))
        if (Number > 1000000):
            break
        # print(Number)
        Loops += 1
        if (Loops == 60):
            break
        if (Number == n):
            break

    if (Number < 1000000) and (Loops == 60):
        # print('N: ', n, 'Loops: ', Loops)
        Exactly60Loops += 1

print('ANSWER: ', Exactly60Loops)
