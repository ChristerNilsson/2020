#import Constraint from './js/interfaces'
#import SearchConfig from './js/interfaces'

#import search from './js/index'
#import getSearchConfig from './js/utils'

# /**
#  * Knuth's Dancing Links
#  * Original paper: https://arxiv.org/pdf/cs/0011047.pdf
#  * Implementation ported from: https://github.com/shreevatsa/knuth-literate-programs/blob/master/programs/dance.pdf
#  *
#  * Code runs in a state machine in order to avoid recursion
#  * and in order to work around the lack of `goto` in JS
#  */

# import { Column, Node, Result, SearchConfig } from './interfaces'

range = (n) -> [0...n]
  
SearchState = 
	FORWARD : 0
	ADVANCE : 1
	BACKUP : 2
	RECOVER : 3
	DONE : 4

search = (config) ->
	{ numSolutions, numPrimary, numSecondary, rows } = config
	#console.log 'search',numSolutions, numPrimary, numSecondary, rows
	root = {}

	colArray = [root]
	nodeArray = []
	solutions = []

	currentSearchState = SearchState.FORWARD
	running = true
	level = 0
	choice = []
	bestCol = null
	currentNode = null

	readColumnNames = () ->
		#console.log 'readColumnNames',colArray
		# Skip root node
		curColIndex = 1

		for i in range numPrimary #(let i = 0; i < numPrimary; i++) {
			head = {}
			head.up = head
			head.down = head

			column = {
				len: 0,
				head
			}

			column.prev = colArray[curColIndex - 1]
			colArray[curColIndex - 1].next = column

			colArray[curColIndex] = column
			curColIndex = curColIndex + 1

		lastCol = colArray[curColIndex - 1]
		# Link the last primary constraint to wrap back into the root
		lastCol.next = root
		root.prev = lastCol

		for i in range numSecondary
			head = {}
			head.up = head
			head.down = head

			column = {
				head,
				len: 0
			}

			column.prev = column
			column.next = column

			colArray[curColIndex] = column
			curColIndex = curColIndex + 1
			#console.log 'colArray',colArray

	readRows  = () ->
		#console.log 'readRows'
		curNodeIndex = 0

		for i in range rows.length
			#console.log 'i',i
			row = rows[i]
			rowStart = undefined

			for columnIndex in row.coveredColumns # of
				#console.log 'columnIndex',columnIndex
				#console.log 'row.coveredColumns',row.coveredColumns
				node = {}
				node.left = node
				node.right = node
				node.down = node
				node.up = node
				node.index = i
				node.data = row.data
				#console.log 'node',node

				nodeArray[curNodeIndex] = node

				if !rowStart
					rowStart = node
				else
					node.left = nodeArray[curNodeIndex - 1]
					nodeArray[curNodeIndex - 1].right = node

				col = colArray[columnIndex + 1]
				#console.log 'col',col
				node.col = col

				node.up = col.head.up
				col.head.up.down = node

				col.head.up = node
				node.down = col.head

				col.len = col.len + 1
				curNodeIndex = curNodeIndex + 1

			rowStart.left = nodeArray[curNodeIndex - 1]
			nodeArray[curNodeIndex - 1].right = rowStart
		#console.log 'readRows Done'

	cover = (c) ->
		l = c.prev
		r = c.next

		# Unlink column
		l.next = r
		r.prev = l

		# From to to bottom, left to right unlink every row node from its column
		rr = c.head.down
		while rr != c.head
			nn = rr.right
			while nn != rr
				uu = nn.up
				dd = nn.down

				uu.down = dd
				dd.up = uu

				nn.col.len -= 1
				nn = nn.right
			rr = rr.down

	uncover  = (c) ->
		# From bottom to top, right to left relink every row node to its column
		rr = c.head.up
		while rr != c.head
			nn = rr.left
			while nn != rr
				uu = nn.up
				dd = nn.down

				uu.down = nn
				dd.up = nn

				nn.col.len += 1
				nn = nn.left
			rr = rr.up

		l = c.prev
		r = c.next

		# Unlink column
		l.next = c
		r.prev = c

	pickBestColum = () ->
		lowestLen = root.next.len
		lowest = root.next
		curCol = root.next
		while curCol != root
			length = curCol.len
			if length < lowestLen
				lowestLen = length
				lowest = curCol
			curCol = curCol.next
		bestCol = lowest

	forward = () ->
		#console.log 'forward'
		pickBestColum()
		cover(bestCol)

		currentNode = bestCol.head.down
		choice[level] = currentNode

		currentSearchState = SearchState.ADVANCE

	recordSolution = () ->
		results = []
		for l in range level+1 #(let l = 0; l <= level; l++) {
			node = choice[l]
			results.push {
				index: node.index,
				data: node.data
			}

		solutions.push(results)

	advance = () ->
		#console.log 'advance'
		if currentNode == bestCol.head
			currentSearchState = SearchState.BACKUP
			return
		pp = currentNode.right
		while pp != currentNode
			cover pp.col
			pp = pp.right

		if root.next == root
			recordSolution()
			if solutions.length == numSolutions
				currentSearchState = SearchState.DONE
			else
				currentSearchState = SearchState.RECOVER
			return

		level = level + 1
		currentSearchState = SearchState.FORWARD

	backup = () ->
		#console.log 'backup'
		uncover bestCol

		if level == 0
			currentSearchState = SearchState.DONE
			return

		level = level - 1

		currentNode = choice[level]
		bestCol = currentNode.col

		currentSearchState = SearchState.RECOVER

	recover = () ->
		#console.log 'recover'
		pp = currentNode.left
		while pp != currentNode
			uncover pp.col
			pp = pp.left
		currentNode = currentNode.down
		choice[level] = currentNode
		currentSearchState = SearchState.ADVANCE

	done = () ->
		#console.log 'done'
		running = false

	stateMethods = {
		[SearchState.FORWARD]: forward,
		[SearchState.ADVANCE]: advance,
		[SearchState.BACKUP]: backup,
		[SearchState.RECOVER]: recover,
		[SearchState.DONE]: done
	}

	#console.log 'stateMethods',stateMethods

	readColumnNames()
	readRows()

	while (running)
		#console.log 'currentSearchState',currentSearchState
		currentStateMethod = stateMethods[currentSearchState]
		currentStateMethod()

	return solutions

