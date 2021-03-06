range = _.range

N = 9
SIZE = 34
COLOR = '#ccc #f00'.split ' '

MAYBE = 0
NO = 1 # RED
YES = 1 # GREEN

#ERROR = -2
UNKNOWN = -1

HELP = 0 # 0=no support 1=show green/yellow

digits = [] # 0..8 or UNKNOWN length=81
tabu = []   # [0,0,0,0,0,0,0,0,0] 0..1 length=81
single = (UNKNOWN for i in range 81) # 0..8 or UNKNOWN length=81
stack = [] # contains 0..80

examples = []
example = 0
sudoku = null

calcDigits = (s) ->
	res = 0
	for ch in s 
		if ch != '0' then res++
	return res 

calcCell = ->
	for i in range N
		for j in range N
			#if digits[i+N*j] == UNKNOWN
			if single[i+N*j] == UNKNOWN
				count = 0
				index = -1
				for k in range N
					if tabu[i + N*j][k] == MAYBE
						count++
						index = k
				#if count == 0 then single[i + N*j] = ERROR
				if count == 1
					if tabu[i + N*j][index] == MAYBE then single[i + N*j] = index

calcRow = ->
	for j in range N
		for k in range N
			count = 0
			index = -1
			for i in range N 
				if digits[i+N*j] == UNKNOWN and tabu[i+N*j][k] == MAYBE
					count++
					index = i
			if count == 1
				if tabu[index + N*j][k] == MAYBE then single[index + N*j] = k

calcCol = ->
	for i in range N
		for k in range N
			count = 0
			index = -1
			for j in range N
				if digits[i+N*j] == UNKNOWN and tabu[i + N*j][k] == MAYBE
					count++
					index = j
			if count == 1
				if tabu[i + N*index][k] == MAYBE then single[i + N*index] = k

calc3x3 = ->
	for i in range N
		for j in range N
			if digits[i+N*j] == UNKNOWN
				ioff = i - i % 3
				joff = j - j % 3
				for k in range N
					count = 0
					index = -1
					for i0 in range 3
						for j0 in range 3
							ix = (ioff+i0) + N*(joff+j0)
							if digits[ix] == UNKNOWN
								if tabu[ix][k] == MAYBE
									count++
									index = ix 
					if count == 1
						if tabu[index][k] == MAYBE then single[index] = k

calcTabu = ->
	tabu = ([0,0,0,0,0,0,0,0,0] for i in range N*N)
	for i in range N
		for j in range N
			digit = digits[i+N*j]
			if digit == UNKNOWN then continue
			for index in range N
				tabu[i + N*j][index] = NO # cell
				tabu[i + N*index][digit] = NO # col
				tabu[index + N*j][digit] = NO # row
			
			ioff = i - i % 3
			joff = j - j % 3
			for i0 in range 3
				for j0 in range 3
					tabu[(ioff+i0) + N*(joff+j0)][digit] = NO

			tabu[i + N*j][digit] = YES

calcSingle = ->
	single = (UNKNOWN for i in range 81)
	if HELP == 0 then return
	calcCell()
	calcRow()
	calcCol()
	calc3x3()

click = (index,digit) -> 
	stack.push index # 0..80
	digits[index] = digit # 0..8
	calcTabu()
	calcSingle()
	sudoku = new Sudoku()

# dump = ->
# 	calcTabu()
# 	calcSingle()
# 	console.log single
# 	for i in range N*N
# 		console.log i,digits[i],tabu[i]
# 	for i in range N
# 		console.log i,single.slice N*i,N*i+N

undo = ->
	if stack.length == 0 then return
	digits[stack.pop()] = UNKNOWN
	calcTabu()
	calcSingle()

clearAll = ->
	digits = (UNKNOWN for digit in range N*N)
	tabu = ([0,0,0,0,0,0,0,0,0] for i in range N*N)
	#digits = [] # 0..8 or UNKNOWN length=81
	#tabu = []   # [0,0,0,0,0,0,0,0,0] 0..1 length=81
	single = (UNKNOWN for i in range 81) # 0..8 or UNKNOWN length=81
	stack = [] # contains 0..80

myRound = (x) -> round(1000*x)/1000

solver = ->
	problem = ''
	for digit in digits
		problem += digit+1
	if calcDigits(problem) < 17 then return 'You need at least 17 digits!'
	start = performance.now()
	solution = sudoku.solve problem #'020050700400100006800003000200008003040020500000600010002090000090000005704000900'
	if !solution then return "No solution!"
	duration = myRound(performance.now() - start) + ' ms'
	console.log duration
	res = ''
	for ch in solution
		if res.length % (4*9) ==  4 * (9-1) then res += ch + '  \n' else res += ch + '   '
	return res.slice(0,res.length-1) + '   '  + duration

setup = ->
	createCanvas SIZE*28+2+2,SIZE*28+2+2
	textAlign CENTER,CENTER
	strokeWeight 0
	clearAll()
	saveExamples()

drawBackground = (i,j,color)->
	fill color
	rect 3*SIZE*i+1, 3*SIZE*j+1, 3*SIZE-2, 3*SIZE-2

