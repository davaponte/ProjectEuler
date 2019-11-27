#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000049.py
#  

from itertools import permutations as perm
from math import sqrt
import sys

def IsPrime(n):
    if (n == 1):
        return False
    for d in range(2, int(sqrt(n)) + 1):
        if (n % d == 0):
            return False
    return True

Pow = [1, 10, 100, 1000]
def ToNumber(l):
    return sum(int(l[len(l) - c - 1]) * Pow[c] for c in range(len(l)))

for n in range(1000, 10000):
    if not IsPrime(n):
        continue
    s = str(n)
    P = list(perm(s))
    for a in P:
        n1 = ToNumber(a)
        if (n1 == n) or not IsPrime(n1):
            continue
        for b in P:
            n2 = ToNumber(b)
            if (n2 == n1) or (n2 == n) or not IsPrime(n2):
                continue
            if (n2 - n1 == n1 - n) and (n2 > n1) and not (n in [1487, 4817, 8147]):
                print('ANSWER: ', str(n) + str(n1) + str(n2), ' diff: ', n2 - n1)
                sys.exit()
