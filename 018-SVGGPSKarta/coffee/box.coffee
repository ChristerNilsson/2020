SQ2 = 2 # Math.sqrt 2

WIDTH = 1639
HEIGHT = 986
RADIUS = 35

messages = []

stdText = {font: '40px Arial', fill: '#000'}

image = null
crossHair = null

scale = (factor) ->

	{x,y} = image.attrs
	{dx,dy,sx,sy} = image._
	console.log x,y,dx,dy,sx,sy

	#[x0,y0] = [0,0]  # NW
	#[x0,y0] = [WIDTH/2,HEIGHT/2]  # center
	#[x0,y0] = [WIDTH,HEIGHT] # SW
	[x0,y0] = [WIDTH/2,HEIGHT/2] # SW
	image.scale factor,factor,dx/sx+x+x0,dy/sy+y+y0

	{x,y} = image.attrs
	{dx,dy,sx,sy} = image._
	console.log x,y,dx,dy,sx,sy

	if crossHair then crossHair.scale factor

class Box 
	constructor : (x,y,w,h,name) ->
		image = raphael.image "data/Skarpnäck.png", (1920-WIDTH)/2, (1127-HEIGHT)/2, WIDTH, HEIGHT
#		image.translate (1920-WIDTH)/2, (1127-HEIGHT)/2
		#image.scale 1,1, 1920/2, 1127/2
		#image.attr {x:(1920-WIDTH)/2, y:(1127-HEIGHT)/2}
		crossHair = raphael.circle w/2,h/2,RADIUS 
		#scale SQ2
		#scale 1

		a = raphael.text 0.5*w, 50, '180º'
			.attr stdText
		b = raphael.text 0.95*w, 50, '345m'
			.attr stdText

		c = raphael.text 0.5*w, 0.95*h, '59.123456 18.123456'
			.attr stdText
		d = raphael.text 0.95*w, 0.95*h, '345'
			.attr stdText

		messages = [a,b,c,d]

		console.log messages

		image.drag @move_drag, @move_start, @move_up
		image.mousemove (e) -> # Ska ge image koordinater
			{dx,dy,sx,sy} = image._
			messages[2].attr {text: "#{(e.x - dx)/sx - image.attrs.x} = #{e.x} #{dx} #{x} #{sx}   " + "#{(e.y - dy)/sy - image.attrs.y} = #{e.y} #{dy} #{y} #{sy}"}

	move_start : -> [@ox,@oy] = [0,0]

	move_drag : (dx, dy) ->
		image.translate (dx-@ox) / image._.sx, (dy-@oy) / image._.sy
		@ox = dx
		@oy = dy 

	move_up : ->
		console.dir JSON.stringify image.attrs
