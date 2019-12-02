#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000028.py
#

MaxC = 1001
MaxR = 1001

Matrix = [[0] * MaxC for r in range(MaxR)]

co, ro = MaxC // 2, MaxR // 2
c, r = co, ro
Dir = ((0, 1), (1, 0), (0, -1), (-1, 0))
do = Dir[0]
k = 1
Maxk = MaxR * MaxC
while (k <= Maxk):
    Matrix[r][c] = k
    r += do[0]
    c += do[1]
    k += 1
    if (r == c) or ((MaxR - r - 1 == c) and (c < co)) or ((MaxR - r == c) and (c > co)):

        idx = Dir.index(do)
        do = Dir[idx + 1] if (idx < len(Dir) - 1) else Dir[0]
        # if (do == Dir[0]):
        #     do = Dir[1]
        # elif (do == Dir[1]):
        #     do = Dir[2]
        # elif (do == Dir[2]):
        #     do = Dir[3]
        # else: # elif (do == Dir[3]):
        #     do = Dir[0]

Suma = sum(Matrix[r][r] + Matrix[MaxR - r - 1][r] for r in range(MaxR))
Suma -= Matrix[ro][co] # Porque el central se suma dos veces, hay que quitar uno

print('ANSWER: ', Suma)