#export { search }

isSimpleConstraint = (arg) -> return arg.row != undefined 
isComplexConstraint = (arg) -> return arg.primaryRow != undefined and arg.secondaryRow != undefined

# type BinaryInt = 0 | 1 

binaryToSparseRow  = (binaryRow, offset = 0) ->
	sparseRow = []
	for i in range binaryRow.length
		if binaryRow[i] == 1
			sparseRow.push(i + offset)
	return sparseRow

getParams  = (constraint) ->
	numPrimary = 0
	numSecondary = 0

	if isSimpleConstraint constraint
		numPrimary = constraint.row.length
	else if  isComplexConstraint constraint
		numPrimary = constraint.primaryRow.length
		numSecondary = constraint.secondaryRow.length

	{
		numPrimary,
		numSecondary
	}

getSearchConfig = (numSolutions, constraints) ->
	#console.log 'getSearchConfig',numSolutions,constraints
	{ numPrimary, numSecondary } = getParams(constraints[0])
	#console.log numPrimary,numSecondary
	sparseConstraints = constraints.map((c) => 
		data = c.data
		coveredColumns= []
		if isSimpleConstraint c
			coveredColumns = binaryToSparseRow c.row
		else if isComplexConstraint c
			coveredColumns = binaryToSparseRow(c.primaryRow).concat(binaryToSparseRow(c.secondaryRow, numPrimary))

		#console.log 'data',data
		#console.log 'coveredColumns',coveredColumns

		return {
			data,
			coveredColumns
		}
	)

	return {
		numPrimary,
		numSecondary,
		numSolutions,
		rows: sparseConstraints
	}

findAll = (constraints) ->
  return search(getSearchConfig(Infinity, constraints))

findOne = (constraints) ->
  return search(getSearchConfig(1, constraints))

find = (constraints, numSolutions) ->
  return search(getSearchConfig(numSolutions, constraints))

