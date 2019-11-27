#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000042.py
#  

def IsTriangleNumber(number):
    n = 1
    while True: 
        tn = n * (n + 1) // 2
        if (tn == number):
            return True
        elif (tn > number):
            return False
        n += 1

f = open('p042_words.txt')
lines= f.read()
f.close()
lines = lines.strip().split(",")
Count = 0
for line in lines:
    line = line.replace('"', '')
    Sum = sum((ord(x) - 64) for x in line)
    if IsTriangleNumber(Sum):
        Count += 1
        print(line, Sum)
    
print('ANSWER: ', Count)
