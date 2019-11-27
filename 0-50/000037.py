#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000037.py
#  

import math

def IsPrime(n):
    if (n == 1):
        return False
    for k in range(2, int(math.sqrt(n)) + 1):
        if n % k == 0:
            return False
    return True

Acum = 0
limit = 11 #Dice el problema que solo hay 11
n = 11     #2, 3, 5 y 7 no cuentan
while True:
    s = str(n)
    AllPrimes = True
    for k in range(len(s)):
        r = s[k:]
        l = s[:-k - 1]
        if not IsPrime(int(r)) or ((l != '') and not IsPrime(int(l))):
            AllPrimes = False
            
    if AllPrimes:
        Acum += n
        limit -= 1
        if (limit == 0): 
            break

    n += 1
    
print('ANSWER: ', Acum)
