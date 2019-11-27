#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000039.py
#  

from math import sqrt

P = {}
for a in range(1, 1000):
    for b in range(1, 1000):
        c = sqrt(pow(a, 2) + pow(b, 2))
        if (c == int(c)):
            k = a + b + int(c)
            if (k <= 1000):
                print(a, b, int(c), k)
                if P.get(k):
                    P[k] += 1
                else:
                    P[k] = 1
                
val = max(P[x] for x in P.keys())
key = next(key for key, value in P.items() if value == val)

print('#Triangles found for the winner: ', P[key])
print('ANSWER: ', key)
