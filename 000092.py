#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000092.py
#

Seq = [89]

def Check(n):
    N = n
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

for n in range(1, 567 + 1): # 9999999 -> 567
    C = Check(n)
    if C == 89:
        Seq.append(C)

print(Seq)
Acum = 0
for n in range(1, 10000000):
    if (n in Seq) or (sum(int(c)**2 for c in str(n)) in Seq):
        Acum += 1

print('ANSWER: ', Acum)

# 8581145
# execution time : 135.707 s
