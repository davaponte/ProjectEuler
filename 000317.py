#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000317.py
#

from math import pi, sin, cos, sqrt

def Cos(Angle):
    return cos(Angle * pi / 180)

def Sin(Angle):
    return sin(Angle * pi / 180)

vo = 20
H = 100
g = 9.81

h1 = vo**2 / (2 * g)

# Hay que refinar la distancia pues, como no parte de H = 0 no se vale A = 45 para máximo
MaxA = 0
Maxd = 0
for A in range(91):
    d = (vo * Cos(A) / g) * (vo * Sin(A) + sqrt(pow(vo * Sin(A), 2) + 2 * g * H))
    if (d > Maxd):
        MaxA = A
        Maxd = d

d = Maxd
A = MaxA - 1
OrgMax = MaxA
while (A < MaxA + 1):
    d = (vo * Cos(A) / g) * (vo * Sin(A) + sqrt(pow(vo * Sin(A), 2) + 2 * g * H))
    if (d > Maxd):
        MaxA = A
        Maxd = d
    A = A + 0.00001 # Puede ser menos, pero por precisión así está bien

d = Maxd
# print(MaxA, d)

V = (pi / 2) * d**2 * (H + h1)

print('ANSWER: %.4f m³' % V)

# #Project Euler Problem 317
#
# from math import pi
# v, h, g = 20, 100, 9.81
#
# print "Volume of region: %.4f m^3" % (pi*(2*g*v*h + v*v*v)**2 / (4*g*g*g))
# Volume of region: 1856532.8455 m^3
