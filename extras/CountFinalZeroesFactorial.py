
#
# https://nerdparadise.com/math/factorialzeros
#
N = 4096
print(sum(int(N // 5**n) for n in range(1, int(N**.5))))
