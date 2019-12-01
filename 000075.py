#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000075.py
#

from constraint import *
from math import sqrt

problem = Problem()

Acum = 0
# for L in [12, 24, 30, 36, 40, 48, 120]:
for L in range(12, 200):

    problem.addVariable('a', [n for n in range(int(sqrt(L)), L // 2)])
    problem.addVariable('b', [n for n in range(int(sqrt(L)), L // 2)])
    # problem.addVariable('c', [n for n in range(1, L)])

    # problem.addConstraint(lambda a, b, c: a**2 + b**2 == c**2, ('a', 'b', 'c'))
    problem.addConstraint(lambda a, b: a + b + sqrt(a**2 + b**2) == L, ('a', 'b'))
    problem.addConstraint(lambda a, b: a >= b, ('a', 'b'))
    # problem.addConstraint(lambda a, b, c: a + b + c == L, ('a', 'b', 'c'))

    iter = problem.getSolutionIter()
    try:
        next(iter)  # Primera solución
        Acum += 1

        while True:
            try:
                next(iter)
                Acum -= 1
                break
            except:
                break
    except:
        pass
    problem.reset()

print(Acum)
