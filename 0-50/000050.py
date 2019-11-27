#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000050.py
#  

from math import sqrt

def IsPrime(n):
    for d in range(2, int(sqrt(n)) + 1):
        if (n % d == 0):
            return False
    return (n > 1)

limit = 1000000
l = [x for x in range(5000) if IsPrime(x)]

## El siguiente bloque fue solo para hallar la cota máxima de generación de primos
# ~ seq = 21 + 1
# ~ for k in range(len(l) - seq + 1, -1, -1):
    # ~ Slice = l[k:k + seq]
    # ~ Suma = sum(x for x in Slice)
    # ~ if (Suma < limit):
        # ~ break
    # ~ l.pop()
# ~ print(len(l), l)
# ~ k = 4918
# ~ Slice = l[k- seq:k]
# ~ print(l)
# ~ print(Slice)

for seq in range(1000, 22, -1):
    for k in range(len(l) - seq + 1):
        Slice = l[k:k + seq]
        # ~ print(Slice)
        Suma = sum(x for x in Slice)
        if (Suma < limit) and IsPrime(Suma):
            print('Primes: ', Slice)
            print('Length: ', len(Slice))
            print('ANSWER: ', Suma)
            break
    else:
        continue
    break


# ~ Length:  543
# ~ ANSWER:  997651
