{makeData, search, getSearchConfig, findOne} = require './dlx'
{execute} = require './sudoku-dlx' 

console.time 'readFile'
fs = require "fs"
lines = fs.readFileSync(0).toString()
console.timeEnd 'readFile'

console.time 'solve'
for line in lines.split '\n'
	#console.log line
	data = execute line
	#console.log data
	constraints = makeData data
	console.log 'constraints',constraints

	#console.log JSON.stringify getSearchConfig 1,constraints
	oneSolution = findOne constraints
	#console.log oneSolution
console.timeEnd 'solve'
