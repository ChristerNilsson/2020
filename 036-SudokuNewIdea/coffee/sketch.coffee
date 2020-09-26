BLOCK     = Array(81).fill 0
BLOCK_NDX = Array(81).fill 0
N_BIT     = Array(81).fill 0
ZERO      = Array(512).fill 0
BIT       = Array(512).fill 0

solveCount = 0

range = (n) -> [0...n]

pretty = (m) ->
	r.join ' ' for r in m

construct = -> # initialization of lookup tables 

	for x in range 0x200
		N_BIT[x] = range(9).reduce ((s,n) -> s + (x >> n & 1)), 0
		ZERO[x] = ~x & -~x
	for x in range 9
		BIT[1 << x] = x

	for y in range 9
		for x in range 9
			ptr = 9 * y + x
			BLOCK[ptr] = (y / 3 | 0) * 3 + (x / 3 | 0)
			BLOCK_NDX[ptr] = (y % 3) * 3 + x % 3

	# console.log "N_BIT #{N_BIT} #{N_BIT.length}"
	# console.log "ZERO #{ZERO} #{ZERO.length}"
	# console.log "BIT #{BIT} #{BIT.length}"
	#console.log "BLOCK #{BLOCK} #{BLOCK.length}"
	#console.log "BLOCK_NDX #{BLOCK_NDX} #{BLOCK_NDX.length}"

transform = (p) ->
	arr = (parseInt(ch) for ch in p).reverse()
	result = []
	for i in range 9
		result.push arr.slice 9*i,9*i+9
	result

calc = (m) ->
	row = Array(9).fill 0
	col = Array(9).fill 0
	blk = Array(9).fill 0
	for y in range 9
		for x in range 9
			index = 9 * y + x
			v = m[y][x]-1
			if v >= 0
				msk = 1 << v
				col[x] |= msk
				row[y] |= msk
				blk[BLOCK[index]] |= msk
	[row,col,blk]

fetchCandidates = (lst) ->
	candidates = []
	makeCandidates = (lst, selected=[]) ->
		if selected.length == 9
			candidates.push selected.slice()
			return
		for digit in lst[selected.length]
			if digit not in selected
				selected.push digit
				makeCandidates lst, selected, candidates
				selected.pop()
	makeCandidates lst
	candidates

makeList = (row, col, blk, m, y) ->
	result = []
	for x in range 9
		index = 9 * y + x
		pattern = row[y] | col[x] | blk[BLOCK[index]]
		#console.log pattern
		res = []
		if m[y][x] == 0
			for k in range 9
				msk = 1 << k
				if (msk & pattern) == 0 then res.push k+1
		else
			res.push m[y][x]
		if res.length == 0 then return []
		result.push res
	result

compact = (m,y) ->
	result = ''
	for i in range y
		result += ' ' + m[i].join ''
	result

short = (m) ->
	result = ''
	for r in m
		result += ' ' + r.join ''
	result

construct()

solve = (m, y=0) ->
	solveCount++
	#if y==0 then console.log pretty m
	#console.log compact m,y # + '   '.repeat(y) + y
	if y==9
		console.log pretty m
		return true
	[row, col, blk] = calc m
	#for i in range 9
	#	console.log "#{short makeList row,col,blk,m,i}" # [[1,3,6,9],[2],[1,3,6,9],[4,8,9],[5],[4,6,9],[7],[3,4,8,9],[1,4,8,9]]
	result = makeList row,col,blk,m,y # [[1,3,6,9],[2],[1,3,6,9],[4,8,9],[5],[4,6,9],[7],[3,4,8,9],[1,4,8,9]]
	if result.length == 0 then return false 
	cands = fetchCandidates result # lista med möjliga rader, t ex 38 kandidater
	console.log cands.length,'*'.repeat cands.length
	#if cands.length > 0 
	m1 = m.slice()
	for c in cands #  t ex [9,2,6,8,5,4,7,3,1] 
		m1[y] = c
		if solve m1,y+1 then return true
	false

#console.log mm.join ''

# filename = 'all_17'
# fs = require 'fs'
# puzzles = fs.readFileSync(filename).toString().split '\n'
# len = puzzles.shift()

#for puzzle in puzzles                                                                              reverse
#puzzle = '000000010400000000020000000000050407008000300001090000300400200050100000000806000' #  20 ms # 35345  11.5s #2029753
#puzzle = '002000700010000060500000018000037000000049000004102300003020900080000050600000002' #  90 ms # 17355  602ms #  66750
#puzzle = '002000700010000060500000018003020900080000050600000002000037000000049000004102300' # 965 ms #169930  86ms  #  15624
puzzle = '020050700400100006800003000200008003040020500000600010002090000090000005704000900' #  63 ms #  9625  230us #     21
#console.log puzzle

console.time 'CPU'
for i in range 1
	solveCount = 0
	solve transform puzzle
console.timeEnd 'CPU'
console.log solveCount
