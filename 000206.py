#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000206.py
#
N = '1_2_3_4_5_6_7_8_9_0'
     # 1929394959697989990
     # 1020304050607080900
Max = 1389026624 # 1389026623.1062636
Min = 1010101010 # 1010101010.1010101

for n in range(Min, Max):
    Sqr = n**2
    s = list(str(Sqr))
    for x in range(9):
        s[2*x+1] = '_'
    s = ''.join(s)
    # print(s)
    if s == N:
        print('ANSWER: ', n)

# from itertools import permutations as p
#
# Opt = [x for x in range(10)]
#
# P = list(p(Opt, 9))
# print(P)
# for l in P:
#     for x in range(9):
#         V = int(N.replace(str(x+1) + '_', str(x+1) + str(l[x])))
#         Sqrt = V**.5
#         print(N, V, Sqrt)
#         if Sqrt == int(Sqrt):
#             print('ANSWER: ', V)
