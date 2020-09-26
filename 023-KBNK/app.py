N = 64

db = [[[-1] * N for i in range(N)] for j in range(N)]

def ass(a,b):
	if a==b: return
	print('actual',a)
	print('expect',b)
	assert a==b

def sqDist (r1,c1,r2,c2):
	dr = r1-r2
	dc = c1-c2
	return dr*dr+dc*dc
ass(sqDist(1,2,3,4), 8)
ass(sqDist(1,2,1,2), 0)
ass(sqDist(0,0,0,1), 1)
ass(sqDist(0,0,1,1), 2)

def bit(r,c):	return 2**(8*r+c)
ass(bit(0,0), 2**0)
ass(bit(0,7), 2**7)
ass(bit(1,0), 2**8)
ass(bit(7,7), 2**63)

def pretty(mask):
	result = []
	for i in range(N):
		if (2**i) & mask: result.append(i)
	return result
ass(pretty(7), [0,1,2])

class Square:
	def __init__(self,index): # 0..63
		self.index = index
		self.mask = 2 ** index
		self.r = index // 8 # 0..7
		self.c = index % 8 # 0..7

class Position:
	def __init__(self,wk,wr,bk,white): # 0..63 0..63 0..63 True/False
		self.white = white
		self.wk = wk
		self.wr = wr
		self.bk = bk
		self.index = N*N*wk + N*wr + bk # 0..64**3-1

	def legal(self): # forutsätt att vit är vid draget
		if self.wk==self.wr or self.wk==self.bk or self.wr==self.bk: return False
		wkm = self.makeWKMask()
		wrm = self.makeWRMask()
		bkm = self.makeBKMask()
		[wk, wr, bk] = self.getSquares()
		wk1 = wk.mask
		wr1 = wr.mask
		bk1 = bk.mask
		if wk1 & bkm != 0: return False
		if bk1 & wkm != 0: return False # redundant?
		if self.white and bk1 & wrm != 0: return False
		return True

	def board(self):
		b = ['.'] * N
		b[self.wk] = 'K'
		b[self.wr] = 'R'
		b[self.bk] = 'k'
		return b

	def dump(self):
		b = self.board()
		for i in range(8):
			print(' '.join(b[8 * i:8 + 8 * i]))
		print()

	def getSquares(self):
		return [Square(self.wk), Square(self.wr), Square(self.bk)]

	def makeWKMask(self): # which squares can this piece move to?
		[wk, wr, bk] = self.getSquares()
		mask = 0
		for dr in [-1, 0, 1]:
			for dc in [-1, 0, 1]:
				if dr != 0 or dc != 0:
					wkc = wk.c + dc
					wkr = wk.r + dr
					if wkc in range(8) and wkr in range(8) and sqDist(wkr,wkc,bk.r,bk.c) > 2:
						mask |= bit(wkr, wkc)
		return mask

	def makeWRMask(self): # which squares can this piece move to?
		[wk, wr, bk] = self.getSquares()
		mask = 0
		for dr in range(1, 8):
			if wr.r + dr not in [0, 1, 2, 3, 4, 5, 6, 7]: break
			if bit(wr.r + dr, wr.c) == bit(wk.r, wk.c): break
			mask |= bit(wr.r + dr, wr.c)
		for dr in range(-1, -8, -1):
			if wr.r + dr not in [0, 1, 2, 3, 4, 5, 6, 7]: break
			if bit(wr.r + dr, wr.c) == bit(wk.r, wk.c): break
			mask |= bit(wr.r + dr, wr.c)
		for dc in range(1, 8):
			if wr.c + dc not in [0, 1, 2, 3, 4, 5, 6, 7]: break
			if bit(wr.r, wr.c + dc) == bit(wk.r, wk.c): break
			mask |= bit(wr.r, wr.c + dc)
		for dc in range(-1, -8, -1):
			if wr.c + dc not in [0, 1, 2, 3, 4, 5, 6, 7]: break
			if bit(wr.r, wr.c + dc) == bit(wk.r, wk.c): break
			mask |= bit(wr.r, wr.c + dc)
		return mask

	def makeBKMask(self): # which squares can this piece move to?
		[wk, wr, bk] = self.getSquares()
		mask = 0
		for dr in [-1, 0, 1]:
			for dc in [-1, 0, 1]:
				if dr != 0 or dc != 0:
					bkr = bk.r + dr
					bkc = bk.c + dc
					if bkc in range(8) and bkr in range(8) and sqDist(wk.r,wk.c,bkr,bkc) > 2:
						mask |= bit(bkr, bkc)
		return mask

	def mate(self):
		wkm = self.makeWKMask()
		wrm = self.makeWRMask()
		bkm = self.makeBKMask()
		[wk, wr, bk] = self.getSquares()
		wk1 = wk.mask
		wr1 = wr.mask
		bk1 = bk.mask
		if bk1 & (wkm | wrm) == 0: return False
		if bkm & (wkm | wrm) == 0: return False
		return True

#def index(wk,wr,bk): return 64*64*wk + 64*wr + bk
#ass index(16,7,0) == 65984

# cands = []
#
# cands.append(index(17,2,0))
# result = []
#
# def makeZeroRow(wkRow,wrRow,bkRow):
# 	for wkCol in range(8):
# 		for bkCol in range(8):
# 			for wrCol in range(8):
# 				if abs(bkCol-wrCol) >= 2 and abs(bkCol-wkCol) == 0:
# 					result.append(index(8*wkRow+wkCol, 8*wrRow+wrCol, 8*bkRow+bkCol))
#
# def makeZeroCol(wkCol,wrCol,bkCol):
# 	for wkRow in range(8):
# 		for bkRow in range(8):
# 			for wrRow in range(8):
# 				if abs(bkRow-wrRow) >= 2 and abs(bkRow-wkRow) <= 1:
# 					result.append(index(8*wkRow+wkCol, 8*wrRow+wrCol, 8*bkRow+bkCol))
#
#
#
# makeZeroRow(2,0,0)
#makeZeroRow(5,7,7)
#makeZeroCol(2,0,0)
#makeZeroCol(5,7,7)

# print(len(result))

# for pos in result:
# 	dump(pos)

# def getAllPositions(pos):
# 	[wk,wr,bk] = getSquares(pos)
# 	wkCol = wk%8; wkRow = wk//8
# 	wrCol = wr%8; wrRow = wr//8
# 	bkCol = bk%8; bkRow = bk//8
# 	if wrRow==bkRow:
#
#
# cands = []
# for r in result:
# 	cands = cands + getAllPositions(r)

matePos = Position(16,7,0,False)
matePos.dump()
ass(matePos.legal(),True)
ass(matePos.mate(),True)
ass(pretty(matePos.makeWKMask()) , [17,24,25])
ass(pretty(matePos.makeWRMask()) , [0, 1, 2, 3, 4, 5, 6, 15, 23, 31, 39, 47, 55, 63])
#ass(pretty(matePos.makeBKMask()) , [])

pos = Position(16,7,1,False)
pos.dump()
ass(pos.legal(), True)
#ass pos.mate() == False
ass(pretty(matePos.makeWKMask()), [17,24,25])
ass(pretty(matePos.makeWRMask()), [0, 1, 2, 3, 4, 5, 6, 15, 23, 31, 39, 47, 55, 63])
ass(pretty(matePos.makeBKMask()),  [10])
