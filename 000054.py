#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000054.py
#

f = open('p054_poker.txt')
lines = f.readlines()
p1 = []
p2 = []
for line in lines:
    p1.append(list(card for card in line[:14].split()))
    p2.append(list(card for card in line[15:29].split()))
f.close()

print(p1, p1)
