constraints = null
snapshots = null
current = 1

explanations = []
explanations.push 'All primary columns and rows have 8 options. Item CA is chosen. Option a1 is first'
explanations.push 'Items CA and R1 is hidden. All remaining columns and rows have 6 legal options. Item CB is chosen. Option b3 is selected'
explanations.push 'Items CB and R3 is hidden. Shortest item is CC. Option c5 is selected'
explanations.push 'Items CC and R5 is hidden. Shortest item is CF. Option f4 is selected'
explanations.push 'Items CF and R4 is hidden. Shortest item is CH. Option h7 is selected'
explanations.push 'Items CH and R7 is hidden. Shortest item is CH. R6 is empty, h7 is backtracked'
explanations.push 'Continue'
explanations.push "Option f4 can't be replaced. f4 is backtracked"
explanations.push 'Continue'
explanations.push "Option c5 replaced by c6"

setColor = (item, options) -> 
	#console.log item,'x',options
	fill if options.includes item then 'black' else 'red'

drawChessBoard = () ->
	R = 50
	x = width/2-4*R
	y = height/2-R
	for i in range 8
		for j in range 8
			fill if (i+j)%2==0 then 'white' else 'black'
			rect x+R*(i),y+R*(j),R,R
	fill 'green'
	textSize 24
	choices = snapshots[current].choices.trim().split ' '
	for c,index in choices
		if c=='' then continue
		#console.log c
		i = 0.5 + 'abcdefgh'.indexOf c[0]
		j = 8 - 0.5 - '12345678'.indexOf c[1]
		#console.log i,j
		#fill 'green'
		stroke 'black'
		fill if index == choices.length-1 then 'yellow' else 'green'
		circle x+R*i,y+R*j,0.4*R
		noStroke()
		fill if index == choices.length-1 then 'green' else 'yellow'
		text c,x+R*i,y+R*j

preload = ->
	fetch "8queens.json"
		.then (response) => response.json() 
		.then (json) => 
			{constraints,snapshots} = json
			console.log json
			xdraw()

setup = ->
	createCanvas 1200,750

drawOptions = (prompt,offset,w,a,b) ->

	textAlign LEFT,CENTER
	fill 'yellow'
	noStroke()
	text prompt,offset+25*0.7,50

	stroke 'yellow'
	line offset+25*0.7,60,offset+w+10,60
	line offset+25*0.7,60,offset+w+10,60
	noStroke()

	i=0
	textAlign CENTER,CENTER
	for key,option of a
		option = option.split ' '
		fill 'yellow'
		text key,offset+25+25*i,50+25
		#fill 'black'
		#text option.length,offset+25+25*i,50+25+25
	
		if key of b
			for item,j in option
				if b 
					setColor item,b[key]
				else
					fill 'black'
				text item,offset+25+25*i,100+25*j
		else
			fill 'red'
			for item,j in option
				text item,offset+25+25*i,100+25*j
		i++


showChoices = (snapshot) ->
	fill 'white'
	stroke 'black'
	for i in range 8
		rect 20+40*i,10,40,30
	noStroke()
	fill 'black'
	textAlign CENTER,CENTER
	for c,i in snapshots[current].choices.trim().split ' '
		text c,40+40*i,28

xdraw = ->
	bg 0.5
	if not constraints then return
	items = constraints.primaries.concat constraints.secondaries

	textSize 14
	textAlign CENTER,CENTER
	fill 'yellow'

	a = snapshots[current-1]
	b = snapshots[current]
	ap = if a then a.primaries else {}
	ax = if a then a.secondaries else {}
	bp = if b then b.primaries else {}
	bx = if b then b.secondaries else {}

	drawOptions 'primary items',  0*25,  16*25, ap,bp
	drawOptions 'secondary items',16*25, 30*25, ax,bx

	drawChessBoard()

	snapshot = b
	fill 'black'
	textSize 32
	if snapshot
		showChoices()
		textAlign CENTER,CENTER
		text snapshot.action,width/2,25
	textAlign RIGHT,CENTER
	text "#{current-1} of #{snapshots.length-2} snapshots",width-40,25

	textAlign LEFT,CENTER
	textSize 14
	fill 'white'
	text explanations[current],15,100+8*25

keyPressed = ->
	if key=='ArrowLeft' then current--
	if key=='ArrowRight' then current++
	if current < 1 then current = 1
	if current >= snapshots.length then current = snapshots.length-1
	xdraw()
