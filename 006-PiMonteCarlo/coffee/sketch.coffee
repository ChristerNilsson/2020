f = (radius) ->
	r1 = radius+1
	lst = range radius
	count = 0
	for i in lst
		for j in lst
			if i*i+j*j <= radius*radius then count++
	4 * count/r1/r1

assert 3.091118800461361, f 50
assert 3.118517792373297, f 100
assert 3.1292294745179574, f 200
assert 3.1368161879833147, f 500
assert 3.1392623360655327, f 1000
assert 3.141362176151148, f 10000

# assert 3.14147797434887, f 20000
# assert 3.1415467528732663, f 50000
# PI = 3.1415926535
print 'Ready'
