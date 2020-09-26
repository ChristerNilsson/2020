# 1+0 • BULLET • RATED
# 30 hours ago
# NumaKarlsson
# 822 +6
# ShadyAladm
# 804 -5
# Time out, White is victorious
# C20 King's Pawn Game: Napoleon Attack
# 1. e4 e5 2. Qf3 Nc6 3. Bc4 Nf6 ... 19 moves

# Slutsatser:
# Numa har spelat 78% av partierna med Qf3 eller Qf6 i andra draget. (135/173)
# Av dessa har Numa vunnit 40% (54/135)

def getint(s):
	s = s.replace('?',' ')
	s = s.split(' ')
	return int(s[0])

with open('Lichess.txt') as f:
	lines = f.read().split('\n')
	i = 0

	whiteWin = 0
	whiteLoss = 0
	whiteDraw = 0

	blackWin = 0
	blackLoss = 0
	blackDraw = 0

	otherWin = 0
	otherLoss = 0
	otherDraw = 0

	while i < len(lines):
		line = lines[i]
		if line.find('RATED') >= 0:
			white = lines[i+2]
			wr = getint(lines[i+3])
			black = lines[i+4]
			br = getint(lines[i+5])
			result = lines[i+6]
			moves = lines[i+8]

			if white == 'NumaKarlsson' and moves.find('2. Qf3') >= 0:
				if result.find('White is victorious') >= 0: whiteWin += 1
				elif result.find('Black is victorious') >= 0: whiteLoss += 1
				else: whiteDraw += 1

			elif black == 'NumaKarlsson' and moves.find('Qf6 3.') >= 0:
				if result.find('Black is victorious') >= 0: blackWin += 1
				elif result.find('White is victorious') >= 0: blackLoss += 1
				else: blackDraw += 1

			else:
				if white == 'NumaKarlsson':
					if result.find('White is victorious') >= 0: otherWin += 1
					elif result.find('Black is victorious') >= 0:otherLoss += 1
					else: otherDraw += 1

				elif black == 'NumaKarlsson':
					if result.find('Black is victorious') >= 0: otherWin += 1
					elif result.find('White is victorious') >= 0:otherLoss += 1
					else: otherDraw += 1

		i += 1

	print('White',whiteWin,whiteDraw,whiteLoss)
	print('Black',blackWin,blackDraw,blackLoss)
	print('Other',otherWin,otherDraw,otherLoss)
