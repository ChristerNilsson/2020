range = (b) -> [0...b] 
boxIndex = (j,k) -> Math.floor(j/3) * 3 + Math.floor(k/3) 
rowf = (i) -> Math.floor i/9
colf = (i) -> i%9

execute = (s) ->
	result = []

	pos = Array(81).fill 0
	row = Array(81).fill 0
	col = Array(81).fill 0
	box = Array(81).fill 0
	c = 0

	for j in range 81
		k = j % 9
		d = s[j] - '1'
		if d == -1 then continue
		x = boxIndex rowf(j),k

		pos[k + 9*rowf j] = 1 + d
		row[d + 9*rowf j] = 1 + k
		col[d + 9*k] = 1 + colf j
		box[d + 9*x] = 1 + colf j

		c++
	result.push "| #{c} clues"
	result.push "| " + s

	s = ''
	for i in range 81
		if !pos[i] then s += "p#{rowf i}#{colf i} "
	for i in range 81
		if !row[i] then s += "r#{rowf i}#{1 + colf i} "
	for i in range 81
		if !col[i] then s += "c#{rowf i}#{1 + colf i} "
	for i in range 81
		if !box[i] then s += "b#{rowf i}#{1 + colf i} "
	result.push s

	for j in range 9
		for k in range 9
			if !pos[9*j+k]
				x = boxIndex j,k
				for d in range 9
					if row[9*j+d] + col[9*k+d] + box[9*x+d] == 0
						result.push "#{'abcdefghi'[j]}#{k+1}#{d+1} p#{j}#{k} r#{j}#{d+1} c#{k}#{d+1} b#{x}#{d+1}"
	result

#if process.argv.length == 3
#	console.log execute process.argv[2]
#else
#	console.log execute '010005060004900070000003008070006300030009020006048090300500000090004500060200080'

module.exports = {execute}
