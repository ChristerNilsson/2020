# Knuth's Dancing Links
# Original paper: https://arxiv.org/pdf/cs/0011047.pdf
# Implementation ported from: https://github.com/shreevatsa/knuth-literate-programs/blob/master/programs/dance.pdf
#
# Code runs in a state machine in order to avoid recursion
# and in order to work around the lack of `goto` in JS

State = 
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

	currentState = State.FORWARD
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
			[head.up,head.down] = [head,head]
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
			[head.up,head.down] = [head,head]
			column = {head, len:0, key:secondary}
			[column.prev,column.next] = [column,column]
			colArray[curColIndex] = column
			curColIndex++

	readRows  = () ->
		curNodeIndex = 0
		for key,row of rows
			rowStart = undefined

			for columnIndex in row
				node = {data:key}
				[node.left,node.right] = [node,node]
				[node.down,node.up] = [node,node]

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

	iterate = (dir,node,f) ->
		n = node[dir]
		while n != node
			f n
			n = n[dir]

	cover = (c) -> # From top to bottom, left to right unlink every row node from its column
		[c.prev.next, c.next.prev] = [c.next,c.prev] # unlink col
		iterate 'down', c.head, (n) -> iterate 'right', n, (n) ->
			[n.down.up,n.up.down] = [n.up,n.down] # unlink node
			n.col.len--

	uncover  = (c) -> # From bottom to top, right to left relink every row node to its column
		iterate 'up', c.head, (n) -> iterate 'left', n, (n) ->
			[n.down.up,n.up.down] = [n,n] # link node
			n.col.len++
		[c.prev.next, c.next.prev] = [c,c] # link col

	pickBestColumn = -> # Only R and C columns, not A and B
		bestCol = root.next
		iterate 'next', root, (curCol) ->
			if curCol.len < bestCol.len then bestCol = curCol

	forward = ->
		pickBestColumn()
		currentNode = bestCol.head.down
		choices[level] = currentNode
		cover bestCol
		currentState = State.ADVANCE

	recordSolution = -> solutions.push (choices[l].data for l in range level+1).join ' '

	dumpNode = () ->
		entries = {}
		iterate 'next',root, (col) ->
			iterate 'down',col.head, (p) ->
				iterate 'right',p, (n)->
					entries[n.col.key] ||= []
					if n.data not in entries[n.col.key] then entries[n.col.key].push n.data
		for key,entry of entries
			entries[key] = entry.join ' '
		result = {}
		result.choices = ((c.data for c in choices).join ' ').trim()
		result.entries = entries
		snapshots.push result

	advance = () ->
		if currentNode == bestCol.head
			currentState = State.BACKUP
			return
		nodes++

		iterate 'right',currentNode, (pp) -> cover pp.col

		if root.next == root
			recordSolution()
			currentState = if solutions.length == numSolutions then State.DONE else State.RECOVER
			return

		level++
		currentState = State.FORWARD

	backup = () ->
		uncover bestCol
		if level == 0
			currentState = State.DONE
			return
		level--

		currentNode = choices[level]
		bestCol = currentNode.col
		currentState = State.RECOVER

	recover = () ->
		iterate 'left',currentNode, (pp) -> uncover pp.col
		currentNode = currentNode.down
		choices[level] = currentNode
		currentState = State.ADVANCE

	done = () -> running = false

	stateMethods = {
		[State.FORWARD]: forward,
		[State.ADVANCE]: advance,
		[State.BACKUP]: backup,
		[State.RECOVER]: recover,
		[State.DONE]: done
	}

	readColumnNames()
	readRows()
	while running
		if currentState == 0 then dumpNode()
		stateMethods[currentState]()
	dumpNode()
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
	prim = primaries.split ' '
	sec = secondaries.split ' '
	index = {}
	index[p] = i for p,i in prim.concat sec
	entries = {}
	entryCount = 0
	for option in options
		option = option.split ' '
		key = option.shift()		
		entryCount += option.length
		entries[key] = (index[item] for item in option)
	console.log "#{prim.length}+#{sec.length} items, #{options.length} options, #{entryCount} entries"
	{primaries,secondaries,entries}

module.exports = {makeData, search, getSearchConfig, findAll, findOne}
