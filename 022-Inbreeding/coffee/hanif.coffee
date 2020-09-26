class Calculator
	constructor : (@persons) ->

	add : (father=0,mother=0) => @persons.push [father,mother]

	findPaths : (acc, p) =>
		if p==0 then return []
		acc = acc.slice()
		acc.push p
		[father,mother] = @persons[p]
		[acc].concat(@findPaths acc, mother).concat(@findPaths acc, father)

	hasDuplicates : (arr) -> new Set(arr).size != arr.length

	findAncestorPaths : (a, b) ->
		result = []
		aPaths = @findPaths [], a
		bPaths = @findPaths [], b
		if aPaths.length > 1 and bPaths.length > 1
			for ipath in aPaths
				nodeToCheck = _.last ipath
				for jpath in bPaths 
					if nodeToCheck == _.last jpath
						aPath = ipath.slice 0,-1
						bPath = jpath.slice 0,-1
						if not @hasDuplicates aPath.concat bPath
							result.push aPath.length + jpath.length
		else
			if aPaths.length == 0 or bPaths.length > aPaths.length
				nodeToCheck = a
				paths = bPaths
			else
				nodeToCheck = b
				paths = aPaths
			for path in paths
				if nodeToCheck == _.last path then result.push path.length
		result

	cell : (a, b) -> # a,b integers
		paths = @findAncestorPaths a, b
		paths.reduce ((total,n) -> total + Math.pow 2, 1-n),0

#################

tree = new Calculator [[0,0],[0,0],[1,0],[1,0],[1,0],[3,2],[3,4],[5,6]]

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

assert 1/4,  tree.cell 2,3
assert 1/4,  tree.cell 3,4
assert 7/16, tree.cell 5,6

for i in range 1,7
	for j in range 1,7
		if i!=j then assert facit[i][j], tree.cell i,j

#################

tree = new Calculator [[0,0],[0,0],[0,0],[1,2],[1,2],[3,4],[3,4],[5,6],[5,6],[7,8],[7,8],[9,10],[9,10]]
assert 0,       tree.cell 1,2
assert 0.5,     tree.cell 3,4
assert 0.75,    tree.cell 5,6
assert 0.875,   tree.cell 7,8
assert 0.9375,  tree.cell 9,10
assert 0.96875, tree.cell 11,12
