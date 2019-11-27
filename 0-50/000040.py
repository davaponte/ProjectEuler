#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000040.py
#  

n = 1
s = ' '
while True:
    s += str(n)
    n += 1
    if (len(s) > 1000000):
        break

print('ANSWER: ', int(s[1]) * int(s[10]) * int(s[100]) * int(s[1000]) * int(s[10000]) * int(s[100000]) * int(s[1000000]))
