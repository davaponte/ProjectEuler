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

def IsMultipleOf(Number, Divisor):
    return Number % Divisor == 0

def main(args):
    k = 0
    acum = 0
    for i in range(1, 1000):
        if IsMultipleOf(i, 3) or IsMultipleOf(i, 5):
            k += 1
            acum += i
        print(i, IsMultipleOf(i, 3) or IsMultipleOf(i, 5))
    print(k, ', ', acum)
    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
