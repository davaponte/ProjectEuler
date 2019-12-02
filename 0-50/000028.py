#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000028.py
#

MaxC = 1001
MaxR = 1001

Matrix = [[0 for c in range(MaxC)] for r in range(MaxR)]

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
        if (do == Dir[0]):
            do = Dir[1]
        elif (do == Dir[1]):
            do = Dir[2]
        elif (do == Dir[2]):
            do = Dir[3]
        else: # elif (do == Dir[3]):
            do = Dir[0]

# ~ for r in range(MaxR):
    # ~ for c in range(MaxC):
        # ~ print('{0:^3}'.format(Matrix[r][c]), end=' ' )
    # ~ print()

Suma = -Matrix[ro][co]
for r in range(MaxR):
    Suma += Matrix[r][r] + Matrix[MaxR - r - 1][r]

print('ANSWER: ', Suma)
