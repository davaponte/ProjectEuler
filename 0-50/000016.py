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

raw_matrix = '''\
08 02 22 97 38 15 00 
40 00 75 04 05 07 78 
52 12 50 77 91 08 49 
49 99 40 17 81 18 57'''

matrix = [list(map(int, line.split())) for line in raw_matrix.split('\n')]


def main(args):
    for r in range(len(matrix)):
        for c in range(len(matrix[r])):
            print(matrix[r][c], end=' ')
        print('')
    
    print(sum(int(x) for x in str(pow(2, 1000))))
    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))

