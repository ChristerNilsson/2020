# Queens DLX

range = (b) -> [0...b]
ENCODE = (i) ->	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"[i]
encode = (i) ->	"abcdefghijklmnopqrstuvwxyz"[i]

execute = (n='8') ->
	n = parseInt n
	result = {}
	result.header = "This data produced by queens-dlx #{n}"

	cx = ("C#{ENCODE i}" for i in range n)
	rx = ("R#{j+1}" for j in range n)
	result.primaries = (cx.concat rx).join ' '
	
	ax = ("A#{ENCODE i}" for i in range n+n-1)
	bx = ("B#{ENCODE i}" for i in range n+n-1)
	result.secondaries = (ax.concat bx).join ' '

	options = []
	for i in range n
		for j in range n
			key = "#{encode(i)}#{j+1}"
			options.push "#{key} C#{ENCODE i} R#{j+1} A#{ENCODE i+j} B#{ENCODE n-1-i+j}"
	result.options = options
	console.log result
	result

module.exports = {execute}
