{makeData, search, getSearchConfig, findAll, findOne} = require './dlx'
{execute} = require './queens-dlx' 
fs = require 'fs'

console.time 'cpu'
n = 8
if process.argv.length == 3 then n = process.argv[2]
data = execute n
#console.log data
constraints = makeData data
#console.log constraints

#console.log JSON.stringify getSearchConfig 1,constraints
{solutions,snapshots} = findOne constraints
# console.timeEnd 'cpu'
#console.log snapshots
fs.writeFileSync '8queens.json', JSON.stringify {constraints, snapshots}
if solutions.length<=92 then console.log solutions