#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000049.py
#  

from itertools import permutations as p
from math import sqrt

def IsPrime(n):
    if (n == 1):
        return False
    for d in range(2, int(sqrt(n)) + 1):
        if (n % d == 0):
            return False
    return True

l = [x for x in range(0, 10)]

P = list(p(l, 4))
#print(len(P))

Dict = {}
c = 0
for k in P:
    s = str(k).replace('(', '').replace(')', '').replace(', ', '')
    if s[0] == '0':
        continue
    if IsPrime(int(s)):
        so = int(s)
        #print(so)
        l = list(s)
        l.sort()
        s = int(str(l).replace('[', '').replace(']', '').replace(', ', '').replace("'", ''))
        #print(s)
        if Dict.get(s):
            Dict[s]['c'] += 1
            Dict[s]['d']. append (so)
        else:
            Dict[s] = {}
            Dict[s]['c'] = 1
            Dict[s]['d'] = []
            Dict[s]['d'].append(so)
        c += 1
        
#print(c, ' primes found')
    
Dif = {}
    
for k in Dict:
    # ~ if (Dict[k]['c'] != 8):
        # ~ continue
    l = Dict[k]['d']
    Dif[k] = {'Value': Dict[k]}
    for a in l:
        for b in l:
            if (a == b):
                continue
            d = abs(a - b) # abs no es necesario pues viene ordenado
            if not Dif[k].get(d):
                Dif[k][d] = []
            if not a in Dif[k][d]:
                Dif[k][d].append(a)
            if not b in Dif[k][d]:
                Dif[k][d].append(b)
  
for k in Dif:
    print()
    for t in Dif[k]:
        # ~ if (len(Dif[k][t]) != 3):
            # ~ continue
        print(t, Dif[k][t])
    
