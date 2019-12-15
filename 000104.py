# 000104.py

def Fib():
    f0 = 1
    yield f0
    f1 = 1
    yield f1
    while True:
        f0, f1 = f1, f1 + f0
        yield f1

def IsPandigital(s):
    l = list(s)
    l.sort()
    i = int(''.join(l))
    return 123456789 == i

n = 0
for f in Fib():
    n += 1
    if n < 329468: # 311434: # 272643: # 100583:
        continue
    s = str(f)
    begin = IsPandigital(s[:9])
    end = IsPandigital(s[-9:])
    if begin:
        print('F('+str(n)+') begin', 'Len: ', len(s))
    if end:
        print('F('+str(n)+') end', 'Len: ', len(s))
    if begin and end:
        print('ANSWER: ', n)
        break
