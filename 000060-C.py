#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000060-C.py
#

# Este no lo hice yo, aunque se parece a un intento que hice anoche.
# Esto obtiene la respuesta en 28 segundos!!!

N=10000
sqrtN=1+int(N**0.5)
C=[False]*N

def Eratosthenes():
    i=2
    while i<sqrtN:
        if not C[i]:
            j=i+i
            while j<N:
                C[j]=True
                j += i
        i += 1

Eratosthenes()
Prime=[ n for n in range(2,N) if not C[n] ]

def isPrime(n):
    if n==1:
        return False
    if n in Prime:
        return True
    if n % 6 not in (1,5):
        return False
    for p in Prime:
        if p*p>n:
            return True
        if n % p == 0:
            return False
    return True

def isPairOK(x,y):
    return isPrime(int(str(x)+str(y))) and isPrime(int(str(y)+str(x)))

P2={ p:set() for p in Prime }
S2=set()
for i in range(len(Prime)):
    for j in range(i+1,len(Prime)):
        if isPairOK(Prime[i],Prime[j]):
            P2[Prime[i]].add(Prime[j])
            P2[Prime[j]].add(Prime[i])
            S2.add((Prime[i],Prime[j]))

S3=set()
for (p,q) in S2:
    for r in P2[p]:
        if r in P2[q]:
            S3.add(tuple(sorted((p,q,r))))

S4=set()
for (p,q,r) in S3:
    for s in P2[p]:
        if s in P2[q] and s in P2[r]:
            S4.add(tuple(sorted((p,q,r,s))))

S5=set()
for (p,q,r,s) in S4:
    for t in P2[p]:
        if t in P2[q] and t in P2[r] and t in P2[s]:
            S5.add(tuple(sorted((p,q,r,s,t))))

print(S5)
print(list((s,"sum=",sum(s)) for s in S5))
