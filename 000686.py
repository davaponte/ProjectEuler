#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000686.py
#

n = 12710
i = 44 # Uno menos adrede
p = 2**(n-1) # Uno menos adrede
Quit = False
while not Quit:
    p *= 2
    if (str(p)[:3] == '123'):
        i += 1
        print(i)
        if (i == 678910):
            print('ANSWER: ', n)
            Quit = True
            break
    n += 1
    # if (n % 10000 == 0):
    #     print(n)
