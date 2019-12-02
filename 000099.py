#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000099.py
#

from math import log

f = open('p099_base_exp.txt')
lines=f.readlines()
Line = 0
MaxLine = 0
MaxValue = 0
for line in lines:
    Line += 1
    a,b = line.split(',')
    Value = int(b) * log(int(a))
    if Value > MaxValue:
        MaxValue = Value
        MaxLine = Line

print('ANSWER: ', MaxLine)
