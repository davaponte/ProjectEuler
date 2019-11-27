#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000046.py
#  

from math import sqrt

def IsPrime(n):
    for k in range(2, int(sqrt(n)) + 1):
        if n % k == 0:
            return False
    return True

n = 7
Cumple = False
while True:
    n += 2
    if IsPrime(n):
        continue
    MaxA = n - 2
    MaxB = int(sqrt((n - 2) / 2))
    Cumple = False
    for A in range(2, MaxA + 1):
        if IsPrime(A):
            for B in range(1, MaxB + 1):
                k = int(A + 2 * pow(B, 2))
                if (n == k):
                    Cumple = True
                    # ~ print(n, ' = ' + str(A) + ' + 2 * ' + str(B) + '²')
                    break
        if Cumple:
            break
                
    if not Cumple:
        print('ANSWER: ', n)
        break 

    if ((n - 1) % 2000 == 0):
        print(n)
