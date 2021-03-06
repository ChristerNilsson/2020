BB_KNIGHT = [0] * 64
BB_KING = [0] * 64
BB_ROOK = [0] * 64
BB_BISHOP = [0] * 64
BB_QUEEN = [0] * 64

ATTACK_BISHOP = [0] * 5248
ATTACK_ROOK = [0] * 102400

OFFSET_BISHOP = [0] * 64
OFFSET_ROOK = [0] * 64

MAGIC_BISHOP = [
    0x010a0a1023020080, 0x0050100083024000, 0x8826083200800802,
    0x0102408100002400, 0x0414242008000000, 0x0414242008000000,
    0x0804230108200880, 0x0088840101012000, 0x0400420202041100,
    0x0400420202041100, 0x1100300082084211, 0x0000124081000000,
    0x0405040308000411, 0x01000110089c1008, 0x0030108805101224,
    0x0010808041101000, 0x2410002102020800, 0x0010202004098180,
    0x1104000808001010, 0x274802008a044000, 0x1400884400a00000,
    0x0082000048260804, 0x4004840500882043, 0x0081001040680440,
    0x4282180040080888, 0x0044200002080108, 0x2404c80a04002400,
    0x2020808028020002, 0x0129010050304000, 0x0008020108430092,
    0x005600450c884800, 0x005600450c884800, 0x001004501c200301,
    0xa408025880100100, 0x1042080300060a00, 0x4100a00801110050,
    0x11240100c40c0040, 0x24a0281141188040, 0x08100c4081030880,
    0x020c310201002088, 0x006401884600c280, 0x1204028210809888,
    0x8000a01402005002, 0x041d8a021a000400, 0x041d8a021a000400,
    0x000201a102004102, 0x0408010842041282, 0x000201a102004102,
    0x0804230108200880, 0x0804230108200880, 0x8001010402090010,
    0x0008000042020080, 0x4200012002440000, 0x80084010228880a0,
    0x4244049014052040, 0x0050100083024000, 0x0088840101012000,
    0x0010808041101000, 0x1090c00110511001, 0x2124000208420208,
    0x0800102118030400, 0x0010202120024080, 0x00024a4208221410,
    0x010a0a1023020080
]

MAGIC_ROOK = [
    0x0080004000608010, 0x2240100040012002, 0x008008a000841000,
    0x0100204900500004, 0x020008200200100c, 0x40800c0080020003,
    0x0080018002000100, 0x4200042040820d04, 0x10208008a8400480,
    0x4064402010024000, 0x2181002000c10212, 0x5101000850002100,
    0x0010800400080081, 0x0012000200300815, 0x060200080e002401,
    0x4282000420944201, 0x1040208000400091, 0x0010004040002008,
    0x0082020020804011, 0x0005420010220208, 0x8010510018010004,
    0x05050100088a1400, 0x0009008080020001, 0x2001060000408c01,
    0x0060400280008024, 0x9810401180200382, 0x0200201200420080,
    0x0280300100210048, 0x0000080080800400, 0x0002010200081004,
    0x8089000900040200, 0x0040008200340047, 0x0400884010800061,
    0xc202401000402000, 0x0800401301002004, 0x4c43502042000a00,
    0x0004a80082800400, 0xd804040080800200, 0x060200080e002401,
    0x0203216082000104, 0x0000804000308000, 0x004008100020a000,
    0x1001208042020012, 0x0400220088420010, 0x8010510018010004,
    0x8009000214010048, 0x6445006200130004, 0x000a008402460003,
    0x0080044014200240, 0x0040012182411500, 0x0003102001430100,
    0x4c43502042000a00, 0x1008000400288080, 0x0806003008040200,
    0x4200020801304400, 0x8100640912804a00, 0x300300a043168001,
    0x0106610218400081, 0x008200c008108022, 0x0201041861017001,
    0x00020010200884e2, 0x0205000e18440001, 0x202008104a08810c,
    0x800a208440230402
]

SHIFT_BISHOP = [
    58, 59, 59, 59, 59, 59, 59, 58,
    59, 59, 59, 59, 59, 59, 59, 59,
    59, 59, 57, 57, 57, 57, 59, 59,
    59, 59, 57, 55, 55, 57, 59, 59,
    59, 59, 57, 55, 55, 57, 59, 59,
    59, 59, 57, 57, 57, 57, 59, 59,
    59, 59, 59, 59, 59, 59, 59, 59,
    58, 59, 59, 59, 59, 59, 59, 58
]

SHIFT_ROOK = [
    52, 53, 53, 53, 53, 53, 53, 52,
    53, 54, 54, 54, 54, 54, 54, 53,
    53, 54, 54, 54, 54, 54, 54, 53,
    53, 54, 54, 54, 54, 54, 54, 53,
    53, 54, 54, 54, 54, 54, 54, 53,
    53, 54, 54, 54, 54, 54, 54, 53,
    53, 54, 54, 54, 54, 54, 54, 53,
    52, 53, 53, 53, 53, 53, 53, 52
]

def BIT(n): return 1 << n
def RF(r,f): return 8*r+f

def dump(i,n):
	for r in range(8):
		s=''
		for f in range(8):
			index = RF(r,f)
			if i==index: s+='o'
			elif 1<<index & n == 0: s += '.'
			else: s += 'x'
			s += ' '
		print(s)
	print()