findRaw = (config) ->
  return search(config)

#export { Constraint, SimpleConstraint, ComplexConstraint, SearchConfig, Row, Result } from './lib/interfaces'

##############################

# constraints = [
# 	{
# 		data: 'first one',
# 		primaryRow: [1,0],
# 		secondaryRow: [1]
# 	},
# 	{
# 		data: 'second one',
# 		primaryRow: [0,1],
# 		secondaryRow: [0]
# 	},
# 	{
# 		data: 'third one',
# 		primaryRow: [0,1],
# 		secondaryRow: [1]
# 	}
# ]

# constraints = [
# 	{data: 0,row: [0,0,1,0,1,0,0]},
# 	{data: 1,row: [1,0,0,1,0,0,1]},
# 	{data: 2,row: [0,1,1,0,0,1,0]},
# 	{data: 3,row: [1,0,0,1,0,1,0]},
# 	{data: 4,row: [0,1,0,0,0,0,1]},
# 	{data: 5,row: [0,0,0,1,1,0,1]},
# ]
# oneSolution = findOne constraints
# console.log oneSolution

queens8 = '''
| This data produced by queens-dlx 8
r4 c4 r3 c3 r5 c5 r2 c2 r6 c6 r1 c1 r7 c7 r0 c0 | a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 a5 b5 a6 b6 a7 b7 a8 b8 a9 b9 aa ba ab bb ac bc ad bd
r0 c0 a0 b7
r0 c1 a1 b8
r0 c2 a2 b9
r0 c3 a3 ba
r0 c4 a4 bb
r0 c5 a5 bc
r0 c6 a6 bd
r0 c7 a7
r1 c0 a1 b6
r1 c1 a2 b7
r1 c2 a3 b8
r1 c3 a4 b9
r1 c4 a5 ba
r1 c5 a6 bb
r1 c6 a7 bc
r1 c7 a8 bd
r2 c0 a2 b5
r2 c1 a3 b6
r2 c2 a4 b7
r2 c3 a5 b8
r2 c4 a6 b9
r2 c5 a7 ba
r2 c6 a8 bb
r2 c7 a9 bc
r3 c0 a3 b4
r3 c1 a4 b5
r3 c2 a5 b6
r3 c3 a6 b7
r3 c4 a7 b8
r3 c5 a8 b9
r3 c6 a9 ba
r3 c7 aa bb
r4 c0 a4 b3
r4 c1 a5 b4
r4 c2 a6 b5
r4 c3 a7 b6
r4 c4 a8 b7
r4 c5 a9 b8
r4 c6 aa b9
r4 c7 ab ba
r5 c0 a5 b2
r5 c1 a6 b3
r5 c2 a7 b4
r5 c3 a8 b5
r5 c4 a9 b6
r5 c5 aa b7
r5 c6 ab b8
r5 c7 ac b9
r6 c0 a6 b1
r6 c1 a7 b2
r6 c2 a8 b3
r6 c3 a9 b4
r6 c4 aa b5
r6 c5 ab b6
r6 c6 ac b7
r6 c7 ad b8
r7 c0 a7 b0
r7 c1 a8 b1
r7 c2 a9 b2
r7 c3 aa b3
r7 c4 ab b4
r7 c5 ac b5
r7 c6 ad b6
r7 c7 b7
'''

