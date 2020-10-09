constraints = null
snapshots = null
current = 0

explanations = []
explanations.push 'There are 16 primary items, 8 columns and 8 rows\nItem CA is chosen\nOption a1 is first\nPress Right Arrow'
explanations.push 'Items CA and R1 are hidden\nItem CB is chosen\nOption b3 is selected'
explanations.push 'Items CB and R3 are hidden\nShortest item is CC\nOption c5 is selected'
explanations.push 'Items CC and R5 are hidden\nShortest item is CF\nOption f4 is selected'
explanations.push 'Items CF and R4 are hidden\nShortest item is CH\nOption h7 is selected'
explanations.push 'Items CH and R7 are hidden\nThe red five indicates backtracking needed\nR6 is missing => h7 backtracked\nf4 is also backtracked as CF has no options left'
explanations.push 'c5 is backtracked and replaced by c6\nd2 is selected'
explanations.push 'Items CD and R2 are hidden\ne7 is selected'
explanations.push 'Items CE and R7 are hidden\nR8 is empty => e7 is backtracked'
explanations.push "d2 is backtracked and replaced by d8"

setColor = (item, options) -> fill if options.includes item then 'black' else 'red'

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
		i = 0.5 + 'abcdefgh'.indexOf c[0]
		j = 8 - 0.5 - '12345678'.indexOf c[1]
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

drawOptions = (prompt,offset,w,items) ->

	textAlign LEFT,CENTER
	fill 'yellow'
	noStroke()
	text prompt, offset+25*0.7,50

	if prompt == 'primary items'
		n = _.size items
		choices = snapshots[current].choices
		choices = if choices == '' then [] else choices.split ' '
		fill if n + 2 * choices.length == 16 then 'yellow' else 'red'
		text n, offset+120,50

	stroke 'yellow'
	line offset+25*0.7,60,offset+w+10,60
	line offset+25*0.7,60,offset+w+10,60
	noStroke()

	i=0
	textAlign CENTER,CENTER
	for key,option of items
		option = option.split ' '
		fill 'yellow'
		text key,offset+25+25*i,50+25	
		for item,j in option
			fill 'black'
			text item,offset+25+25*i,100+25*j
		i++

showChoices = ->
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

	textSize 14
	textAlign CENTER,CENTER
	fill 'yellow'

	snapshot = snapshots[current]	
	drawOptions 'primary items',  0*25,  16*25, snapshot.primaries
	drawOptions 'secondary items',16*25, 30*25, snapshot.secondaries

	drawChessBoard()

	fill 'black'
	textSize 32
	showChoices()
	textAlign RIGHT,CENTER
	text "snapshot #{current} of #{snapshots.length-1}",width-40,25

	textAlign LEFT,TOP
	textSize 14
	fill 'white'
	text explanations[current],15,100+8*25

keyPressed = ->
	if key=='ArrowLeft' then current--
	if key=='ArrowRight' then current++
	if current < 0 then current = 0
	if current >= snapshots.length then current = snapshots.length-1
	xdraw()
