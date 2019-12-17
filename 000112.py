#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000112.py
#

def IsBouncy(n):
    s = str(n)
    Inc = True
    Dec = True
    for i in range(len(s) - 1):
        Inc = Inc and (s[i] <= s[i+1])
        Dec = Dec and (s[i] >= s[i+1])
    return not Inc and not Dec
    # if not Inc and not Dec:
    #     print('Bouncy: ', n)
    # elif Inc:
    #     print('Inc: ', n)
    # else:
    #     print('Dec: ', n)


B = 0
n = 99
while True:
    n += 1
    if IsBouncy(n):
        B += 1
        if B * 100 / n == 99.0:
            print('ANSWER: ', n)
            break


# IsNotBouncy(134468)
# IsNotBouncy(66420)
# IsNotBouncy(155349)
