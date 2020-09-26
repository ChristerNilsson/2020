range = _.range

SQ = []

for f in 'abcdefgh'
	for r in '12345678'
		SQ.push f+r

chess = new Chess()
# console.log chess

# while not chess.game_over()
# 	moves = chess.moves()
# 	move = _.sample moves
# 	console.log moves
# 	chess.move move
# 	#console.log chess.ascii()
# console.log chess.pgn()

distSq = (a,b) ->
	dx = a//8 - b//8
	dy = a%8 - b%8	
	dx*dx + dy*dy

getMoves = (wk,wr,bk) ->
	chess.clear()
	chess.put {type:'k', color:'w'}, SQ[wk]
	chess.put {type:'r', color:'w'}, SQ[wr]
	chess.put {type:'k', color:'b'}, SQ[bk]
	console.log chess.ascii()
	white = ''
	black = ''
	if chess.load(chess.fen()) # and not chess.in_check()
		white = chess.moves().join ' '
		if 'x' in white then white = ''
	if chess.load chess.fen().replace 'w','b'
		black = chess.moves().join ' '
	[white,black]

checkMate = (wk,wr,bk) ->
	chess.clear()
	chess.put {type:'k', color:'w'}, SQ[wk]
	chess.put {type:'r', color:'w'}, SQ[wr]
	chess.put {type:'k', color:'b'}, SQ[bk]
	if chess.load chess.fen().replace 'w','b'
		chess.in_checkmate()
	else false

#console.log getMoves 'e1 a1 e8','b'
#console.log chess.moves()
#console.log chess.ascii()

index = (wk,wr,bk) -> 64*64*wk + 64*wr + bk

getZero = ->
	result = []
	for wk in range 64
		for wr in range 64
			for bk in range 64
				if 2 >= distSq wk,bk then continue
				if wk == wr then continue
				if bk == wr then continue
				if checkMate wk,wr,bk
					result.push index wk,wr,bk
	result

expand = (front) ->
	result = []
	for wk in range 64
		for wr in range 64
			for bk in range 64
				if 2 >= distSq wk,bk then continue
				if wk == wr then continue
				if bk == wr then continue
				i = index wk,wr,bk
				if i in front
					result.push i
	result

zero = getZero()
console.log zero

console.log expand zero