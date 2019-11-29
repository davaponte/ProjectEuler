#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000068.py
#

from constraint import *

problem = Problem()

for n in range(10):
    problem.addVariable('A' + str(n), [n for n in range(1, 11)])

problem.addConstraint(lambda A0, A1, A2, A3, A4: A0 + A1 + A2 == A3 + A2 + A4, ('A0', 'A1', 'A2', 'A3', 'A4'))
problem.addConstraint(lambda A3, A2, A4, A5, A6: A3 + A2 + A4 == A5 + A4 + A6, ('A3', 'A2', 'A4', 'A5', 'A6'))
problem.addConstraint(lambda A5, A4, A6, A7, A8: A5 + A4 + A6 == A7 + A6 + A8, ('A5', 'A4', 'A6', 'A7', 'A8'))
problem.addConstraint(lambda A7, A6, A8, A9, A1: A7 + A6 + A8 == A9 + A8 + A1, ('A7', 'A6', 'A8', 'A9', 'A1'))
problem.addConstraint(lambda A9, A8, A1, A0, A2: A9 + A8 + A1 == A0 + A1 + A2, ('A9', 'A8', 'A1', 'A0', 'A2'))
problem.addConstraint(lambda A0, A3, A5, A7, A9: A0 == 10 or A3 == 10 or A5 == 10 or A7 == 10 or A9 == 10,
        ('A0', 'A3', 'A5', 'A7', 'A9'))
problem.addConstraint(AllDifferentConstraint())

def GetDigitString(A):
# Esta función genera el digit string pedido, pero hay que comenzar desde el
# menor nodo exterior a construir el string, por eso la búsqueda inicial
    Order = [0, 1, 2, 3, 2, 4, 5, 4, 6, 7, 6, 8, 9, 8, 1]
    ExternalNodes = [A['A0'], A['A3'], A['A5'], A['A7'], A['A9']]
    idxk = [0, 3, 6, 9, 12]
    idx = ExternalNodes.index(min(ExternalNodes))
    k = idxk[idx]
    Order = Order[k:] + Order[:k]

    Acum = ''
    for d in Order:
        Acum += str(A['A' + str(d)])

    return Acum

Sol = problem.getSolutions()

Max = [GetDigitString(sol) for sol in Sol]

print('ANSWER: ', max(Max))
