level = 1
active = 0
clicked = []
circles = []


COLORS = "#ff08 #0f08 #00f8".split ' '

class Circle
	constructor : (@radie, @x, @y, @col) ->
		@active = true
	rita : ->
		if @active
			fill @col
			circle @x,@y,@radie
	inside : (mx,my) -> dist(@x,@y,mx,my) < @radie

reset = (delta=1) ->
	level += delta
	circles = []
	for i in range level
		createCirclePair COLORS[i]

setup = ->
	createCanvas windowWidth,windowHeight
	reset()

draw = ->
	bg 0
	for circle in circles
		circle.rita()

createCirclePair = (col) ->
	active++

	radie = windowHeight/4

	for i in range 2
		x = random width
		y = random height
		circles.push new Circle radie,x,y,col

mousePressed = () ->
	count = 0
	for circle in circles
		if circle.inside mouseX,mouseY
			curr = circle
			count++
	if curr.active
		if count == 1
			curr.active = false
			clicked.push curr
			if clicked.length == 2 
				if clicked[0].col != clicked[1].col then reset -1
				

