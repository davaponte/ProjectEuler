#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000043.py
#  

from itertools import permutations as p

l = [x for x in range(10)]
P = p(l)
L = list(P)

N = []
N.append({'div': 2, 'num': 0})
N.append({'div': 3, 'num': 0})
N.append({'div': 5, 'num': 0})
N.append({'div': 7, 'num': 0})
N.append({'div': 11, 'num': 0})
N.append({'div': 13, 'num': 0})
N.append({'div': 17, 'num': 0})

Acum = 0
for i in L:
    s = ' ' + str(i).replace('(', '').replace(')', '').replace(', ', '')
    FullDiv = True
    for k in range(len(N)):
        N[k]['num'] = int(s[k + 2: k + 5])
        if N[k]['num'] % N[k]['div'] != 0:
            FullDiv = False
            break
    if FullDiv:
        Acum += int(s) 
        # ~ print(Acum, s)   

print('ANSWER: ', Acum)
