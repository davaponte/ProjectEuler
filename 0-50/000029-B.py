#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000029-B.py
#

# Variaciones del problema 29

import time

start = time.time()

Powers = {a**b: a**b for a in range(2, 101) for b in range(2, 101)}
l=len(Powers)
end = time.time()
print(end - start)
print('DICTIONARY ANSWER: ', l)

start = time.time()
t = [i**j for i in range(2, 101) for j in range(2, 101)]
l=len(set(t))
end = time.time()
print(end - start)
print('LIST & SET ANSWER: ', l)

start = time.time()
l=[]
for a in range(2,101):
    x = a
    for _ in range(2, 101):
        x *= a
        l.append(x)
L = len(set(l))
end = time.time()
print(end - start)
print('LIST & SET w/o POWERS ANSWER: ', L)

start = time.time()
l=set()
for a in range(2,101):
    x = a
    for _ in range(2, 101):
        x *= a
        l.add(x)
L = len(l)
end = time.time()
print(end - start)
print('USING ONLY SETS AND NO POWERS ANSWER: ', L)
