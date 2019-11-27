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

def IsPalindrome(n):
    s = str(n)
    k = -1
    for c in s[:len(s) // 2]:
        if c != s[k]: 
            return False
        k -= 1
    return True

def main(args):
    maxc = 0
    maxa = 0
    maxb = 0
    for a in range(100, 1000):
        for b in range(100, 1000):
            c = a * b
            if IsPalindrome(c) and (c > maxc):
                maxa = a
                maxb = b
                maxc = c
                
    print(maxc, maxa, maxb)
    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
