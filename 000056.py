#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000056.py
#

L = [str(a**b) for a in range(1, 100) for b in range(1, 100)]

print('ANSWER: ', max([sum(int(c) for c in x) for x in L]))
