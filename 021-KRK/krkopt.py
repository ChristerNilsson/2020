import json

NUMBERS = 'draw zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen'.split(' ')

def rowcol (file,rank): return ['abcdefgh'.index(file),'12345678'.index(rank)]

def makeKey(lst):	return ''.join(['abcdefgh'[item[0]] + '12345678'[item[1]] for item in lst])
assert makeKey([[1, 0], [6, 6], [6, 4]]) == 'b1g7g5'

def rotate(lst):return [[7-item[1],item[0]] for item in lst]
assert rotate([[1, 0], [6, 6], [6, 5]]) == [[7, 1], [1, 6], [2, 6]]
assert rotate([[7, 1], [1, 6], [2, 6]]) == [[6, 7], [1, 1], [1, 2]]
assert rotate([[6, 7], [1, 1], [1, 2]]) == [[0, 6], [6, 1], [5, 1]]
assert rotate([[0, 6], [6, 1], [5, 1]]) == [[1, 0], [6, 6], [6, 5]]

def mirror(lst): return [[item[1], item[0]] for item in lst]
assert mirror([[1, 0], [6, 6], [6, 5]]) == [[0, 1], [6, 6], [5, 6]]
assert mirror([[0, 1], [6, 6], [5, 6]]) == [[1, 0], [6, 6], [6, 5]]

db = {}

with open('krkopt.data') as lines:
	for line in lines:
		lst = []
		arr = line.rstrip().split(',')
		wk = rowcol(arr[0],arr[1])
		wr = rowcol(arr[2],arr[3])
		bk = rowcol(arr[4],arr[5])
		count = NUMBERS.index(arr[6])-1
		pos1 = [wk,wr,bk]
		pos2 = mirror(pos1)
		for i in range(4):
			db[makeKey(pos1)] = count
			db[makeKey(pos2)] = count
			pos1 = rotate(pos1)
			pos2 = rotate(pos2)
	print(len(db))

with open('krkopt.json','w') as lines:
	json.dump(db,lines)
