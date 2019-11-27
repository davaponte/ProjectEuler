#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000032.py
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

Dict = {}
for a in range(1, 2000):
    for b in range(1, 2000):
        c = a * b
        s = str(a) + str(b) + str(c)
        D = {}
        for i in s:
            D[i] = i
        if (len(s) == 9) and (len(D) == 9) and not (D.get('0')):
            Dict[c] = c
            print(D, a, b, c)

print(Dict)
print(sum(Dict[x] for x in Dict))

            
