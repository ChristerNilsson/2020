# 343 s instead of 16 in javascript. Boring.
# julia --optimize=3 sudoku.js

using OffsetArrays,DataStructures
using CPUTime

TRACE = false

function zero(n, default=0)
	#arr = Array{Int}(default,n)
	arr = Int64[]
	push!(arr,default)
	OffsetArray(repeat(arr,n), 0:n-1)
end

BLOCK     = zero(81)
BLOCK_NDX = zero(81)
N_BIT     = zero(512)
ZERO      = zero(512)
BIT       = zero(512)

count = 0
m = zero(81)
col = zero(9) # 9 bit patterns
row = zero(9) # 9 bit patterns
blk = zero(9) # 9 bit patterns

perf = Dict()

output = []

function range(n) 
	0:n-1
end

function trace(prompt,level,s) 
	println(prompt + repeat(' ',level) + s)
	output.push(prompt + repeat(' ',level) + s)
	perf[prompt] += 1
end

function make()
	for x in range(512)
		s = 0
		for n in range(9)
			s += x >> n & 1
		end
		N_BIT[x] = s 
		ZERO[x] = ~x & -~x
	end

	for x in range(9)
		BIT[1 << x] = x
	end

	for y in range(9)
		for x in range(9)
			ptr = 9 * y + x
			BLOCK[ptr] = (y ÷ 3) * 3 + (x ÷ 3)
			BLOCK_NDX[ptr] = (y % 3) * 3 + x % 3
		end
	end

end

function solve(p)
	perf = Dict("play " => 0, "undo " => 0, "guess" => 0, "ungue" => 0)
	count = 81
	row = zero(9)
	col = zero(9)
	blk = zero(9)
	m = zero(81,-1)

	# convert the puzzle into our own format
	for y in range(9)
		for x in range(9)
			index = 9 * y + x
			ch = p[index+1]
			if ch=='.' 
				ch='0'
			end
			digit = parse(Int, ch) - 1
			if digit >= 0
				msk = 1 << digit
				col[x] |= msk
				row[y] |= msk
				blk[BLOCK[index]] |= msk
				count -= 1
				m[index] = digit
			end
		end
	end

	# helper function to check and play a move
	function play(level, stack, x, y, n)
		p = y * 9 + x

		if m[p] != -1
			if m[p] == n
				return true
			end
			undo(level,stack)
			return false
		end
		
		msk = 1 << n
		b = BLOCK[p]

		if ((col[x] | row[y] | blk[b]) & msk) > 0
			undo(level,stack)
			return false
		end

		count -= 1
		col[x] ⊻= msk
		row[y] ⊻= msk
		blk[b] ⊻= msk
		m[p] = n
		push!(stack,x << 8 | y << 4 | n)

		#if TRACE trace("play ",level, "#{81-count} #{x} #{y} #{n}")

		return true
	end

	function undo(level,stack)  
		# helper function to undo all moves on the stack
		for v in stack
			x = v >> 8
			y = v >> 4 & 15
			index = y * 9 + x
			b = BLOCK[index]
	
			#if TRACE trace("undo ", level, "#{81-count} #{x} #{y} #{v & 15}")
	
			msk = 1 << (v & 15)
	
			count += 1
			col[x] ⊻= msk
			row[y] ⊻= msk
			blk[b] ⊻= msk
			m[index] = -1
		end
	end
	
	function search(level=0) # main recursive search function
		if count == 0
			return true
		end

		max = 0
		best = nothing
		stack = Stack{Int}()

		dCol = zero(81)
		dRow = zero(81)
		dBlk = zero(81)
		
		# scan the grid:
		# - keeping track of where each digit can go on a given column, row or block
		# - looking for a cell with the fewest number of legal moves
		for y in range(9)
			for x in range(9)
				ptr = 9 * y + x
				if m[ptr] == -1
					v = col[x] | row[y] | blk[BLOCK[ptr]]
					n = N_BIT[v]
					#abort if there's no legal move on this cell
					if n == 9 
						return false
					end
					
					v0 = v ⊻ 0x1FF
					while true
						b = v0 & -v0
						dCol[x * 9 + BIT[b]] |= 1 << y
						dRow[y * 9 + BIT[b]] |= 1 << x
						dBlk[BLOCK[ptr] * 9 + BIT[b]] |= 1 << BLOCK_NDX[ptr]
						v0 ⊻= b
						if v0 == 0 
							break 
						end # if
					end # while
					
					if n > max
						best = Dict("x" => x, "y" => y, "ptr" => ptr, "msk" => v)
						max = n
					end # if
				end # if
			end # for x 
		end # for y

		# play all forced moves (unique candidates on a given column, row or block)
		# and make sure that it doesn't lead to any inconsistency
		for k in range(9)
			for n in range(9)
				ptr = k * 9 + n
				if N_BIT[dCol[ptr]] == 1
					i = BIT[dCol[ptr]]
					if !play(level,stack, k, i, n) 
						return false
					end
				end

				if N_BIT[dRow[ptr]] == 1
					i = BIT[dRow[ptr]]
					if !play(level,stack, i, k, n) 
						return false
					end
				end

				if N_BIT[dBlk[ptr]] == 1
					i = BIT[dBlk[ptr]]
					if !play(level,stack, (k % 3) * 3 + i % 3, (k ÷ 3) * 3 + (i ÷ 3), n) 
						return false
					end
				end
			end
		end

		# if we've played at least one forced move, do a recursive call right away
		if length(stack) > 0
			if search(level+1)
				return true
			end
			undo(level,stack)
			return false
		end

		# otherwise, try all moves on the cell with the fewest number of moves
		while (msk = ZERO[best["msk"]]) < 512
			col[best["x"]] ⊻= msk
			row[best["y"]] ⊻= msk
			blk[BLOCK[best["ptr"]]] ⊻= msk
			m[best["ptr"]] = BIT[msk] #- 1
			count -= 1

			#if TRACE trace("guess", level, "#{81-count} #{best.x} #{best.y} #{BIT[msk]}")
			if search(level+1)
				return true
			end
			#if TRACE trace("ungue", level, "#{81-count} #{best.x} #{best.y} #{BIT[msk]}")
			
			count += 1
			m[best["ptr"]] = -1
			col[best["x"]] ⊻= msk
			row[best["y"]] ⊻= msk
			blk[BLOCK[best["ptr"]]] ⊻= msk

			best["msk"] ⊻= msk
		end # while
		
		return false
	end # search

	xres = search()
	if xres
		return join(map(function (n) n+1 end, m))
	else
		return false 
	end

end # solve

make()

function execute(puzzles)

	output = [] 

	# solve all puzzles
	for i in 0:length(puzzles)-1
		puzzle = puzzles[i+1]
		if length(puzzle) < 81 
			continue
		end
		puzzle = puzzle[1:81]
		res = solve(puzzle)
		#println(puzzle)
		#println(res)

		if TRACE 
			println(perf)
		end
		#i += 1
		if i % 2000 == 0
			println(i)
		end
	end
end

filename = "all_17" #process.argv[2]
println("File $filename: ")
puzzles = []
open(filename) do f
	puzzles = readlines(f)
	len = puzzles[1]
	deleteat!(puzzles,0+1)
	@time @CPUtime execute(puzzles)
end