queens16 = '''
| This data produced by queens-dlx 16
r8 c8 r7 c7 r9 c9 r6 c6 ra ca r5 c5 rb cb r4 c4 rc cc r3 c3 rd cd r2 c2 re ce r1 c1 rf cf r0 c0 | a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 a5 b5 a6 b6 a7 b7 a8 b8 a9 b9 aa ba ab bb ac bc ad bd ae be af bf ag bg ah bh ai bi aj bj ak bk al bl am bm an bn ao bo ap bp aq bq ar br as bs at bt
r0 c0 a0 bf
r0 c1 a1 bg
r0 c2 a2 bh
r0 c3 a3 bi
r0 c4 a4 bj
r0 c5 a5 bk
r0 c6 a6 bl
r0 c7 a7 bm
r0 c8 a8 bn
r0 c9 a9 bo
r0 ca aa bp
r0 cb ab bq
r0 cc ac br
r0 cd ad bs
r0 ce ae bt
r0 cf af
r1 c0 a1 be
r1 c1 a2 bf
r1 c2 a3 bg
r1 c3 a4 bh
r1 c4 a5 bi
r1 c5 a6 bj
r1 c6 a7 bk
r1 c7 a8 bl
r1 c8 a9 bm
r1 c9 aa bn
r1 ca ab bo
r1 cb ac bp
r1 cc ad bq
r1 cd ae br
r1 ce af bs
r1 cf ag bt
r2 c0 a2 bd
r2 c1 a3 be
r2 c2 a4 bf
r2 c3 a5 bg
r2 c4 a6 bh
r2 c5 a7 bi
r2 c6 a8 bj
r2 c7 a9 bk
r2 c8 aa bl
r2 c9 ab bm
r2 ca ac bn
r2 cb ad bo
r2 cc ae bp
r2 cd af bq
r2 ce ag br
r2 cf ah bs
r3 c0 a3 bc
r3 c1 a4 bd
r3 c2 a5 be
r3 c3 a6 bf
r3 c4 a7 bg
r3 c5 a8 bh
r3 c6 a9 bi
r3 c7 aa bj
r3 c8 ab bk
r3 c9 ac bl
r3 ca ad bm
r3 cb ae bn
r3 cc af bo
r3 cd ag bp
r3 ce ah bq
r3 cf ai br
r4 c0 a4 bb
r4 c1 a5 bc
r4 c2 a6 bd
r4 c3 a7 be
r4 c4 a8 bf
r4 c5 a9 bg
r4 c6 aa bh
r4 c7 ab bi
r4 c8 ac bj
r4 c9 ad bk
r4 ca ae bl
r4 cb af bm
r4 cc ag bn
r4 cd ah bo
r4 ce ai bp
r4 cf aj bq
r5 c0 a5 ba
r5 c1 a6 bb
r5 c2 a7 bc
r5 c3 a8 bd
r5 c4 a9 be
r5 c5 aa bf
r5 c6 ab bg
r5 c7 ac bh
r5 c8 ad bi
r5 c9 ae bj
r5 ca af bk
r5 cb ag bl
r5 cc ah bm
r5 cd ai bn
r5 ce aj bo
r5 cf ak bp
r6 c0 a6 b9
r6 c1 a7 ba
r6 c2 a8 bb
r6 c3 a9 bc
r6 c4 aa bd
r6 c5 ab be
r6 c6 ac bf
r6 c7 ad bg
r6 c8 ae bh
r6 c9 af bi
r6 ca ag bj
r6 cb ah bk
r6 cc ai bl
r6 cd aj bm
r6 ce ak bn
r6 cf al bo
r7 c0 a7 b8
r7 c1 a8 b9
r7 c2 a9 ba
r7 c3 aa bb
r7 c4 ab bc
r7 c5 ac bd
r7 c6 ad be
r7 c7 ae bf
r7 c8 af bg
r7 c9 ag bh
r7 ca ah bi
r7 cb ai bj
r7 cc aj bk
r7 cd ak bl
r7 ce al bm
r7 cf am bn
r8 c0 a8 b7
r8 c1 a9 b8
r8 c2 aa b9
r8 c3 ab ba
r8 c4 ac bb
r8 c5 ad bc
r8 c6 ae bd
r8 c7 af be
r8 c8 ag bf
r8 c9 ah bg
r8 ca ai bh
r8 cb aj bi
r8 cc ak bj
r8 cd al bk
r8 ce am bl
r8 cf an bm
r9 c0 a9 b6
r9 c1 aa b7
r9 c2 ab b8
r9 c3 ac b9
r9 c4 ad ba
r9 c5 ae bb
r9 c6 af bc
r9 c7 ag bd
r9 c8 ah be
r9 c9 ai bf
r9 ca aj bg
r9 cb ak bh
r9 cc al bi
r9 cd am bj
r9 ce an bk
r9 cf ao bl
ra c0 aa b5
ra c1 ab b6
ra c2 ac b7
ra c3 ad b8
ra c4 ae b9
ra c5 af ba
ra c6 ag bb
ra c7 ah bc
ra c8 ai bd
ra c9 aj be
ra ca ak bf
ra cb al bg
ra cc am bh
ra cd an bi
ra ce ao bj
ra cf ap bk
rb c0 ab b4
rb c1 ac b5
rb c2 ad b6
rb c3 ae b7
rb c4 af b8
rb c5 ag b9
rb c6 ah ba
rb c7 ai bb
rb c8 aj bc
rb c9 ak bd
rb ca al be
rb cb am bf
rb cc an bg
rb cd ao bh
rb ce ap bi
rb cf aq bj
rc c0 ac b3
rc c1 ad b4
rc c2 ae b5
rc c3 af b6
rc c4 ag b7
rc c5 ah b8
rc c6 ai b9
rc c7 aj ba
rc c8 ak bb
rc c9 al bc
rc ca am bd
rc cb an be
rc cc ao bf
rc cd ap bg
rc ce aq bh
rc cf ar bi
rd c0 ad b2
rd c1 ae b3
rd c2 af b4
rd c3 ag b5
rd c4 ah b6
rd c5 ai b7
rd c6 aj b8
rd c7 ak b9
rd c8 al ba
rd c9 am bb
rd ca an bc
rd cb ao bd
rd cc ap be
rd cd aq bf
rd ce ar bg
rd cf as bh
re c0 ae b1
re c1 af b2
re c2 ag b3
re c3 ah b4
re c4 ai b5
re c5 aj b6
re c6 ak b7
re c7 al b8
re c8 am b9
re c9 an ba
re ca ao bb
re cb ap bc
re cc aq bd
re cd ar be
re ce as bf
re cf at bg
rf c0 af b0
rf c1 ag b1
rf c2 ah b2
rf c3 ai b3
rf c4 aj b4
rf c5 ak b5
rf c6 al b6
rf c7 am b7
rf c8 an b8
rf c9 ao b9
rf ca ap ba
rf cb aq bb
rf cc ar bc
rf cd as bd
rf ce at be
rf cf bf
'''

