# Queens DLX

range = (b) -> [0...b] 
encode = (x) ->	x #"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"[x]

execute = (n) ->
	n = parseInt n
	result = []
	result.push "| This data produced by queens-dlx #{n}"

	s = "" 
	for j in range n
		t = (if j&1 then n-1-j else n+j) >> 1
		s += "r#{encode t} c#{encode t} "
	
	s += "|"
	for j in range n+n-2
		s += " a#{encode j} b#{encode j}"
	result.push s

	for j in range n 
		for k in range n
			key = "r#{encode(j)}c#{encode(k)}"
			s = "#{key} r#{encode j} c#{encode k}"
			t = j + k
			if t < n+n-2 then s += " a#{encode t}"
			t = n-1-j+k
			if t < n+n-2 then s += " b#{encode t}"
			result.push s
	
	console.log result.join "\n"

if process.argv.length == 3
	execute process.argv[2]
else
	execute 8
