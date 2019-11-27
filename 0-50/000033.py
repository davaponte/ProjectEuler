#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000033.py
#  


def Dividers(n):
    for k in range(1, n + 1 if n in [2, 3] else n):
        if (n % k == 0) and (k !=  1):
            yield k

MulAcumDen = 1
MulAcumNum = 1
MulDen = 1
MulNum = 1
for N in range(1, 100):
    for D in range(1, 100):

        Na = N // 10
        Nb = N % 10

        Da = D // 10
        Db = D % 10

        if (Nb == 0) and (Db == 0):
            continue

        if (N >= D):
            continue

        N_ = None
        D_ = None

        if (Db == 0):
            continue
        if (Na == Da) and (N / D == Nb / Db):
            N_ = Nb
            D_ = Db

        if (Nb == Da) and (N / D == Na / Db):
            N_ = Na
            D_ = Db

        if (Da == 0):
            continue
        if (Na == Db) and (N / D == Nb / Da):
            N_ = Nb
            D_ = Da

        if (Nb == Db) and (N / D == Na / Da):
            N_ = Na
            D_ = Da
            
        if N_ and D_:
            print('N: ', N, ', ', str(Na) + str(Nb))
            print('D: ', D, ', ', str(Da) + str(Db))
            print(str(N) + '/' + str(D), N / D, ' == ', str(N_) + '/' + str(D_), N_ / D_)
            MulAcumNum *= N
            MulAcumDen *= D
            
            NN = N
            DD = D
            while True:
                Ndiv = list(Dividers(NN))
                Ddiv = list(Dividers(DD))
                if (len(Ndiv) == 0) or (len(Ddiv) == 0):
                    print('len: ', len(Ndiv), len(Ddiv))
                    break
                print(Ndiv, Ddiv)
                l = Ddiv.copy()
                l.reverse()
                for k in l:
                    if k in Ndiv:
                        NN //= k
                        DD //= k
                        print('news: ', NN, DD)
                        break
            
            print('PARTIAL ANSWER: ', str(NN) + '/' + str(DD))
            MulDen *= DD
            MulNum *= NN
            
print('ALMOST FINAL ANSWER: ', MulNum, MulDen, MulNum / MulDen, MulAcumNum, MulAcumDen)
NN = MulAcumNum
DD = MulAcumDen
while True:
    Ndiv = list(Dividers(NN))
    Ddiv = list(Dividers(DD))
    print(Ndiv, Ddiv)
    if (len(Ndiv) == 0) or (len(Ddiv) == 0):
        print('len: ', len(Ndiv), len(Ddiv))
        break
    print(Ndiv, Ddiv)
    l = Ddiv.copy()
    l.reverse()
    for k in l:
        if k in Ndiv:
            NN //= k
            DD //= k
            print('news: ', NN, DD)
            break

print('FINAL ANSWER: ', DD)
    

