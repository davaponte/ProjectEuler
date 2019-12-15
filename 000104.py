# 000104.py

def Fib():
    f0 = 1
    yield f0
    f1 = 1
    yield f1
    while True:
        f0, f1 = f1, f1 + f0
        yield f1

# def IsPandigital(s):
#     l = list(s)
#     l.sort()
#     i = int(''.join(l))
#     return 123456789 == i

def IsPandigital(s):
    return set(s) == set('123456789')

rt5=5**.5
def check_first_digits(n):
    def mypow( x, n ):
        res=1.0
        for i in range(n):
            res *= x
            # truncation to avoid overflow:
            if res>1E20: res*=1E-10
        return res
    # this is an approximation for large n:
    F = mypow( (1+rt5)/2, n )/rt5
    s = '%f' % F
    if IsPandigital(s[:9]):
        print(n)
        return True

a, b, n = 1, 1, 1
while True:
    if IsPandigital( str(a)[-9:] ):
        # Only when last digits are
        # pandigital check the first digits:
        if check_first_digits(n):
            break
    a, b = b, a+b
    b=b%1000000000
    n += 1


# n = 0
# for f in Fib():
#     n += 1
#     if n < 329468: # 311434: # 272643: # 100583:
#         continue
#     s = str(f)
#     begin = IsPandigital(s[:9])
#     end = IsPandigital(s[-9:])
#     if begin:
#         print('F('+str(n)+') begin', 'Len: ', len(s))
#     if end:
#         print('F('+str(n)+') end', 'Len: ', len(s))
#     if begin and end:
#         print('ANSWER: ', n)
#         break
