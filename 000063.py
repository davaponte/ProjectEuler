#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000063.py
#


Tope = 100 + 1
N = [[a, b, a**b] for a in range(1, Tope) for b in range(1, Tope)]
# print(N)

print('ANSWER: ', sum(1 for a, b, p in N if (len(str(p)) == b)))
