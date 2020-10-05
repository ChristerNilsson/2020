#import Constraint  from './interfaces'
#import Row from './interfaces'
# import isSimpleConstraint from './interfaces'
# import isComplexConstraint from './interfaces'
#import SearchConfig  from './interfaces'

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
	sparseConstraints: Row<T>[] = constraints.map((c) => 
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

	return {
		numPrimary,
		numSecondary,
		numSolutions,
		rows: sparseConstraints
	}