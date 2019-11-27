#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000027.py
#  

from math import sqrt

def IsPrime(n):
    if (n <= 0):
        return False
    for d in range(2, int(sqrt(n)) + 1):
        if (n % d == 0):
            return False
    return (n > 1)

def CheckQuadratic(a, b):
    Acum = 0
    n = 0
    while True:
        if IsPrime(n**2 + n * a + b):
            Acum += 1
            n += 1
        else:
            return Acum

MaxPrimes = [0, 0, 0]
for a in range(-999, 1000):
    for b in range(-1000, 1001):
        Count = CheckQuadratic(a, b)
        if (Count > MaxPrimes[0]):
            MaxPrimes[0] = Count
            MaxPrimes[1] = a
            MaxPrimes[2] = b
        
print(MaxPrimes, MaxPrimes[1] * MaxPrimes[2])
    
