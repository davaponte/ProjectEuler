#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000057.py
#

# Dos formas de resolverlos. Una con ecuaciones y otra iterativa

# Con ecuaciones es rápido. Unos 45ms
n, d = 3, 2
k = 1
s = 0
while True:
    n, d = n + 2 * d, n + d
    k += 1
    # print(k, n, d)
    if len(str(n)) > len(str(d)):
        s += 1
    if k == 1000:
        break

print('ANSWER :', s)

# De modo iterartivo es bastante más lento. Casi 12s
from fractions import Fraction as f

Cnt = 0
for kk in range(1, 1001):
    D = f(2, 1)
    k = kk
    while k > 0:
        D = 1 / D
        if k > 1:
            D = 2 + D
        else:
            D = 1 + D
        k -= 1

    s = str(D);
    num, den = s[:s.index('/')], s[s.index('/')+1:]
    if len(num) > len(den):
        Cnt += 1
    #print(kk, num, '/', den, int(num) / float(den), len(num) > len(den))

print('ANSWER: ', Cnt)
