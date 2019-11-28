#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000062.py
#

Tope = 12
Limits = [[n, round(pow(int('9' * n), 1/3))] for n in range(1, Tope+1)]
# print(Limits)

Cubes = {}
start = 0
Num2Find = 5
Found = False
for l, t in Limits:
    Cubes[l] = []
    for x in range(start, t):
        x3 = x**3
        s = str(x3)
        ls = list(s)
        ls.sort()
        s = ''.join(ls)
        Cubes[l].append([x, x3, s])
    for a in range(len(Cubes[l])-1):
        for b in range(a+1, len(Cubes[l])):
            if Cubes[l][a][2] > Cubes[l][b][2]:
                Cubes[l][a], Cubes[l][b] = Cubes[l][b], Cubes[l][a]

    print('Finding sequences...')
    for x in range(len(Cubes[l])-Num2Find+1):
        if all([Cubes[l][x][2] == Cubes[l][x+n][2] for n in range(Num2Find)]):
            Found = True
            Ans = []
            for t in range(Num2Find):
                Ans.append(Cubes[l][x+t][1])
                print(Cubes[l][x+t][0], Cubes[l][x+t][1])

            print('ANSWER: ', min(Ans))

            break
    start = t
    if Found:
        break
