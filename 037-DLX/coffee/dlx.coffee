# Knuth's Dancing Links
# Original paper: https://arxiv.org/pdf/cs/0011047.pdf
# Implementation ported from: https://github.com/shreevatsa/knuth-literate-programs/blob/master/programs/dance.pdf
#
# Code runs in a state machine in order to avoid recursion
# and in order to work around the lack of `goto` in JS

SearchState = 
	FORWARD : 0
	ADVANCE : 1
	BACKUP : 2
	RECOVER : 3
	DONE : 4

range = (n) -> [0...n]

search = (config) -> # rows: hash with elements "aa":[0,59,118,177]
	{ numSolutions, primaries, secondaries, rows } = config
	
	root = {}

	colArray = [root]
	nodeArray = []
	solutions = []

	currentSearchState = SearchState.FORWARD
	running = true
	level = 0
	choices = []
	bestCol = null
	currentNode = null
	nodes = 0 
	snapshots = []

	readColumnNames = () ->
		# Skip root node
		curColIndex = 1

		for primary in primaries
			head = {}
			head.up = head
			head.down = head
			column = {head, len:0, key:primary} 
			column.prev = colArray[curColIndex - 1]
			colArray[curColIndex - 1].next = column
			colArray[curColIndex] = column
			curColIndex++

		lastCol = colArray[curColIndex - 1]
		# Link the last primaries constraint to wrap back into the root
		lastCol.next = root
		root.prev = lastCol

		for secondary in secondaries
			head = {}
			head.up = head
			head.down = head
			column = {head, len:0, key:secondary}
			column.prev = column
			column.next = column
			colArray[curColIndex] = column
			curColIndex++

	readRows  = () ->
		curNodeIndex = 0
		for key,row of rows
			rowStart = undefined

			for columnIndex in row
				node = {}
				node.left = node
				node.right = node
				node.down = node
				node.up = node
				node.data = key

				nodeArray[curNodeIndex] = node

				if !rowStart
					rowStart = node
				else
					node.left = nodeArray[curNodeIndex - 1]
					nodeArray[curNodeIndex - 1].right = node

				col = colArray[columnIndex + 1]
				node.col = col

				node.up = col.head.up
				col.head.up.down = node

				col.head.up = node
				node.down = col.head

				col.len++
				curNodeIndex++

			rowStart.left = nodeArray[curNodeIndex - 1]
			nodeArray[curNodeIndex - 1].right = rowStart

	cover = (c) -> # c is a column
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

				nn.col.len--
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

				nn.col.len++
				nn = nn.left
			rr = rr.up

		l = c.prev
		r = c.next

		# Unlink column
		l.next = c
		r.prev = c

	pickBestColumn = -> # Only R and C columns, not A and B
		curCol = root.next
		bestCol = curCol
		while curCol != root
			if curCol.len < bestCol.len then bestCol = curCol
			curCol = curCol.next

	forward = ->
		pickBestColumn()
		currentNode = bestCol.head.down
		choices[level] = currentNode
		cover bestCol
		currentSearchState = SearchState.ADVANCE

	recordSolution = -> 
		#solutions.push 0
		#solutions.push (choices[l].data for l in range level+1)
		solutions.push (choices[l].data for l in range level+1).join ' '

		curCol = root.next
		bestCol = curCol
		while curCol != root
			if curCol.len < bestCol.len then bestCol = curCol
			curCol = curCol.next

	dumpNode = (action) ->
		optionsP = {}
		col = root.next
		while col != root
			p = col.head.down
			keys = []
			while p != col.head
				keys.push p.data
				p = p.down
			optionsP[col.key] = keys.join ' '
			col = col.next

		optionsS = {}
		for i in range secondaries.length
			col = colArray[17+i]
			p = col.head.down
			keys = []
			while p != col.head
				keys.push p.data
				p = p.down
			optionsS[col.key] = keys.join ' ' if keys.length > 0
			col = col.next

		result = {}
		result.action = action
		#result.choices = (choices[l].data for l in range level+1).join ' '
		result.choices = (c.data for c in choices).join ' '
		result.primaries = optionsP
		result.secondaries = optionsS
		snapshots.push result

	advance = () ->
		if currentNode == bestCol.head
			currentSearchState = SearchState.BACKUP
			return
		nodes++
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

		level++
		currentSearchState = SearchState.FORWARD

	backup = () ->
		uncover bestCol
		if level == 0
			currentSearchState = SearchState.DONE
			return
		level--
		currentNode = choices[level]
		bestCol = currentNode.col
		currentSearchState = SearchState.RECOVER

	recover = () ->
		pp = currentNode.left
		while pp != currentNode
			uncover pp.col
			pp = pp.left

		currentNode = currentNode.down
		choices[level] = currentNode
		currentSearchState = SearchState.ADVANCE

	done = () -> running = false

	stateMethods = {
		[SearchState.FORWARD]: forward,
		[SearchState.ADVANCE]: advance,
		[SearchState.BACKUP]: backup,
		[SearchState.RECOVER]: recover,
		[SearchState.DONE]: done
	}

	readColumnNames()
	readRows()
	dumpNode ['forward','advance','backtrack','recover','done'][currentSearchState]
	dumpNode ['forward','advance','backtrack','recover','done'][currentSearchState]
	while running
		currentStateMethod = stateMethods[currentSearchState]
		currentStateMethod()
		if currentSearchState in [0,2,3,4] then dumpNode ['forward','advance','backtrack','recover','done'][currentSearchState]
	
	#console.log JSON.stringify dump
	#console.log "#{nodes} nodes #{solutions.length} solutions"
	return {solutions,snapshots}

getSearchConfig = (numSolutions, constraints) ->
	primaries = constraints.primaries
	secondaries = constraints.secondaries
	{primaries, secondaries, numSolutions, rows: constraints.entries}

findAll = (constraints) -> search getSearchConfig Infinity, constraints
findOne = (constraints) -> search getSearchConfig 1, constraints
# find = (constraints, numSolutions) -> search getSearchConfig numSolutions, constraints
# findRaw = (config) -> search config

makeData = ({header,primaries,secondaries,options}) ->
	primaries = primaries.split ' '
	secondaries = secondaries.split ' '
	index = {}
	index[p] = i for p,i in primaries.concat secondaries
	entries = {}
	entryCount = 0
	for option in options
		option = option.split ' '
		key = option.shift()		
		entryCount += option.length
		entries[key] = (index[item] for item in option)
	console.log "#{primaries.length}+#{secondaries.length} items, #{options.length} options, #{entryCount} entries"
	{primaries,secondaries,entries}

module.exports = {makeData, search, getSearchConfig, findAll, findOne}
