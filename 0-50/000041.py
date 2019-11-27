#!/usr/bin/env python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  untitled.py
#  

import math
from itertools import permutations as p

def IsPrime(n):
    for k in range(2, int(math.sqrt(n)) + 1):
        if n % k == 0:
            return False
    return True

Ans = 0
for k in range(9, 2, -1):
    l = [(x + 1) for x in range(k)]
    P = p(l)
    ll = list(P)
    ll.sort(reverse=True)
    # ~ print(ll)
    # ~ print(len(ll))
    for i in ll:
        s = str(i).replace('(', '').replace(')', '').replace(', ', '')
        # ~ print(s, IsPrime(int(s)))
        if IsPrime(int(s)):
            Ans = int(s)
            break 
    if Ans > 0:
        break
               
print('ANSWER: ', Ans)
