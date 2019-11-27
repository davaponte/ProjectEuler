#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000047.py
#  

from math import sqrt

def Dividers(n):
    limit = n // 2
    for k in range(2, limit + 1):
        if (n % k == 0) and (n != k):
            yield k

def IsPrime(n):
    if (n <= 0):
        return False
    for d in range(2, int(sqrt(n)) + 1):
        if (n % d == 0):
            return False
    return (n > 1)

Primes = [n for n in range(2, 140000) if IsPrime(n)]

NumConsecutives = 0
LastConsecutive = 0
Found = False
NN = 647
print('Started...')
while not Found:
    N = NN
    Factors = {}
    while N > 1:
        for k in Primes:
            if (N % k == 0):
                N //= k
                if Factors.get(k):
                    Factors[k] += 1
                else:
                    Factors[k] = 1
                break
    L = len(Factors)
    if (L == 4):
        if (NumConsecutives == 0)  or (LastConsecutive + 1 == NN):
            NumConsecutives += 1
            LastConsecutive = NN
            if (NumConsecutives == 4):
                print('ANSWER: ', LastConsecutive - 3)
                Found = True
    else:
        LastConsecutive = 0
        NumConsecutives = 0
    # ~ if (NN % 1000 == 0):
        # ~ print(NN)
    NN += 1
