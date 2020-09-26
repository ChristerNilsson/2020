# https://artofmemory.com/blog/how-to-calculate-the-day-of-the-week-4203.html

leapYear = (year) -> if year % 100 == 0 then year % 400 == 0 else year % 4 == 0 
assert false,leapYear 2019
assert true,leapYear 2016
assert true,leapYear 2000
assert false,leapYear 1700
assert false,leapYear 1800
assert false,leapYear 100

intDiv = (a,b) -> Math.floor a/b
assert 0, intDiv 3,4
assert 1, intDiv 4,4
assert 2, intDiv 9,4
assert 3, intDiv 15,4

dayOfWeek = (year,month,day) ->
	YY = year % 100
	YearCode = (YY+intDiv(YY,4)) % 7
	MonthCode = [0,3,3,6,1,4,6,2,5,0,3,5][month-1]
	CenturyCode = [4,2,0,6,4,2,0][intDiv(year,100)-17]
	LeapYearCode = if month <= 2 and leapYear year then 1 else 0
	(YearCode + MonthCode + CenturyCode + day - LeapYearCode) % 7

assert 0, dayOfWeek 1954,12,19 # Christer
assert 5, dayOfWeek 1982,4,30 # Kasper Fredag
assert 3, dayOfWeek 1984,6,13 # Miranda Onsdag
# assert 5, dayOfWeek 1982,4,30 # Dongjiao
assert 1, dayOfWeek 2013,8,5 # Numa Måndag
assert 6, dayOfWeek 2018,9,29 # Noah Lördag

assert 2, dayOfWeek 2019,12,31

assert 0, dayOfWeek 2020,2,9
assert 1, dayOfWeek 2020,2,10
assert 2, dayOfWeek 2020,2,11
assert 3, dayOfWeek 2020,2,12
assert 4, dayOfWeek 2020,2,13
assert 5, dayOfWeek 2020,2,14
assert 6, dayOfWeek 2020,2,15

console.log 'Ready!'