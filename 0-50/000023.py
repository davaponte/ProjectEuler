#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000023.py
#  
from math import sqrt
import sys

# ~ def IsPrime(n):
    # ~ for d in range(2, int(sqrt(n)) + 1):
        # ~ if (n % d == 0):
            # ~ return False
    # ~ return (n > 1)

def Dividers(n):
    limit = n // 2
    for k in range(1, limit + 1):
        if (n % k == 0) and (n != k):
            yield k

Data = []
Top = 28123
print('Calculando divisores. Esto va a demorar un poquito...')
for i in range(1, Top + 1):
    Suma = sum(x for x in Dividers(i))#, i // 2 + 1))
    if (Suma > i):
        Data.append(i)
print('Listos!')

print('Buscando números que se puedan construir y los que no...')
Sumas = [0] * (Top + 1)
Suma = 0
for a in range(len(Data)):
    for b in range(a, len(Data)):
        Add = Data[a] + Data[b]
        if (Add <= Top):
            Sumas[Add] = 1

print('ANSWER: ', sum(x for x in range(len(Sumas)) if (Sumas[x] == 0)))


# ~ 4179871
