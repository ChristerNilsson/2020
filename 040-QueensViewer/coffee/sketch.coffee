constraints = null
snapshots = null
current = 0
yellowKey = ''
yellowSquare = ''

MODE = 0 # 0=compact 1=expanded

range = null 
circle = (x, y, r) -> ellipse x, y, 2*r, 2*r

explanations = []
explanations.push 'There are 16 primary items, 8 columns and 8 rows\n\nThe matrix is actually 64 options x 46 items\nIt is shown compressed here\nPress Space or click to toggle View Mode\n\nItem CA is chosen\nOption a1 is first\nPress Right Arrow to see option a1 selected'
explanations.push 'Items CA and R1 are hidden\nItem CB is chosen\nOption b3 is selected'
explanations.push 'Items CB and R3 are hidden\nShortest item is CC\nOption c5 is selected'
explanations.push 'Items CC and R5 are hidden\nShortest item is CF\nOption f4 is selected'
explanations.push 'Items CF and R4 are hidden\nShortest item is CH\nOption h7 is selected'
explanations.push 'Items CH and R7 are hidden\nThe red five indicates backtracking needed\nR6 is missing => h7 backtracked\nf4 is also backtracked as CF has no options left'
explanations.push 'c5 is backtracked and replaced by c6\nd2 is selected'
explanations.push 'Items CD and R2 are hidden\ne7 is selected'
explanations.push 'Items CE and R7 are hidden\nR8 is empty => e7 is backtracked'
explanations.push "d2 is backtracked and replaced by d8"

drawChessBoard = () ->
	R = 50
	x = width/2-4*R
	y = 300

	for i in range 8
		for j in range 8
			fill if (i+j)%2==0 then 'white' else 'black'
			rect x+R*i,y+R*j,R,R

	fill 'black'
	for i in range 8
		text 8-i,x-R*0.2,y+R*(i+0.5)
		text 'abcdefgh'[i],x+R*(i+0.5),y+8.3*R

	fill 'green'
	textSize 24
	choices = snapshots[current].choices
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

	drawYellowLine()

preload = ->
	fetch "8queens.json"
		.then (response) => response.json() 
		.then (json) => 
			{constraints,snapshots} = json
			constraints.primaries = constraints.primaries.split ' '
			constraints.secondaries = constraints.secondaries.split ' '
			for snapshot in snapshots
				snapshot.choices = if snapshot.choices == '' then  [] else snapshot.choices.split ' '
			console.log json

setup = ->
	createCanvas 1180,1080
	range = _.range

drawOptions = (prompt, offset, w, constraints, items) ->

	textAlign LEFT,CENTER
	fill 'yellow'
	noStroke()
	text prompt, offset+25*0.7,50

	if prompt == 'primary items'
		n = _.size items
		choices = snapshots[current].choices
		fill if n + 2 * choices.length == 16 then 'yellow' else 'red'
		text n, offset+120,50

	stroke 'yellow'
	strokeWeight 1
	line offset+25*0.7,60,offset+w+10,60
	line offset+25*0.7,60,offset+w+10,60
	noStroke()

	textAlign CENTER,CENTER

	for key,i in constraints
		fill 'yellow'
		text key,offset+25+25*i,50+25	
		if MODE == 0
			if items[key]
				option = items[key].split ' '
				for item,j in option
					fill if item == yellowSquare then 'white' else 'black'
					text item,offset+25+25*i,100+25*j

showChoices = ->
	r = 20	
	fill 'white'
	for index in range 8
		x = 21 + 2*r*index
		y = 21
		circle x,y,r

	fill 'green'
	textSize 24
	textAlign CENTER,CENTER
	choices = snapshots[current].choices
	for c,index in choices
		x = 21 + 2*r*index
		y = 21
		fill if index == choices.length-1 then 'yellow' else 'green'
		circle x,y,r
		noStroke()
		fill if index == choices.length-1 then 'green' else 'yellow'
		text c,x,y

