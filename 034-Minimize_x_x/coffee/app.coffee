search = (a,d) ->
	if d-a < 0.00000001 then return (a+d)/2
	b = (a+a+d)/3
	c = (a+d+d)/3
	if b**b < c**c then search a,c else search b,d

x = search 0,1
console.log x,x**x
