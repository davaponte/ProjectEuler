#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000019.py
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

NumberNames = {
        1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five', 6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten',
        11: 'eleven', 12: 'twelve', 13: 'thirteen', 14: 'fourteen', 15: 'fifteen', 16: 'sixteen', 17: 'seventeen', 18: 'eighteen',  19: 'nineteen', 
        20: 'twenty', 30: 'thirty', 40: 'forty', 50: 'fifty', 60: 'sixty', 70: 'seventy', 80: 'eighty', 90: 'ninety', 
        100: 'one-hundred',
        1000: 'one-thousand'
    }

def main(args):
    m = 0
    c = 0
    d = 0
    u = 0
    for i in range(1, 1001):
        k = divmod(i, 1000)
        m = k[0]
        k = divmod(k[1], 100)
        c = k[0]
        k = divmod(k[1], 10)
        d = k[0]
        u = k[1]
        # ~ print(i, ' - ',  m, c, d, u, ' - ', m * 1000 + c * 100 + d * 10 + u)
                    
        if not NumberNames.get(i):
            HundredPrefix = ''
            if (i > 99):
                HundredPrefix = NumberNames[c] + ' hundred'
                if (d > 0) or (u > 0):
                    HundredPrefix += ' and ' 

            DecadesPrefix = ''
            if (d > 1):
                DecadesPrefix = NumberNames[d * 10]
                if (u > 0):
                    DecadesPrefix += '-'

            UnitsValue = ''
            if (u != 0):
                UnitsValue = NumberNames[u]
            if (u + d * 10 < 20) and (u + d * 10 > 0):
                UnitsValue = NumberNames[u + d * 10]
            
            k = HundredPrefix + DecadesPrefix + UnitsValue
            # ~ print(i, c, d, u, c * 100 + d * 10 + u, k)
            NumberNames[i] = k
            
        else:
            # ~ print(i, NumberNames[i], ' EXIST')
            pass
            
    NumberNames[0] = 'zero'
    Suma = 0
    for i in range(1, 1001):
        k = NumberNames[i]
        k = k.replace(' ', '')
        k = k.replace('-', '')
        Suma = Suma + len(k)
        # ~ print(i, NumberNames[i], len(k), k, Suma)
        
    print('ANSWER: ', Suma)
    return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
