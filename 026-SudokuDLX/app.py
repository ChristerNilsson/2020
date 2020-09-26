# https://www.cs.mcgill.ca/~aassaf9/python/sudoku.txt
# dict instead of double linked lists

from itertools import product
import time

def solve_sudoku(grid):
    R, C = 3,3
    N = R * C
    X = ([("rc", rc) for rc in product(range(N), range(N))] +
         [("rn", rn) for rn in product(range(N), range(1, N + 1))] +
         [("cn", cn) for cn in product(range(N), range(1, N + 1))] +
         [("bn", bn) for bn in product(range(N), range(1, N + 1))])
    Y = dict()
    for r, c, n in product(range(N), range(N), range(1, N + 1)):
        b = (r // R) * R + (c // C) # Box number
        Y[(r, c, n)] = [
            ("rc", (r, c)),
            ("rn", (r, n)),
            ("cn", (c, n)),
            ("bn", (b, n))]
    X, Y = exact_cover(X, Y)
    # print(X)
    # print(len(X))
    # print(Y)
    # print(len(Y))
    for i, row in enumerate(grid):
        for j, n in enumerate(row):
            if n:
                select(X, Y, (i, j, n))
    for solution in solve(X, Y, []):
        for (r, c, n) in solution:
            grid[r][c] = n
        yield grid

def exact_cover(X, Y):
    X = {j: set() for j in X}
    for i, row in Y.items():
        for j in row:
            X[j].add(i)
    return X, Y

def solve(X, Y, solution):
    if not X:
        yield list(solution)
    else:
        c = min(X, key=lambda c: len(X[c]))
        for r in list(X[c]):
            solution.append(r)
            cols = select(X, Y, r)
            for s in solve(X, Y, solution):
                yield s
            deselect(X, Y, r, cols)
            solution.pop()

def select(X, Y, r):
    cols = []
    for j in Y[r]:
        for i in X[j]:
            for k in Y[i]:
                if k != j:
                  X[k].remove(i)
        cols.append(X.pop(j))
    return cols

def deselect(X, Y, r, cols):
    for j in reversed(Y[r]):
        X[j] = cols.pop()
        for i in X[j]:
            for k in Y[i]:
                if k != j:
                    X[k].add(i)

def trans(arr):
	return [[0 if arr[j][i] in ' 0.' else int(arr[j][i]) for i in range(9)] for j in range(9)]

def tr(s):
	return [[0 if s[i+9*j] in '0.' else int(s[i+9*j]) for i in range(9)] for j in range(9)]

grid = [
	[5, 3, 0, 0, 7, 0, 0, 0, 0],
	[6, 0, 0, 1, 9, 5, 0, 0, 0],
	[0, 9, 8, 0, 0, 0, 0, 6, 0],
	[8, 0, 0, 0, 6, 0, 0, 0, 3],
	[4, 0, 0, 8, 0, 3, 0, 0, 1],
	[7, 0, 0, 0, 2, 0, 0, 0, 6],
	[0, 6, 0, 0, 0, 0, 2, 8, 0],
	[0, 0, 0, 4, 1, 9, 0, 0, 5],
	[0, 0, 0, 0, 8, 0, 0, 7, 9]]

grid = trans([ # 17ms
	'  7  4 26',
	' 9    8 1',
	' 6     7 ',
	'    9    ',
	'   5     ',
	'58 1 6  4',
	'4  9 1  8',
	'  1 7   2',
	'         '
])

grid = trans([ # https://www.7sudoku.com/very-difficult 10 ms
	'   8 1   ',
	' 12  6 7 ',
	' 7 2   85',
	'  5   7 6',
	'7       3',
	'3 6   4  ',
	'56   8 2 ',
	' 9 6  53 ',
	'   7 5   ',
])

grid = trans([ # 12 ms 5 solutions
	'8..6..9.5',
	'.........',
	'....2.31.',
	'..7318.6.',
	'24.....73',
	'.........',
	'..279.1..',
	'5...8..36',
	'..3......'
])

grid = trans([ # 13 ms https://www.free-sudoku.com/sudoku.php?dchoix=evil
	' 8    46 ',
	'5   9    ',
	'    21   ',
	' 6 8  7  ',
	'        1',
	'         ',
	'1 3   2  ',
	'   7   8 ',
	'9        ',
])

#puzzles = [
	#'..53.....8......2..7..1.5..4....53...1..7...6..32...8..6.5....9..4....3......97..', # https://www.youtube.com/watch?v=5E58SrsUcr4&ab_channel=NathanielHansche
	#'.7.25.4..8.....9.3.....3.7.7....4.2.1.......7.4.5....8.9.6.....4.1.....5..7.82.3.', # https://www.youtube.com/watch?v=oPTe52OmMEk&ab_channel=MyLameAnimations
	#'...1.4.....1...8...8.7.3.6.9.7...1.6.........3.4...5.8.5.2.6.3...9...6.....8.5...', # https://www.youtube.com/watch?v=auK3PSZoidc&ab_channel=MITOpenCourseWare
	# '..............3.85..1.2.......5.7.....4...1...9.......5......73..2.1........4...9', # 11
	# '.......12........3..23..4....18....5.6..7.8.......9.....85.....9...4.5..47...6...', # 767 ms
	# '.2..5.7..4..1....68....3...2....8..3.4..2.5.....6...1...2.9.....9......57.4...9..', # 300
	# '........3..1..56...9..4..7......9.5.7.......8.5.4.2....8..2..9...35..1..6........', # 833
	# '12.3....435....1....4........54..2..6...7.........8.9...31..5.......9.7.....6...8', # 241
	# '1.......2.9.4...5...6...7...5.9.3.......7.......85..4.7.....6...3...9.8...2.....1', # 386
	# '.......39.....1..5..3.5.8....8.9...6.7...2...1..4.......9.8..5..2....6..4..7.....', # 365
	# '12.3.....4.....3....3.5......42..5......8...9.6...5.7...15..2......9..6......7..8', # 400
	# '..3..6.8....1..2......7...4..9..8.6..3..4...1.7.2.....3....5.....5...6..98.....5.', # 779
	# '1.......9..67...2..8....4......75.3...5..2....6.3......9....8..6...4...1..25...6.', # 568
	# '..9...4...7.3...2.8...6...71..8....6....1..7.....56...3....5..1.4.....9...2...7..', # 472
	# '....9..5..1.....3...23..7....45...7.8.....2.......64...9..1.....8..6......54....7', #1161
	# '4...3.......6..8..........1....5..9..8....6...7.2........1.27..5.3....4.9........', # 186
	# '7.8...3.....2.1...5.........4.....263...8.......1...9..9.6....4....7.5...........', # 718
	# '3.7.4...........918........4.....7.....16.......25..........38..9....5...2.6.....', # 239
	# '........8..3...4...9..2..6.....79.......612...6.5.2.7...8...5...1.....2.4.5.....3', # 599
	# '.......1.4.........2...........5.4.7..8...3....1.9....3..4..2...5.1........8.6...', #   8
	# '.......12....35......6...7.7.....3.....4..8..1...........12.....8.....4..5....6..', #   9
	# '1.......2.9.4...5...6...7...5.3.4.......6........58.4...2...6...3...9.8.7.......1', # 401
	# '.....1.2.3...4.5.....6....7..2.....1.8..9..3.4.....8..5....2....9..3.4....67.....', # 149
#]
text_file = open("49151.txt", "r")
lines = text_file.read().splitlines()
text_file.close()
puzzles = [line for line in lines]
#print(puzzles)

start = time.time()
for i in range(1):
	puzzle = puzzles[i]
	grid = tr(puzzle)
	#print(grid)

	for solution in solve_sudoku(grid):
		pass
		#print(*solution, sep='\n')
		#print()
	print(time.time()-start,i)

