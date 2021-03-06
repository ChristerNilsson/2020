VERSION = 12

SCALE = 1
cx = 0
cy = 0
msg0 = VERSION
buttons = []
startX = 0
startY = 0 

class Button
	constructor : (@prompt,@x,@y,@click) -> @r=50
	draw : ->
		circle @x,@y,@r
		text @prompt,@x,@y
	inside : (x,y) -> @r > dist x,y,@x,@y

setup = ->
	createCanvas windowWidth,windowHeight
	textAlign CENTER,CENTER
	textSize 50
	cx = width/2
	cy = height/2

draw = ->
	background "#888"
	push()
	translate cx,cy
	scale SCALE
	circle 0,0,100
	pop()
	for button in buttons
		button.draw()
	text msg0,width/2,height/2

touchStarted = (event) ->
	event.preventDefault()
	startX = mouseX
	startY = mouseY
	false

touchEnded = (event) ->
	event.preventDefault()
	for button in buttons
		if button.inside mouseX,mouseY then return button.click()
	if startX == mouseX and startY == mouseY
		buttons = []
		buttons.push new Button '+',50,50, ->
			SCALE *= 1.5
			buttons = []
		buttons.push new Button '-',150,50, ->
			SCALE /= 1.5
			buttons = []
	cx += mouseX-startX
	cy += mouseY-startY
	startX = 0
	startY = 0
	false
