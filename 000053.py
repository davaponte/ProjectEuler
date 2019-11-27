#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000053.py
#

from math import factorial as f

F = [f(x) for x in range(101)]

def CC(n, r):
    return F[n] / (F[r] * F[n - r])

Acum = 0
for n in range(23, 101):
    for r in range(1, n + 1):
        Count = CC(n, r)
        # print(n, r, Count, Count > 1000000)
        if (Count > 1000000):
            Acum += 1

print(Acum)
