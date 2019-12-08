#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000092.py
#

def Check(n):
    Prev = [n]
    while True:
        New = sum(int(c)**2 for c in str(n))
        if New in Prev:
            return 0
        if New == 1:
            return 1
        if New == 89:
            return 89
        n = New
        Prev.append(n)

Acum = 0
for n in range(10000000 - 1, 0, -1):
    if (n % 100000 == 0):
        print(n, '...')
    if Check(n) == 89:
        Acum += 1

print('ANSWER: ', Acum)

# 8581145
# execution time : 135.707 s
