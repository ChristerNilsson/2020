setup = ->
	S = 36*1.055
	W = 19
	H = 27
	c = createCanvas W*S+1,H*S+1
	bg 1
	sc 0

	fc 0.9
	sc()
	for i in range 2*W+1
		for j in range 2*H+1
			if (i+j)%2==0 then rect S/2*i,S/2*j,S/2,S/2

	sc 0
	for i in range W+1
		line S*i,0,S*i,H*S
	for j in range H+1
		line 0,S*j,W*S,S*j
	saveCanvas c, 'lattice', 'bmp'
