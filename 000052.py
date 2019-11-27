#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000052.py
#

Factors = [1, 2, 3, 4, 5, 6]

N = 125874
while True:
    Numbers = []
    for k in Factors:
        Numbers.append(N * k)

    L = []
    for i in Numbers:
        l = list(str(i))
        l.sort()
        n = sum(int(l[len(l)-i-1]) * 10**i for i in range(len(l)))
        L.append(n)
    # print(L)
    if all(x == L[0] for x in L):
        print(Numbers)
        print('ANSWER: ', N)
        break
    # if (N % 100 == 0):
    #     print(N)
    N += 1