sudoku1='''
| 000005060004900070000003008070006300030009020006048090300500000090004500060200080
p00 p01 p02 p03 p04 p06 p08 p10 p11 p14 p15 p16 p18 p20 p21 p22 p23 p24 p26 p27 p30 p32 p33 p34 p37 p38 p40 p42 p43 p44 p46 p48 p50 p51 p53 p56 p58 p61 p62 p64 p65 p66 p67 p68 p70 p72 p73 p74 p77 p78 p80 p82 p84 p85 p86 p88 r01 r02 r03 r04 r07 r08 r09 r11 r12 r13 r15 r16 r18 r21 r22 r24 r25 r26 r27 r29 r31 r32 r34 r35 r38 r39 r41 r44 r45 r46 r47 r48 r51 r52 r53 r55 r57 r61 r62 r64 r66 r67 r68 r69 r71 r72 r73 r76 r77 r78 r81 r83 r84 r85 r87 r89 c01 c02 c04 c05 c06 c07 c08 c09 c11 c12 c14 c15 c18 c21 c22 c23 c25 c27 c28 c29 c31 c33 c34 c36 c37 c38 c41 c42 c43 c45 c46 c47 c48 c49 c51 c52 c57 c61 c62 c64 c66 c67 c68 c69 c71 c73 c74 c75 c81 c82 c83 c84 c85 c86 c87 c89 b01 b02 b03 b05 b06 b07 b08 b09 b11 b12 b14 b16 b17 b18 b21 b22 b23 b24 b25 b29 b31 b32 b34 b35 b38 b39 b41 b42 b43 b45 b47 b51 b54 b55 b56 b57 b58 b61 b62 b64 b65 b67 b68 b71 b73 b76 b77 b78 b79 b81 b82 b83 b84 b86 b87 b89
p00 r01 c01 b01
p00 r02 c02 b02
p00 r07 c07 b07
p00 r08 c08 b08
p00 r09 c09 b09
p01 r01 c11 b01
p01 r02 c12 b02
p01 r08 c18 b08
p02 r01 c21 b01
p02 r02 c22 b02
p02 r03 c23 b03
p02 r07 c27 b07
p02 r08 c28 b08
p02 r09 c29 b09
p03 r01 c31 b11
p03 r04 c34 b14
p03 r07 c37 b17
p03 r08 c38 b18
p04 r01 c41 b11
p04 r02 c42 b12
p04 r07 c47 b17
p04 r08 c48 b18
p06 r01 c61 b21
p06 r02 c62 b22
p06 r04 c64 b24
p06 r09 c69 b29
p08 r01 c81 b21
p08 r02 c82 b22
p08 r03 c83 b23
p08 r04 c84 b24
p08 r09 c89 b29
p10 r11 c01 b01
p10 r12 c02 b02
p10 r15 c05 b05
p10 r16 c06 b06
p10 r18 c08 b08
p11 r11 c11 b01
p11 r12 c12 b02
p11 r15 c15 b05
p11 r18 c18 b08
p14 r11 c41 b11
p14 r12 c42 b12
p14 r16 c46 b16
p14 r18 c48 b18
p15 r11 c51 b11
p15 r12 c52 b12
p16 r11 c61 b21
p16 r12 c62 b22
p18 r11 c81 b21
p18 r12 c82 b22
p18 r13 c83 b23
p18 r15 c85 b25
p20 r21 c01 b01
p20 r22 c02 b02
p20 r25 c05 b05
p20 r26 c06 b06
p20 r27 c07 b07
p20 r29 c09 b09
p21 r21 c11 b01
p21 r22 c12 b02
p21 r25 c15 b05
p22 r21 c21 b01
p22 r22 c22 b02
p22 r25 c25 b05
p22 r27 c27 b07
p22 r29 c29 b09
p23 r21 c31 b11
p23 r24 c34 b14
p23 r26 c36 b16
p23 r27 c37 b17
p24 r21 c41 b11
p24 r22 c42 b12
p24 r26 c46 b16
p24 r27 c47 b17
p26 r21 c61 b21
p26 r22 c62 b22
p26 r24 c64 b24
p26 r29 c69 b29
p27 r21 c71 b21
p27 r24 c74 b24
p27 r25 c75 b25
p30 r31 c01 b31
p30 r32 c02 b32
p30 r34 c04 b34
p30 r35 c05 b35
p30 r38 c08 b38
p30 r39 c09 b39
p32 r31 c21 b31
p32 r32 c22 b32
p32 r35 c25 b35
p32 r38 c28 b38
p32 r39 c29 b39
p33 r31 c31 b41
p34 r31 c41 b41
p34 r32 c42 b42
p34 r35 c45 b45
p37 r31 c71 b51
p37 r34 c74 b54
p37 r35 c75 b55
p38 r31 c81 b51
p38 r34 c84 b54
p38 r35 c85 b55
p40 r41 c01 b31
p40 r44 c04 b34
p40 r45 c05 b35
p40 r48 c08 b38
p42 r41 c21 b31
p42 r45 c25 b35
p42 r48 c28 b38
p43 r41 c31 b41
p43 r47 c37 b47
p44 r41 c41 b41
p44 r45 c45 b45
p44 r47 c47 b47
p46 r41 c61 b51
p46 r44 c64 b54
p46 r46 c66 b56
p46 r47 c67 b57
p46 r48 c68 b58
p48 r41 c81 b51
p48 r44 c84 b54
p48 r45 c85 b55
p48 r46 c86 b56
p48 r47 c87 b57
p50 r51 c01 b31
p50 r52 c02 b32
p50 r55 c05 b35
p51 r51 c11 b31
p51 r52 c12 b32
p51 r55 c15 b35
p53 r51 c31 b41
p53 r53 c33 b43
p53 r57 c37 b47
p56 r51 c61 b51
p56 r57 c67 b57
p58 r51 c81 b51
p58 r55 c85 b55
p58 r57 c87 b57
p61 r61 c11 b61
p61 r62 c12 b62
p61 r64 c14 b64
p61 r68 c18 b68
p62 r61 c21 b61
p62 r62 c22 b62
p62 r67 c27 b67
p62 r68 c28 b68
p64 r61 c41 b71
p64 r66 c46 b76
p64 r67 c47 b77
p64 r68 c48 b78
p64 r69 c49 b79
p65 r61 c51 b71
p65 r67 c57 b77
p66 r61 c61 b81
p66 r62 c62 b82
p66 r64 c64 b84
p66 r66 c66 b86
p66 r67 c67 b87
p66 r69 c69 b89
p67 r61 c71 b81
p67 r64 c74 b84
p68 r61 c81 b81
p68 r62 c82 b82
p68 r64 c84 b84
p68 r66 c86 b86
p68 r67 c87 b87
p68 r69 c89 b89
p70 r71 c01 b61
p70 r72 c02 b62
p70 r77 c07 b67
p70 r78 c08 b68
p72 r71 c21 b61
p72 r72 c22 b62
p72 r77 c27 b67
p72 r78 c28 b68
p73 r71 c31 b71
p73 r73 c33 b73
p73 r76 c36 b76
p73 r77 c37 b77
p73 r78 c38 b78
p74 r71 c41 b71
p74 r73 c43 b73
p74 r76 c46 b76
p74 r77 c47 b77
p74 r78 c48 b78
p77 r71 c71 b81
p77 r73 c73 b83
p78 r71 c81 b81
p78 r72 c82 b82
p78 r73 c83 b83
p78 r76 c86 b86
p78 r77 c87 b87
p80 r81 c01 b61
p80 r84 c04 b64
p80 r85 c05 b65
p80 r87 c07 b67
p82 r81 c21 b61
p82 r85 c25 b65
p82 r87 c27 b67
p84 r81 c41 b71
p84 r83 c43 b73
p84 r87 c47 b77
p84 r89 c49 b79
p85 r81 c51 b71
p85 r87 c57 b77
p86 r81 c61 b81
p86 r84 c64 b84
p86 r87 c67 b87
p86 r89 c69 b89
p88 r81 c81 b81
p88 r83 c83 b83
p88 r84 c84 b84
p88 r87 c87 b87
p88 r89 c89 b89
'''

