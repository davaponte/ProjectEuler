#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000001.py
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

import math

def Dividers(n, limit):
    for k in range(2, limit + 1):
        if n % k == 0:
            yield k

def main(args):
    limit = 20
    ListToCheck = []
    for i in range(2, limit + 1):
        ListToCheck.append(i)
    k = 2520
    k = 21363166
    k = 232790000
    while True:
        Div = list(Dividers(k, limit))
        if (k % 10000 == 0):
            print(k, Div)
        if (Div == ListToCheck):
            print('Answer: ', k)
            print('Dividers: ', Div)
            break
        k += 1
    
    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
