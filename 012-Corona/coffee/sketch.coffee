# URL = "https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"

DIR = 'data\\time_series_covid19_'
C = 'confirmed_global.csv'
D = 'deaths_global.csv'
R = 'recovered_global.csv'

START = new Date 2020,1,22

confirmed = null
deaths = null
recovered = null

xAxis = null

currentCountry = 0
currentSelection = 11

population = {}  # millions
population.Austria = 8.90
population.Denmark = 5.82
population.Finland = 5.53
population.France = 67.1
population.Germany = 83.1
population.Israel = 9.18
population.Italy = 60.2
population.Japan = 126.0
population['Korea, South'] = 51.8
population.Norway = 5.37
population.Spain = 47.1
population.Sweden = 10.3
population['Taiwan*'] = 23.6
population['United Kingdom'] = 66.4
population.US = 329.6

selection = [16,94,106,116,120,136,137,139,143,175,201,205,207,223,225]

countries = []
antalDagar = 0
currentDate = 0

d3.csv(DIR + C).then (data) ->
	confirmed = myParse data
	countries = _.keys confirmed
	country = countries[currentCountry]
	antalDagar = _.size confirmed[country]
	currentDate = antalDagar-1
	currentCountry = selection[currentSelection]
	#console.log countries
d3.csv(DIR + D).then (data) -> 
	deaths = myParse data
d3.csv(DIR + R).then (data) -> recovered = myParse data

myRound = (x,n=0) ->
	x.toFixed n
	# if x >= 100 then return x.toFixed 1
	# if x >= 10 then return x.toFixed 2
	# if x >= 1 then return x.toFixed 3
	# #if x >= 0.1 then return x.toFixed 3
	# x.toFixed 4

setup = ->
	createCanvas 800,400
	drawChart()

drawChart = ->
	# create svg element
	svg = d3.select "#chart"
		.append "svg"
		.attr "width", 800
		.attr "height", 200

	# Create the scale
	xAxis = d3.scaleLog()
		.domain [1,100000]      # This is what is written on the Axis: from 0 to 100
		.range [100, 700]       # This is where the axis is placed: from 100 px to 800px
		.base 10

	# Draw the axis
	svg
		.append "g"
		.attr "transform", "translate(0,150)"      # This controls the vertical position of the Axis
		.call d3.axisBottom(xAxis).tickFormat(d3.format(".1s")).ticks(5)

draw = ->
	bg 0.5
	if confirmed==null or deaths==null or recovered==null then return
	if countries.length == 0 then return 
	country = countries[currentCountry]
	s = moment().subtract antalDagar-currentDate,'days'
	textSize 20
	text s.format("YY-MM-DD")+' '+country,10,30
	#text country,10,60
	text confirmed[country][currentDate] + ' confirmed',10,90
	text (myRound(confirmed[country][currentDate]/population[country])),200,90
	text deaths[country][currentDate] + ' deaths',10,120
	text myRound(deaths[country][currentDate]/population[country]),200,120
	if recovered[country]
		r = recovered[country][currentDate]
		d = deaths[country][currentDate]
		text r + ' recovered',10,150
		text myRound(recovered[country][currentDate]/population[country]),200,150
		text myRound(100*d/(d+r),2)+ ' % death rate',10,180
		if currentDate > 7
			c0 = confirmed[country][currentDate]
			c7 = confirmed[country][currentDate-7]
			text "#{(c0/c7).toFixed(2)} factor for seven days",300,90
			d0 = deaths[country][currentDate]
			d7 = deaths[country][currentDate-7]
			text "#{(d0/d7).toFixed(2)} factor for seven days",300,120

myParse = (rows) ->
	result = {}
	for row in rows
		arr0 = row['Province/State']
		arr1 = row['Country/Region']
		key = if arr0.length > 0 then arr1+'|'+ arr0 else arr1
		lst = _.values row
		for i in range 4
			lst.shift()
		result[key] = (int(count) for count in lst)
	result

movingAverage = (lst,n) ->
	result = ""
	for i in range 7,lst.length
		res = 0
		for j in range n
			res += lst[i-j]-lst[i-j-1]
		result += "#{res/n}\n"
	result

keyPressed = ->
	if key=='ArrowLeft' then currentDate--
	if key=='ArrowRight' then currentDate++
	if key=='ArrowUp' then currentSelection = (currentSelection-1) %% selection.length
	if key=='ArrowDown' then currentSelection = (currentSelection+1) %% selection.length
	if key=='Home' then currentSelection=0
	if key=='End' then currentSelection=selection.length-1

	if currentDate < 0 then currentDate = 0
	if currentDate > antalDagar-1 then currentDate = antalDagar-1
	if key in 'abcdefghijklmnopqrstuvwxyz' then search 1
	if key in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' then search -1
	currentCountry = selection[currentSelection]
	xAxis.domain [1,10]

	console.log movingAverage(deaths.Sweden,3)


search = (delta) ->
	k = key.toUpperCase()
	index = (currentSelection+delta) %% selection.length
	while index != currentSelection
		k1 = countries[selection[index]][0]
		if k1 == k then break
		index = (index+delta) %% selection.length
	currentSelection = index
	currentCountry = selection[currentSelection]
