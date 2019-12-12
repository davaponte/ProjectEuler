#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000060-B.py
#

from constraint import *

def IsPrime(n):
    for d in [2]+list(range(3, int(n**.5) + 1, 2)):
        if (n % d == 0):
            return False
    return (n > 1)

def Len(N):
  Res = 0;
  while (N != 0):
    Res += 1
    N //= 10
  return Res + (Res == 0)

def AddPrimes(a, b):
    for _ in range(1, Len(b) + 1):
        a *= 10
    return a + b

BigPrimes = [x for x in range(100000) if IsPrime(x)]

def IsValid(a, b):
    if Len(a) + Len(b) > 5:
        return IsPrime(AddPrimes(a, b)) and IsPrime(AddPrimes(b, a))
    else:
        return (AddPrimes(a, b) in BigPrimes) and (AddPrimes(b, a) in BigPrimes)

TenThousandsPrimes = [n for n in range(100000) if IsPrime(n) and (n < 10000)]

problem = Problem()

for n in range(2):
    problem.addVariable('P' + str(n + 1), TenThousandsPrimes)

def Valids(P1, P2, P3, P4, P5):
    return IsValid(P1, P2) and IsValid(P1, P3) and IsValid(P1, P4) and IsValid(P1, P5) and \
            IsValid(P2, P3) and IsValid(P2, P4) and IsValid(P2, P5) and \
            IsValid(P3, P4) and IsValid(P3, P5) and \
            IsValid(P4, P5)

problem.addConstraint(lambda P1, P2: IsValid(P1, P2), ('P1', 'P2'))
problem.addConstraint(AllDifferentConstraint())

Sol = problem.getSolution()
print(Sol)
