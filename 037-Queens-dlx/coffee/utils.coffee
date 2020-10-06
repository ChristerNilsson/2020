range = (n) -> [0...n]

isSimpleConstraint = (arg) -> return arg.row != undefined
isComplexConstraint = (arg) -> return arg.primaryRow != undefined and arg.secondaryRow != undefined

binaryToSparseRow  = (binaryRow, offset = 0) ->
	sparseRow = []
	for i in range binaryRow.length
		if binaryRow[i] == 1
			sparseRow.push(i + offset)
	return sparseRow

getParams  = (constraint) ->
	numPrimary = 0
	numSecondary = 0

	if (isSimpleConstraint(constraint)) 
		numPrimary = constraint.row.length
	else if (isComplexConstraint(constraint)) 
		numPrimary = constraint.primaryRow.length
		numSecondary = constraint.secondaryRow.length

	return {
		numPrimary,
		numSecondary
	}

getSearchConfig = (numSolutions, constraints) ->
	{ numPrimary, numSecondary } = getParams(constraints[0])
	start = new Date()
	sparseConstraints = constraints.map((c) => 
		data = c.data
		coveredColumns= []
		if (isSimpleConstraint(c)) 
			coveredColumns = binaryToSparseRow(c.row)
		else if (isComplexConstraint(c)) 
			coveredColumns = binaryToSparseRow(c.primaryRow).concat(binaryToSparseRow(c.secondaryRow, numPrimary))

		return {
			data,
			coveredColumns
		}
	)
	console.log 'getSearchConfig',(new Date())-start

	return {
		numPrimary,
		numSecondary,
		numSolutions,
		rows: sparseConstraints
	}

module.exports = {getSearchConfig, range}