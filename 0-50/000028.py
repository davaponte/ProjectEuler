#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000028.py
#  
#  Copyright 2019 data <data@ASUS-LAPTOP>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

MaxC = 1001
MaxR = 1001

Matrix = [[0 for c in range(MaxC)] for r in range(MaxR)]

co, ro = MaxC // 2, MaxR // 2
c, r = co, ro
Dir = ((0, 1), (1, 0), (0, -1), (-1, 0))
do = Dir[0]
k = 1
Maxk = MaxR * MaxC
while (k <= Maxk):
    Matrix[r][c] = k
    r += do[0]
    c += do[1]
    k += 1
    if (r == c) or ((MaxR - r - 1 == c) and (c < co)) or ((MaxR - r == c) and (c > co)):
        if (do == Dir[0]):
            do = Dir[1]
        elif (do == Dir[1]):
            do = Dir[2]
        elif (do == Dir[2]):
            do = Dir[3]
        elif (do == Dir[3]):
            do = Dir[0]

# ~ for r in range(MaxR):
    # ~ for c in range(MaxC):
        # ~ print('{0:^3}'.format(Matrix[r][c]), end=' ' )
    # ~ print()
        
Suma = -Matrix[ro][co]
for r in range(MaxR):
    Suma += Matrix[r][r]
    Suma += Matrix[MaxR - r - 1][r]

print('ANSWER: ', Suma)