drawLittera = ->
	fill 0
	textSize 32
	for letter,i in 'ABCDEFGHI'
		text letter, 3*SIZE*(i+0.5),SIZE*27.7
		text N-i, SIZE*27.6, 3*SIZE*(i+0.5)

drawTabu = (i,j) ->
	if single[i+N*j] == UNKNOWN then drawBackground i,j,'#fff'
	#else if single[i+N*j] == ERROR then drawBackground i,j,'#f44'
	else drawBackground i,j,'#ff0'
	textSize 20
	for k in range 9
		x = 3*i+k % 3
		y = 3*j+int(k / 3)
		t = tabu[i + N*j][k]
		fill if single[i + N*j] == k then '#0f0' else COLOR[t]
		if t != 1
			text k+1,SIZE*(x+0.5),SIZE*(y+0.5)+2

drawDigit = (i,j) ->
	drawBackground i,j,'#fff'
	textSize 50
	digit = digits[i+N*j]+1
	fill 0
	text digit,SIZE*(3*i+1.5),SIZE*(3*j+1.5)+2

drawDividers = ->
	fill 128
	for i in range 4
		rect SIZE*N*i,0,5,height-SIZE
		rect 0,SIZE*N*i,width-SIZE,5

drawUndo = ->
	fill 0
	textSize 32
	text stack.length, SIZE*27.5, SIZE*27.6

draw = ->
	background 128
	drawLittera()

	for i in range N
		for j in range N
			if digits[i+N*j] == UNKNOWN
				drawTabu i,j
			else
				drawDigit i,j

	drawDividers()
	drawUndo()

auto = ->
	lst = []
	for index in range N*N
		if digits[index] == UNKNOWN
			if single[index] != UNKNOWN
				lst.push [index,single[index]]
	for [index,digit] in lst
		click index,digit

mousePressed = ->
	i = int mouseX / (SIZE*3)
	j = int mouseY / (SIZE*3)
	index = i + N * j
	kx = (int mouseX / SIZE) % 3
	ky = (int mouseY / SIZE) % 3
	k = kx + 3 * ky
	if i < 9 and j < 9 then click index,k

	if index == 81 then	auto() # A
	if index == 83 then	clearAll() # C
	if index == 84 then setExample -1 # D
	if index == 85 then	setExample 1 # E
	if index == 88 then HELP = 1 - HELP # H
	if index == 89 then alert solver()
	if index == 90 then undo()

	if 80 < index < 90
		calcTabu()
		calcSingle()

loadExample = (rows) ->
	index = 0
	for row in rows
		for char in row
			if char not in ' .' then click index,parseInt(char)-1
			index++

saveExamples = ->
	examples.push [ 
		'         '
		'         '
		'         '
		'         '
		'         '
		'         '
		'         '
		'         '
		'         '
	]
	examples.push [ # postnord 20-07-30
		' 8  1   5'
		' 94 6  1 '
		'5   8  9 '
		'1  9768  '
		' 49  8  7'
		'        9'
		'  1  7 42'
		'   6   8 '
		'65  42   '
	]
	examples.push [ # postnord 20-08-17
		'         '
		'25   3 18'
		'3   84572'
		' 3  41 9 '
		' 7  9  3 '
		'   3 8  4'
		'  3 25 81'
		'5 9      '
		'  1    2 '
	]
	examples.push [ # postnord 20-08-31
		'8   1 3  '
		' 1 5  98 '
		'3 9  4 1 '
		'2    6 7 '
		' 7   31 9'
		'1   8    '
		'7 6     8'
		'4     5  '
		'   32 746'
	]
	examples.push [ # expert
		'  7  4 26'
		' 9    8 1'
		' 6     7 '
		'    9    '
		'   5     '
		'58 1 6  4'
		'4  9 1  8'
		'  1 7   2'
		'         '
	]
	examples.push [ # hardest ever
		'     6   '
		' 59     8'
		'2    8   '
		' 45      '
		'  3      '
		'  6  3 54'
		'   325  6'
		'         '
		'         '
		]
	examples.push [ # Cracking the Cryptic
		' 8  2 56 '
		'   1    7'
		'   5     '
		' 5  9 4 8'
		'  785   3'
		' 9  1  5 '
		'2 4  18  '
		' 6  85   '
		'   2  1  '
		]

	examples.push [
		'....9..5.'
		'.1.....3.'
		'..23..7..'
		'..45...7.'
		'8.....2..'
		'.....64..'
		'.9..1....'
		'.8..6....'
		'..54....7'
	]

	examples.push [
		' 7 25 4  '
		'8     9 3'
		'     3 7 '
		'7    4 2 '
		'1       7'
		' 4 5    8'
		' 9 6     '
		'4 1     5'
		'  7 82 3 '
	]

	examples.push [
		' 2  5 7  '
		'4  1    6'
		'8    3   '
		'2    8  3'
		' 4  2 5  '
		'   6   1 '
		'  2 9    '
		' 9      5'
		'7 4   9  '
	]

	examples.push [
		'       12'
		'  8 3    '
		'       4 '
		'12 5     '
		'     47  '
		' 6       '
		'5 7   3  '
		'   62    '
		'   1     '
		]
		
setExample = (delta) -> 
	example = (example + delta) %% examples.length
	clearAll()
	loadExample examples[example]
	calcTabu()
	calcSingle()
