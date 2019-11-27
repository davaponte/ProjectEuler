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

def Collatz(Start):
    n = Start
    yield n
    while (n != 1):
        if (n % 2 == 0):
            n = n // 2
        else:
            n = 3 * n + 1
        yield n

def main(args):
    k = 1000000 - 1
    maxlength = 0
    maxk = 0
    while (k > 0):
        l = list(Collatz(k))
        length = len(l)
        if length > maxlength:
            maxlength = length
            maxk = k
        if (k % 200000 == 0):
            print(k, length, l)
        k -= 1
    print('ANSWER: ', maxk, ' LENGTH: ', maxlength)
    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))


