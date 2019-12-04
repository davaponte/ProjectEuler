#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000080.py
#

from Sqrt import *

Suma =  0
for N in range(1, 101):
    S = ''.join(Sqrt(N, 100))
    ent = S[:S.index('.')]
    frac = S[S.index('.') + 1:]
    s = ent + frac
    s = s[:100]
    # print('Number: ', N)
    # print('Root: ', S, end=' ')
    if len(frac) > 95:
        Sum = sum(int(x) for x in s)
        # print('Ok:', Sum)
        Suma += Sum
    # else:
    #     print('NOT')

print('ANSWER: ', Suma)
