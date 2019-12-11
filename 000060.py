#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000060.py
#

from itertools import combinations as c, permutations as p

def IsPrime(n):
    for x in range(2, int(n**.5)+1):
        if n % x == 0:
            return False
    return n>1

BigPrimes = [x for x in range(100000) if IsPrime(x)]

n = 3
Primes = []
while True:
    if n in BigPrimes:
        Primes.append(n)
    n += 1
    if (n > 20000):
        break
print('Primes list created.', 'Num. items: ', len(Primes), 'Max prime: ', Primes[len(Primes) - 1])

def Len(N):
  Res = 0;
  while (N != 0):
    Res += 1
    N //= 10
  return Res + (Res == 0)

def AddPrimes(a, b):
    for _ in range(1, Len(b) + 1):
        a *= 10
    return a + b

def IsValid(a, b):
    if Len(a) + Len(b) > 5:
        return IsPrime(AddPrimes(a, b)) and IsPrime(AddPrimes(b, a))
    else:
        return (AddPrimes(a, b) in BigPrimes) and (AddPrimes(b, a) in BigPrimes)

Pairs = {}
Triplets = {}
Quartets = {}
Fiftets = {}
for a in Primes:
    for b in Primes:
        if a >= b:
            continue
        if IsValid(a, b):
            # Pairs[str(a) + ' '  + str(b)] = [a, b]
            for c in Primes:
                if (a >= c) or (b >= c):
                    continue
                if IsValid(a, c) and IsValid(b, c):
                    # Triplets[str(a) + ' '  + str(b) + ' ' + str(c)] = [a, b, c]
                    for d in Primes:
                        if (a >= d) or (b >= d) or (c >= d):
                            continue
                        if IsValid(a, d) and IsValid(b, d) and IsValid(c, d):
                            # Quartets[str(a) + ' '  + str(b) + ' ' + str(c) + ' ' + str(d)] = [a, b, c, d]
                            for e in Primes:
                                if (a >= e) or (b >= e) or (c >= e) or (d >= e):
                                    continue
                                if IsValid(a, e) and IsValid(b, e) and IsValid(c, e) and IsValid(d, e):
                                    Fiftets[str(a) + ' '  + str(b) + ' ' + str(c) + ' ' + str(d) + ' ' + str(e)] = [a, b, c, d, e]
                                    print('Items: ', [a, b, c, d, e], 'Sum: ', sum([a, b, c, d, e]))


# print('Pairs dict created.', 'Num. items: ', len(Pairs))
# print('Triplets dict created.', 'Num. items: ', len(Triplets))
# print('Quartets dict created.', 'Num. items: ', len(Quartets))
print('Fiftets dict created.', 'Num. items: ', len(Fiftets))
print(Fiftets)

Candidatos = [[l, sum(Fiftets[l])] for l in Fiftets]
if Candidatos:
    print('ANSWER: ', min(Candidatos, key=lambda x:x[1]))
else:
    print('Nothing found.')

import sys
sys.exit()

Found = False
for Q0 in range(0, len(ValidPrimes) - 4):
    if Found:
        break
    p0 = ValidPrimes[Q0]
    for Q1 in range(Q0 + 1, len(ValidPrimes) - 3):
        if Found:
            break
        p1 = ValidPrimes[Q1]
        if not IsValid(p0, p1):
            continue
        for Q2 in range(Q1 + 1, len(ValidPrimes) - 2):
            if Found:
                break
            p2 = ValidPrimes[Q2]
            if not IsValid(p0, p2) or not IsValid(p1, p2):
                continue
            for Q3 in range(Q2 + 1, len(ValidPrimes) - 1):
                if Found:
                    break
                p3 = ValidPrimes[Q3]
                if not IsValid(p0, p3) or not IsValid(p1, p3) or not IsValid(p2, p3):
                    continue
                for Q4 in range(Q3 + 1, len(ValidPrimes)):
                    if Found:
                        break
                    p4 = ValidPrimes[Q4]
                    if not IsValid(p0, p4) or not IsValid(p1, p4) or not IsValid(p2, p4) or not IsValid(p3, p4):
                        continue
                    print(p0, p1, p2, p3)
                    print('ANSWER: ', sum([p0, p1, p2, p3]))
                    Found = True
                    break

# for p0 in range(0, len(ValidPrimes) - 5):
#     if Found:
#         continue
#     for p1 in range(p0 + 1, len(ValidPrimes) - 4):
#         if Found:
#             continue
#         if not IsValid(p0, p1):
#             continue
#         for p2 in range(p1 + 1, len(ValidPrimes) - 3):
#             if Found:
#                 continue
#             if not IsValid(p0, p2) or not IsValid(p1, p2):
#                 continue
#             for p3 in range(p2 + 1, len(ValidPrimes) - 2):
#                 if Found:
#                     continue
#                 if not IsValid(p0, p3) or not IsValid(p1, p3) or not IsValid(p2, p3):
#                     continue
#                 for p4 in range(p3 + 1, len(ValidPrimes) - 1):
#                     if not IsValid(p0, p4) or not IsValid(p1, p4) or not IsValid(p2, p4) or not IsValid(p3, p4):
#                         continue
#                     print(p0, p1, p2, p3, p4)
#                     print('ANSWER: ', sum([p0, p1, p2, p3, p4]))
#                     Found = True
#                     break


# L = ValidPrimes
#
# P = c(L, 5)
#
# t = 0
# for k in P:
#     t += 1
#
#     if t % 1000000 == 0:
#         print(k)
#
#     kk = p(k, 2)
#
#     kkk = []
#     for c in kk:
#         N = int(str(c[0])+str(c[1]))
#         if not IsPrime(N):
#             kkk = []
#             break
#         else:
#             kkk.append(N)
#
#     if kkk:
#         print('Found!')
#         print(kkk, k)
#         print('ANSWER: ', sum(n for n in k))
#         break
