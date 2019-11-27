#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000035.py
#  

import math

def IsPrime(n):
    for k in range(2, int(math.sqrt(n)) + 1):
        if n % k == 0:
            return False
    return True

Count = 0
for n in range(2, 1000000):
    s = str(n)
    AllPrimes = True
    for k in range(len(s)):
        if not IsPrime(int(s)):
            AllPrimes = False
            break
        # ~ print(s, end=' ')
        s = s[1:] + s[0]
    if AllPrimes:
        # ~ print(n)
        Count += 1
        
print('ANSWER: ', Count)
    
    
