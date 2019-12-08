#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000058-B.py
#

import time

def IsPrime(n):
    for x in range(2, int(n**.5)+1):
        if n % x == 0:
            return False
    return (n > 1)

def Try(n):
    Order = 1
    Primes = 0
    for R in range(n//2, n):
        for r in (R, n-R-1):
            x = min(r, n - 1 - r)
            D = (n - 2 * x)**2  - 2 * (r - x)
            if IsPrime(D):
                Primes += 1

            c = n - r - 1
            D = (n - 2 * r - 2)**2 + (c - r)
            if IsPrime(D):
                Primes += 1

        Diags = 2 * Order - 1
        if (Primes * 10 < Diags) and (Order > 1):
            return Order
        Order += 2


start = time.time()

Order = 28001 # ya es inferior

print('ANSWER: ', Try(Order))
end = time.time()
print('Time: ', end - start)

# 26242
# 55+ s
