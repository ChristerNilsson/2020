import time

def execute():
	primes = []
	a = 100000000
	limit = 10001
	r = list(range(3,limit,2))

	for j in range(a+1,a+10000,2):
		prime = True
		for k in r:
			if j % k == 0:
				prime = False
				break
		if prime: primes.append(j)

	print(len(primes))

start = time.time()
execute()
print(time.time()-start)
