range = _.range

moves = 'Kf6 Nf7 Bf5 Kf8 Bh7 Ke8 Ke6 Kf8 Kf6 Ke8 Ne5 Kd8 Ke6 Kc7 Nd7 Kb7 Bd3 Kc6 Bc4 Kc7 Bd5 Kd8 Kd6 Ke8 Be6 Kd8 Bf7 Kc8 Nc5 Kd8 Nb7 Kc8 Kc6 Kb8 Kb6 Kc8 Be6 Kb8 Nc5 Ka8 Bf5 Kb8 Na6 Ka8 Be4'.split ' '
dump = []

index = 0 

COLORS = {K:'#000',W:'#fff',R:'#f00',G:'#0f0',D:'#330',L:'#660'}

WK = [-1,-1]
WN = [-1,-1]
WB = [-1,-1]
BK = [-1,-1]

setup = () ->
	dump.push "# White Mates with Bishop (green) and Knight (red)"
	dump.push 'D = (48,48,0)'
	dump.push 'L = (96,96,0)'
	dump.push 'a = Animation()'
	createCanvas 400,400
	frameRate 100
	for i in range 8
		for j in range 8
			if (i+j)%2 == 0 then color = "D" else color = "L"
			fill COLORS[color]
			rect 50*i,50*j,50,50
	for i in range 4
		dump.push "m[#{2*i+0}] = [D,L,D,L,D,L,D,L]"
		dump.push "m[#{2*i+1}] = [L,D,L,D,L,D,L,D]"
	dump.push 'a.add_frame(m,2000)'
			
paint = (piece,file,rank,color) ->
	[x,y] = piece
	if x != -1 # remove old piece
		if (x+y)%2 == 0 then bgcol = "D" else bgcol = "L"
		fill COLORS[bgcol]
		dump.push "m[#{x}][#{y}] = #{bgcol}"
		rect 50*x,50*y,50,50

	# put new piece
	fill COLORS[color]
	rect 50*file,50*rank,50,50
	dump.push "m[#{file}][#{rank}] = #{color}"
	dump.push 'a.add_frame(m,2000)'
	[file,rank]

draw = () ->
	index = frameCount-1
	if index >= moves.length then return
	move = moves[index]
	piece = move[0]
	file = 'abcdefgh'.indexOf move[1]
	rank = 7-'12345678'.indexOf move[2]
	if piece == 'K' and index%2==0 then WK = paint WK,file,rank,'W'
	if piece == 'K' and index%2==1 then BK = paint BK,file,rank,'K'
	if piece == 'N' then WN = paint WN,file,rank,'R'
	if piece == 'B' then WB = paint WB,file,rank,'G'
	if index == moves.length-1 then console.log dump.join '\n'