drawLinks = (offset, entries, constraints, items) ->
	fill 'black'
	textSize 12
	keys = _.keys entries
	stroke 'black'

	for key,i in keys
		y = 100+15*i
		line 0,y,width,y

	for key,i in constraints
		x = offset + 25 + 25 * i
		stroke 'black'
		line x,100,x,height

drawExpanded = (offset, entries, constraints, items) ->
	fill 'black'
	textSize 16
	keys = _.keys entries
	stroke 'black'
	for key,i in keys
		y = 100+15*i

	for key,i in constraints
		x = offset + 25 + 25 * i
		stroke 'black'
		if items[key]
			option = items[key].split ' '
			for item in option
				j = keys.indexOf item
				y = 100+15*j
				stroke 128
				line x,y-8,x,y+8
				line x-10,y,x+8,y
				noStroke()
				fill if yellowSquare == item then 'white' else 'black'
				text item,x,y

draw = ->
	background 128
	if not constraints then return

	textSize 14
	textAlign CENTER,CENTER
	fill 'yellow'

	snapshot = snapshots[current]	
	drawOptions 'primary items',  0*25,  16*25, constraints.primaries,   snapshot.primaries
	drawOptions 'secondary items',16*25, 30*25, constraints.secondaries, snapshot.secondaries

	if MODE == 0 then drawChessBoard()

	textSize 32
	showChoices()
	fill 'black'
	textAlign RIGHT,CENTER
	text "snapshot #{current} of #{snapshots.length-1}",width-40,25
	textAlign CENTER,CENTER
	text 'Dancing Links',width/2,25

	if MODE == 0
		textAlign LEFT,TOP
		textSize 14
		fill 'white'
		text explanations[current],15,100+8*25

	if MODE == 1
		drawLinks    0*25,  constraints.entries, constraints.primaries,   snapshot.primaries
		drawLinks    16*25, constraints.entries, constraints.secondaries, snapshot.secondaries
		drawExpanded 0*25,  constraints.entries, constraints.primaries,   snapshot.primaries
		drawExpanded 16*25, constraints.entries, constraints.secondaries, snapshot.secondaries

keyPressed = ->
	if key==' '
		MODE = 1 - MODE
		return
	if key=='ArrowLeft' then current--
	if key=='ArrowRight' then current++
	if current < 0 then current = 0
	if current >= snapshots.length then current = snapshots.length-1
	draw()

drawLine = (i1,j1,i2,j2) ->
	R = 50
	x = width/2-4*R
	y = 300 
	line x+R*(i1+0.5),y+R*(j1+0.5),x+R*(i2+0.5),y+R*(j2+0.5)

mousePressed = -> MODE = 1 - MODE

mouseMoved = ->
	R = 50
	x = width/2-4*R
	y = 300
	yellowKey = ''
	yellowSquare = ""
	if 50 < mouseY < 300
		for key,index in constraints.primaries
			if 25*(index+0.5) < mouseX < 25*(index+1.5) then yellowKey = key
		for key,index in constraints.secondaries
			if 25*(index+16.5) < mouseX < 25*(index+17.5) then yellowKey = key
	else if x < mouseX < x+R*8 and y < mouseY < y+R*8
		for i in range 8
			for j in range 8
				if y+R*(7-j) < mouseY < y+R*(7-j+1)
					if x+R*i < mouseX < x+R*(i+1)
						yellowSquare = 'abcdefgh'[i] + '12345678'[j]

drawYellowLine = ->
	key = yellowKey
	if key == '' then return
	stroke 255,255,0,128
	strokeWeight 25
	if key[0] in "CR"
		i = 'ABCDEFGH'.indexOf key[1]
		j = '12345678'.indexOf key[1]
		if key[0] == 'C' then drawLine i,0,i,7
		if key[0] == 'R' then drawLine 0,7-j,7,7-j
	if key[0] in "AB"
		i = 'ABCDEFGHIJKLMNO'.indexOf key[1]
		if key[0] == 'A'
			if i < 7 then drawLine 0,7-i,i,7 else drawLine i-7,0, 7,14-i
		if key[0] == 'B'
			if i < 7 then drawLine 7,7-i,7-i,7 else drawLine 0,14-i,14-i,0
	noStroke()
	strokeWeight 1