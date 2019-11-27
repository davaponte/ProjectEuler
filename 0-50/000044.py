#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000044.py
#  

from math import sqrt

def PentagonalNumber(n):
    return n * (3 * n - 1) // 2
    
def IsPentagonal(x):
    n = (sqrt(24 * x + 1) + 1) / 6
    return (n == int(n)), n
    
MaxItems = 100000
PN = {n: PentagonalNumber(n) for n in range(1, MaxItems + 1)}

MinD = 10000000000
for a in range(1, MaxItems + 1):
    for b in range(1, a + 1):
        c = PN[a] + PN[b]
        Result, keyc = IsPentagonal(c)
        keyc = int(keyc)
        if Result:
            d = abs(PN[a] -PN[b])
            Result, keyd = IsPentagonal(d)
            keyd = int(keyd)
            if Result:
                print(' P[' + str(a) + '] + P[' + str(b) + ']  =  ' + str(PN[a]) + ' + ' + str(PN[b]) + '  = ' + str(c) + ' = P[' + str(keyc) + ']')
                print('|P[' + str(a) + '] - P[' + str(b) + ']| = |' + str(PN[a]) + ' - ' + str(PN[b]) + '| = ' + str(d) + ' = P[' + str(keyd) + ']')
                print()
                if (d < MinD):
                    MinD = d
                    
print('ANSWER: ', MinD)
            