def bb_slide(sq, truncate, obstacles, directions):
	value = 0
	rank = sq // 8
	file = sq % 8
	for dir in directions:
		previous = 0
		for n in range(1,9):
			r = rank + dir[0] * n
			f = file + dir[1] * n
			if r < 0 or f < 0 or r > 7 or f > 7:
				if truncate: value &= ~previous
				break

			bit = BIT(RF(r, f))
			value |= bit
			if bit & obstacles:
				break
			previous = bit
	return value

def bb_slide_rook(sq,truncate,obstacles):
	directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
	return bb_slide(sq, truncate, obstacles, directions)

def bb_slide_bishop(sq,truncate,obstacles):
	directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
	return bb_slide(sq, truncate, obstacles, directions)

def init_rook():
	for sq in range(64):
		BB_ROOK[sq] = bb_slide_rook(sq, 0, 0)

def init_bishop():
	for sq in range(64):
		BB_BISHOP[sq] = bb_slide_bishop(sq, 0, 0)

def init_queen():
	for sq in range(64):
		BB_QUEEN[sq] = bb_slide_rook(sq, 0, 0) | bb_slide_bishop(sq, 0, 0)

def init_king():
	offsets = [[-1,-1], [ 0,-1], [1,-1], [-1,0], [1,0],[-1,1], [0,1], [1,1]]
	for rank in range(8):
		for file in range(8):
			value = 0
			for [dr,df] in offsets:
				r = rank + dr
				f = file + df
				if 0 <= r < 8 and 0 <= f < 8: value |= BIT(RF(r, f))
			BB_KING[RF(rank, file)] = value

def init_knight():
	offsets = [[-2, -1], [-2, 1], [2, -1], [2, 1],[-1, -2], [-1, 2], [1, -2], [1, 2]]
	for rank in range(8):
		for file in range(8):
			value = 0
			for [dr,df] in offsets:
				r = rank + dr
				f = file + df
				if 0 <= r < 8 and 0 <= f < 8: value |= BIT(RF(r, f))
			BB_KNIGHT[RF(rank, file)] = value

def bb_bishop(sq, obstacles):
	value = obstacles & BB_BISHOP[sq]
	index = (value * MAGIC_BISHOP[sq]) >> SHIFT_BISHOP[sq]
	return ATTACK_BISHOP[index + OFFSET_BISHOP[sq]]

def bb_rook(sq, obstacles):
	value = obstacles & BB_ROOK[sq]
	index = (value * MAGIC_ROOK[sq]) >> SHIFT_ROOK[sq]
	return ATTACK_ROOK[index + OFFSET_ROOK[sq]]

def bb_queen(sq, obstacles): return bb_bishop(sq, obstacles) | bb_rook(sq, obstacles)

def gen_king_moves(srcs, mask):
	moves = []
	for src in range(64):
		if srcs & BIT(src) != 0:
			dsts = BB_KING[src] & mask
			for dst in range(64):
				if dsts & BIT(dst) != 0:
					moves.append([src,dst])
	return moves

def gen_rook_moves(srcs, mask):
	moves = []
	for src in range(64):
		if srcs & BIT(src) != 0:
			dsts = bb_rook(src) & mask
			for dst in range(64):
				if dsts & BIT(dst) != 0:
					moves.append([src,dst])
	return moves

def bb_squares(value, squares):
	i = 0
	for sq in range(64):
		if BIT(sq) & value:
			squares[i] = sq
			i += 1
	return i

squares = [0] * 64

def make_ATTACK_BISHOP():
	offset = 0
	for sq in range(64):
		count = bb_squares(BB_BISHOP[sq], squares)
		n = 1 << count
		for i in range(n):
			obstacles = 0
			for j in range(count):
				if i & (1 << j) :
					obstacles |= BIT(squares[j])

			value = bb_slide_bishop(sq, 0, obstacles)
			index = (obstacles * MAGIC_BISHOP[sq]) >> SHIFT_BISHOP[sq]
			previous = ATTACK_BISHOP[offset + index]
			if (previous and previous != value) :
				print("ERROR: invalid ATTACK_BISHOP table\n")
			ATTACK_BISHOP[offset + index] = value
		OFFSET_BISHOP[sq] = offset
		offset += 1 << (64 - SHIFT_BISHOP[sq])

def make_ATTACK_ROOK():
	offset = 0
	for sq in range(64):
		count = bb_squares(BB_ROOK[sq], squares)
		n = 1 << count
		for i in range(n):
			obstacles = 0
			for j in range(count):
				if i & (1 << j) :
					obstacles |= BIT(squares[j])

			value = bb_slide_rook(sq, 0, obstacles)
			index = (obstacles * MAGIC_ROOK[sq]) >> SHIFT_ROOK[sq]
			previous = ATTACK_ROOK[offset + index]
			if (previous != 0 and previous != value) :
				print("ERROR: invalid ATTACK_ROOK table\n")
			ATTACK_ROOK[offset + index] = value
		OFFSET_ROOK[sq] = offset
		offset += 1 << (64 - SHIFT_ROOK[sq])




init_rook()
moves = gen_king_moves(BIT(9),0)
#print(moves)
make_ATTACK_ROOK()
for i in range(64):
#	dump(i,BB_KING[i])
	dump(i,ATTACK_ROOK[i])
