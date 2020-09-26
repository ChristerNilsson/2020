# http://www.husdyr.kvl.dk/htm/kc/popgen/genetics/4/5.htm

class Calculator
	constructor : (@persons=[]) -> @calc()
	add : (sire=0,dame=0) -> @persons.push {sire,dame}
	calc : () ->
		n = @persons.length
		@matrix = (0 for i in range n for j in range n)
		for i in range 1,n
			@matrix[i][i] = 1
			for j in range i+1,n
				[sire,dame] = @persons[j]
				@matrix[i][j] = @matrix[j][i] = (@matrix[i][sire] + @matrix[i][dame]) / 2
			[sire,dame] = @persons[i]
			@matrix[i][i] += @matrix[sire][dame] / 2
	cell : (i,j) -> @matrix[i][j]

################################

facit = [
	[0, 0,   0,    0,   0,    0,     0,     0]
	[0, 1,   1/2,  1/2, 1/2,  1/2,   1/2,   1/2]
	[0, 1/2, 1,    1/4, 1/4,  5/8,   1/4,   7/16]
	[0, 1/2, 1/4,  1,   1/4,  5/8,   5/8,   5/8]
	[0, 1/2, 1/4,  1/4, 1,    1/4,   5/8,   7/16]
	[0, 1/2, 5/8,  5/8, 1/4,  1+1/8, 7/16,  25/32]
	[0, 1/2, 1/4,  5/8, 5/8,  7/16,  1+1/8, 25/32]
	[0, 1/2, 7/16, 5/8, 7/16, 25/32, 25/32, 1+7/32]
]

tree = new Calculator [[0,0],[0,0],[1,0],[1,0],[1,0],[3,2],[3,4],[5,6]]

N = tree.matrix.length
for i in range 1,N-1
	for j in range 1,N-1
		assert facit[i][j], tree.cell i,j

assert 1/4,  tree.cell 3,2
assert 1/4,  tree.cell 3,4
assert 7/16, tree.cell 5,6

###############################

tree = new Calculator [[0,0],[0,0],[0,0],[1,2],[1,2],[3,4],[3,4],[5,6],[5,6],[7,8],[7,8],[9,10],[9,10]]
assert 0,     tree.cell 1,2
assert 1/2,   tree.cell 3,4
assert 3/4,   tree.cell 5,6
assert 7/8,   tree.cell 7,8
assert 15/16, tree.cell 9,10
assert 31/32, tree.cell 11,12