# constraints = [
# 	{
# 		data: 'first one',
# 		primaryRow: [1,0],
# 		secondaryRow: [1]
# 	},
# 	{
# 		data: 'second one',
# 		primaryRow: [0,1],
# 		secondaryRow: [0]
# 	},
# 	{
# 		data: 'third one',
# 		primaryRow: [0,1],
# 		secondaryRow: [1]
# 	}
# ]

makeData = (lines) -> # n-queens
	lines = lines.split '\n'
	comment = lines.shift()
	header = lines.shift()
	[primary,secondary] = header.split '|'
	primary = primary.trim().split ' '
	#console.log secondary
	secondary = secondary.trim().split ' ' if secondary
	result = []
	for line in lines
		line = line.split ' '
		console.log line
		primaryRow = Array(primary.length).fill 0
		secondaryRow = Array(secondary.length).fill 0 if secondary
		[r,c,a,b] = line
		ri = primary.indexOf r
		ci = primary.indexOf c
		ai = secondary.indexOf a if secondary
		bi = secondary.indexOf b if secondary
		primaryRow[ri] = 1
		primaryRow[ci] = 1
		secondaryRow[ai] = 1 if secondary and ai != -1 
		secondaryRow[bi] = 1 if secondary and bi != -1
		if secondary
			result.push {data:c + r, primaryRow, secondaryRow}
		else
			row = primaryRow
			result.push {data:c + r[1], row}
	result

makeData = (lines) -> # sudoku1 695 us
	lines = lines.split '\n'
	comment = lines.shift()
	header = lines.shift()
	primary = header.trim().split ' '
	result = []
	for line in lines
		line = line.split ' '
		key = line[1] + line[2]
		row = Array(primary.length).fill 0
		for item in line
			row[primary.indexOf item] = 1
		result.push {data:key, row}
	result

data = makeData sudoku1
#console.log data
start = new Date()
for i in range 1000
	oneSolution = findOne data
console.log "#{(new Date()) - start} ms"
console.log oneSolution
##############################