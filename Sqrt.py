#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  Sqrt.py
#
# Un intento de crear un generador para
# raíz cuadrada ilimitada por long division

# from SquareRoots import *

def Sqrt(N, numdec=None):
    s = str(N)
    if '.' in s:
        ent,frac = str(N).split('.')
    else:
        ent = s
        frac = '00'
    if len(ent) % 2 != 0:
        ent = '0' + ent
    if len(frac) % 2 != 0:
        frac = frac + '0'
    dp = len(ent) // 2

    s = ent + frac
    L = [int(s[x] + s[x + 1]) for x in range(0, len(s), 2)]

    def Find(n):
        for x in range(1, 11):
            if (x * x > n):
                return x - 1

    def Find2(n, l):
        for x in range(1, 11):
            if ((n * 10 + x) * x > l):
                return x - 1

    Sol = []
    k = 0
    n = L[k]
    x = Find(n)
    Sol.append(str(x))
    yield(str(x))
    xc = x ** 2

    decimals = 0
    while True:
        dif = n - xc
        k += 1
        if (k >= len(L)):
            if (dif == 0):
                break
            n = dif * 100
        else:
            n = dif * 100 + L[k]

        x2 = x * 2
        x = Find2(x2, n)

        Sol.append(str(x))
        if (k == dp):
            yield('.' + str(x))
            decimals += 1
        else:
            yield(str(x))
            if (decimals > 0):
                decimals += 1
        xc = (x2 * 10 + x) * x
        x = int(''.join(Sol))
        if numdec and (numdec > 0):
            if (decimals == numdec):
                break

# SqrtN = ''.join(Sqrt(25, 100))
# print(SqrtN)

# Sqrt2 = ''.join(Sqrt(2, 10000))
# print(Sqrt2)
# print(Sqrt2Full)
# print(Sqrt2 == Sqrt2Full)
#
# Sqrt3 = ''.join(Sqrt(3, 10000))
# print(Sqrt3)
# print(Sqrt3Full)
# print(Sqrt3 == Sqrt3Full)
#
# Sqrt5 = ''.join(Sqrt(5, 10000))
# print(Sqrt5)
# print(Sqrt5Full)
# print(Sqrt5 == Sqrt5Full)
#
