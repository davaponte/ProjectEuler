#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000087.py
#

def _IsPrime(n):
    for x in range(2, int(n**.5)+1):
        if n % x == 0:
            return False
    return n>1

def IsPrime(n):
    if n <= 3:
        return n > 1
    elif (n % 2 == 0) or (n % 3 == 0):
        return False
    i = 5
    while (i * i <= n):
        if (n % i == 0) or (n % (i + 2) == 0):
            return False
        i += 6
    return True

Primes = [n for n in range(10000) if IsPrime(n) and (n < 7070)]
# El valor tope fue obtenido por iteración a mano, por bisección y varias corridas
P2 = [n*n for n in Primes]
P3 = [n**3 for n in Primes]
P4 = [n**4 for n in Primes]

Limit = 50000000
Valid = {}
for p2 in P2:
    for p3 in P3:
        if (p2 + p3 < Limit):
            for p4 in P4:
                N = p2 + p3 + p4
                if (N < Limit):
                    Valid[N] = (p2, p3, p4, N)
                    # print(str(Primes[P2.index(p2)])+'² + '+str(Primes[P3.index(p3)])+'³ + '+str(Primes[P4.index(p4)])+'⁴ =', N)

# for _, (p2, p3, p4, N) in Valid.items():
#     print(str(Primes[P2.index(p2)])+'² + '+str(Primes[P3.index(p3)])+'³ + '+str(Primes[P4.index(p4)])+'⁴ =', N)

print('ANSWER: ', len(Valid))
