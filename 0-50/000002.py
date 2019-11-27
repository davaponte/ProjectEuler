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

def Fibonacci():
    f0, f1 = 1, 1
    while True:
        yield f0
        f0, f1 = f1, f0+f1
        
def FibGen(limit):
    f0, f1 = 1, 1
    while f0 <= limit:
        yield f0
        f0, f1 = f1, f0 + f1

def main(args):
    
    acum = 0
    for f in Fibonacci():
        if (f <= 4000000) and (f % 2 == 0):
            acum += f
        if (f > 4000000):
            break
    print('Answer: ', acum)

    print('Same answer: ', sum([x for x in FibGen(4000000) if x % 2 == 0]))        

    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
