#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000060-D.py
#

# Intento de Modificación del 000060-C.py con mis rutinas para no usar str()
# RESULTA QUE NO ES MEJORABLE!!! USAR srt() e int() ES MÁS RÁPIDO!!!

N = 10000
# SqrtN = 1 + int(N**.5)
# C = [False] * N
#
# def Eratosthenes():
#     i = 2
#     while i < SqrtN:
#         if not C[i]:
#             j = i + i
#             while j < N:
#                 C[j] = True
#                 j += i
#         i += 1

# Eratosthenes()
# Prime = [n for n in range(2, N) if not C[n]]

def IsPrime(n):
    for d in [2]+list(range(3, int(n**.5) + 1, 2)):
        if (n % d == 0):
            return False
    return (n > 1)
Prime = [2] + [n for n in range(2, N) if IsPrime(n)]

def isPrime(n):
    if n == 1:
        return False
    if n in Prime:
        return True
    if (n < N):
        return False
    # if n % 6 not in (1, 5):
    #     return False
    # s = str(n)
    # if int(s[-1]) == 5: # Divisibilidad por 5
    #     return False
    #
    # if (int(s[:-1]) - 2 * int(s[-1])) % 7 == 0: # Divisibilidad por 7
    #     return False
    #
    # # S = sum(int(s[i]) for i in range(0, len(s), 2))
    # # S = S - sum(int(s[i]) for i in range(1, len(s), 2))
    # # if (S % 11 == 0): # Divisibilidad por 11
    # if (int(s[:-1]) - int(s[-1])) % 11 == 0: # Divisibilidad por 11
    #     return False

    for p in Prime:
        if p * p > n:
            return True
        if n % p == 0:
            return False
    return True

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

def isPairOK(x, y):
    return isPrime(int(str(x) + str(y))) and isPrime(int(str(y) + str(x)))
    # return isPrime(AddPrimes(x, y)) and isPrime(AddPrimes(y, x))

P2 = {p: set() for p in Prime}
S2 = set()
for i in range(len(Prime)):
    for j in range(i + 1, len(Prime)):
        if isPairOK(Prime[i], Prime[j]):
            P2[Prime[i]].add(Prime[j])
            P2[Prime[j]].add(Prime[i])
            S2.add((Prime[i], Prime[j]))
# 18176 ítems

S3 = set()
for (p, q) in S2:
    for r in P2[p]:
        if r in P2[q]:
            S3.add(tuple(sorted((p, q, r))))
# 9904 ítems

S4 = set()
for (p, q, r) in S3:
    for s in P2[p]:
        if s in P2[q] and s in P2[r]:
            S4.add(tuple(sorted((p, q, r, s))))
# 294 ítems

S5 = set()
for (p, q, r, s) in S4:
    for t in P2[p]:
        if t in P2[q] and t in P2[r] and t in P2[s]:
            S5.add(tuple(sorted((p, q, r, s, t))))
# 1 ítem

print(S5)
print(list((s,'Sum: ', sum(s)) for s in S5))
