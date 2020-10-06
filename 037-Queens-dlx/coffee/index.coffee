# /**
#  * Knuth's Dancing Links
#  * Original paper: https://arxiv.org/pdf/cs/0011047.pdf
#  * Implementation ported from: https://github.com/shreevatsa/knuth-literate-programs/blob/master/programs/dance.pdf
#  *
#  * Code runs in a state machine in order to avoid recursion
#  * and in order to work around the lack of `goto` in JS
#  */

{ SearchConfig } = require './interfaces'
  
SearchState = 
	FORWARD : 0
	ADVANCE : 1
	BACKUP : 2
	RECOVER : 3
	DONE : 4

search = (config) ->
	{ numSolutions, numPrimary, numSecondary, rows } = config
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

	readRows  = () ->
		curNodeIndex = 0

		for i in range rows.length
			row = rows[i]
			rowStart = undefined

			for columnIndex of row.coveredColumns
				node = {}
				node.left = node
				node.right = node
				node.down = node
				node.up = node
				node.index = i
				node.data = row.data

				nodeArray[curNodeIndex] = node

				if (!rowStart) 
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

				col.len = col.len + 1
				curNodeIndex = curNodeIndex + 1

			rowStart.left = nodeArray[curNodeIndex - 1]
			nodeArray[curNodeIndex - 1].right = rowStart

	cover = (c) ->
		l = c.prev
		r = c.next

		# Unlink column
		l.next = r
		r.prev = l

		# From to to bottom, left to right unlink every row node from its column
		rr = c.head.down; 
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
		pickBestColum()
		cover(bestCol)

		currentNode = bestCol.head.down
		choice[level] = currentNode

		currentSearchState = SearchState.ADVANCE

	recordSolution = () ->
		results = []
		for l in range level #(let l = 0; l <= level; l++) {
			node = choice[l]
			results.push {
				index: node.index,
				data: node.data
			}

		solutions.push(results)

	advance = () ->
		if (currentNode == bestCol.head) 
			currentSearchState = SearchState.BACKUP
			return
		pp = currentNode.right
		while pp != currentNode
			cover(pp.col)
			pp = pp.right

		if (root.next == root) 
			recordSolution()
			if (solutions.length == numSolutions) 
				currentSearchState = SearchState.DONE
			else
				currentSearchState = SearchState.RECOVER
			return

		level = level + 1
		currentSearchState = SearchState.FORWARD

	backup = () ->
		uncover(bestCol)

		if (level == 0) 
			currentSearchState = SearchState.DONE
			return

		level = level - 1

		currentNode = choice[level]
		bestCol = currentNode.col

		currentSearchState = SearchState.RECOVER

	recover = () ->
		pp = currentNode.left
		while pp != currentNode
			uncover(pp.col)
			pp = pp.left
		currentNode = currentNode.down
		choice[level] = currentNode
		currentSearchState = SearchState.ADVANCE

	done = () ->
		running = false

	stateMethods = {
		[SearchState.FORWARD]: forward,
		[SearchState.ADVANCE]: advance,
		[SearchState.BACKUP]: backup,
		[SearchState.RECOVER]: recover,
		[SearchState.DONE]: done
	}

	readColumnNames()
	readRows()

	while (running)
		currentStateMethod = stateMethods[currentSearchState]
		currentStateMethod()

	return solutions

module.exports = { search }