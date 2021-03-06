# This code works, but I had to introduce a class to handle variable scopes in coffeescript
# This adds about 25% to the exec time.
# node js/sudoku tests/data/collections/all_17

TRACE = false

DCEL = false #true

BLOCK     = [] # 81 digits
BLOCK_NDX = [] # 81 digits
N_BIT     = [] # 512 integers
ZERO      = [] # 512 integers
BIT       = Array(512).fill 0 # 512 integers

count = 0
m = [] # 81 digits
col = [] # 9 bit patterns
row = [] # 9 bit patterns
blk = [] # 9 bit patternsnull

perf = {} 

output = []

range = (n) -> [0...n]

trace = (prompt,level,s) ->
	console.log prompt + ' '.repeat(level) + s
	output.push prompt + ' '.repeat(level) + s
	perf[prompt]++

showGrid = (prompt,m) ->
	counter = 0
	for digit in m
		if digit != -1 then counter++
	console.log prompt, m.map( (digit) => digit+1).join(''), counter

class Sudoku
	constructor : -> # initialization of lookup tables 

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

		console.log "BLOCK #{BLOCK.join("")}"
		console.log "BLOCK_NDX #{BLOCK_NDX.join("")}"
		console.log "N_BIT #{N_BIT.join("")}"
		console.log "ZERO #{ZERO.join("")}"
		console.log "BIT #{BIT.join("")}"

	# helper function to check and play a move
	play : (level, stack, x, y, n) ->
		p = y * 9 + x

		if ~m[p]
			if m[p] == n then return true
			@undo level,stack
			return false
		
		msk = 1 << n
		b = BLOCK[p]

		if (col[x] | row[y] | blk[b]) & msk
			@undo level,stack
			return false
		
		count--
		col[x] ^= msk
		row[y] ^= msk
		blk[b] ^= msk
		m[p] = n
		stack.push x << 8 | y << 4 | n

		if TRACE then trace 'play ',level, "#{81-count} #{x} #{y} #{n}"

		#showGrid 'm    ', m
		return true

	undo : (level,stack) -> # helper function to undo all moves on the stack
		# console.log 'undo', (item.toString(16) for item in stack)
		for v in stack.reverse()
			x = v >> 8
			y = v >> 4 & 15
			index = y * 9 + x
			b = BLOCK[index]

			if TRACE then trace 'undo ', level, "#{81-count} #{x} #{y} #{v & 15}"

			msk = 1 << (v & 15)

			count++
			col[x] ^= msk
			row[y] ^= msk
			blk[b] ^= msk
			m[index] = -1
			# showGrid 'u    ',m

	solve : (p) ->
		perf = {'play ':0, 'undo ':0, 'guess':0, 'ungue':0}
		count = 81
		row = Array(9).fill 0
		col = Array(9).fill 0
		blk = Array(9).fill 0
		m = Array(81).fill -1

		# convert the puzzle into our own format
		for y in range 9
			for x in range 9
				index = 9 * y + x
				ch = p[index]
				if ch=='.' then ch='0'
				if ~(digit = ch - 1)
					msk = 1 << digit
					col[x] |= msk
					row[y] |= msk
					blk[BLOCK[index]] |= msk
					count--
					m[index] = digit

		xres = @search()
		return if xres then m.map((n) => n + 1).join('') else false

	search : (level=0) -> # main recursive search function
		if !count then return true

		# Local variables
		max = 0
		best = null
		stack = []
		dCol = Array(81).fill 0
		dRow = Array(81).fill 0
		dBlk = Array(81).fill 0
		if DCEL then dCel = Array(81).fill 0 # saves 10% of exec time

		# scan the grid:
		# - keeping track of where each digit can go on a given column, row or block
		# - looking for a cell with the fewest number of legal moves
		for y in range 9
			for x in range 9
				ptr = 9 * y + x
				if m[ptr] == -1
					v = col[x] | row[y] | blk[BLOCK[ptr]]
					n = N_BIT[v]
					#abort if there's no legal move on this cell
					if n == 9 then return false
					
					# update dCol[], dRow[] and dBlk[]
					v0 = v ^ 0x1FF
					while true
						b = v0 & -v0
						dCol[x * 9 + BIT[b]] |= 1 << y
						dRow[y * 9 + BIT[b]] |= 1 << x
						dBlk[BLOCK[ptr] * 9 + BIT[b]] |= 1 << BLOCK_NDX[ptr]
						v0 ^= b
						if !v0 then break 
					if DCEL then dCel[ptr] = v
					#console.log 'v0', v0
					
					# update the cell with the fewest number of moves
					if DCEL
						if n > max and n != 1
							best = {x: x, y: y, ptr: ptr, msk: v}
							max = n
					else
						if n > max
							best = {x: x, y: y, ptr: ptr, msk: v}
							max = n
				#ptr++
		#console.log('best',best,max)

		# play all forced moves (unique candidates on a given column, row or block)
		# and make sure that it doesn't lead to any inconsistency
		for k in range 9
			for n in range 9
				ptr = k * 9 + n
				if N_BIT[dCol[ptr]] == 1
					i = BIT[dCol[ptr]]
					if !@play(level,stack, k, i, n) then return false

				if N_BIT[dRow[ptr]] == 1
					i = BIT[dRow[ptr]];
					if !@play(level,stack, i, k, n) then return false

				if N_BIT[dBlk[ptr]] == 1
					i = BIT[dBlk[ptr]]
					if !@play(level,stack, (k % 3) * 3 + i % 3, (k / 3 | 0) * 3 + (i / 3 | 0), n) then return false

				if DCEL 
					if N_BIT[dCel[ptr]] == 8
						i = BIT[ZERO[dCel[ptr]]]
						if !@play(level,stack, n, k, i) then return false

		# if we've played at least one forced move, do a recursive call right away
		if stack.length
			if @search level+1 then return true
			@undo level,stack
			return false

		#console.log 'best', best.msk.toString(16), N_BIT[best.msk]

		# otherwise, try all moves on the cell with the fewest number of moves
		while (msk = ZERO[best.msk]) < 0x200
			col[best.x] ^= msk
			row[best.y] ^= msk
			blk[BLOCK[best.ptr]] ^= msk
			m[best.ptr] = BIT[msk]
			count--

			#showGrid('mm   ',m)
			#console.log('stack',stack.map((item) => item.toString(16)))

			if TRACE then trace 'guess', level, "#{81-count} #{best.x} #{best.y} #{BIT[msk]}"
			if @search level+1 then return true
			if TRACE then trace 'ungue', level, "#{81-count} #{best.x} #{best.y} #{BIT[msk]}" 
			
			count++
			m[best.ptr] = -1
			col[best.x] ^= msk
			row[best.y] ^= msk
			blk[BLOCK[best.ptr]] ^= msk

			best.msk ^= msk
		
		return false

fs = require 'fs'

sudoku = new Sudoku()

filename = process.argv[2]
puzzles = fs.readFileSync(filename).toString().split '\n'
len = puzzles.shift()
console.log len
output = [] #len + '\n'

console.log "File '" + filename + "': " + len + " puzzles"
console.time 'Processing time'

# solve all puzzles
for puzzle,i in puzzles
	if i != 0 then continue
	if puzzle.length < 81 then continue
	puzzle = puzzle.substring 0,81
	start = process.hrtime()
	if !(res = sudoku.solve puzzle) then throw "Failed on puzzle " + i
	duration = process.hrtime(start)[0]*1000 + process.hrtime(start)[1]/1000000 # ms

	console.log puzzle, i, duration.toFixed(3), 'ms'
	console.log res

	if TRACE then console.log perf
	if !(++i % 2000) then console.log (i * 100 / len).toFixed(1) + '%'
	# output.push puzzle + ',' + res

# results
console.timeEnd 'Processing time'
fs.writeFileSync 'sudoku.log', output.join '\n'
console.log "MD5 = " + require('crypto').createHash('md5').update(output.join '\n').digest "hex"
