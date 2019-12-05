#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000055.py
#

def IsPalindrome(n):
    s = str(n)
    return all([s[x] == s[-x-1] for x in range(len(s) // 2)])

Counter = 0
for n in range(1, 10000):
    N = n
    NumIter = 0
    IsLychrel = True
    while True:
        a = str(N)
        b = ''.join([a[x] for x in range(len(a) - 1, -1, -1)])
        c = int(a) + int(b)
        # print(a, b, c)
        NumIter += 1
        if IsPalindrome(c):
            IsLychrel = False
            break
        if NumIter >= 50:
            break
        N = c

    if IsLychrel:
        Counter += 1

print('ANSWER :', Counter)
