#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000031.py
#  

# 1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).

Tope = 200
Ways = 0
for p1 in range(Tope + 1):
    for p2 in range(0, Tope + 1, 2):
        for p5 in range(0, Tope + 1, 5):
            for p10 in range(0, Tope + 1, 10):
                for p20 in range(0, Tope + 1, 20):
                    for p50 in range(0, Tope + 1, 50):
                        for p100 in range(0, Tope + 1, 100):
                            for p200 in range(0, Tope + 1, 200):
                                # ~ print(p1, p2, p5, p10, p20, p50, p100, p200)
                                Suma = p1 + p2 + p5 + p10 + p20 + p50 + p100 + p200
                                if (Suma == 200):
                                    Ways += 1
print('ANSWER: ', Ways)

# ~ ANSWER:  73682
# ~ PERO DEMORÓ UNA HORA!!!
# ~ INACEPTABLE!!!
