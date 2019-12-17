#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000113.py
#

def IsBouncy(n):
    s = str(n)
    Inc, Dec = True, True
    for i in range(len(s) - 1):
        Inc = Inc and (s[i] <= s[i+1])
        Dec = Dec and (s[i] >= s[i+1])
        if not Inc and not Dec:
            return True
    return False

B = 0
n = 99
Googol = 10**100
while (n < Googol):
    n += 1
    if IsBouncy(n):
        B += 1
    if (n % 1000000 == 0):
        print(n)

print('ANSWER: ', B)
