#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000034.py
#  

from math import factorial as f

F = [f(x) for x in range(10)]

Acum = 0
for n in range(3, F[9] + 1):
    s = str(n)
    if (sum(F[int(x)] for x in s) == n):
        Acum += n
        print(n)
        
print('ANSWER: ', Acum)
