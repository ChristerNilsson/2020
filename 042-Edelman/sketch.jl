# function nextday(E,I1,I2)
# 	I2 = I1
# 	I1 = E
# 	n = length(I1) + length(I2)
# 	last = E[end]
# 	E = last .+ (1:n)
# 	E,I1,I2
# end

# function iterate_days(d)
# 	E=1:1; I1=1:0; I2=1:0
# 	for i=1:d
# 		E,I1,I2 = nextday(E,I1,I2)
# 	end
# 	E,I1,I2
# end

# https://www.youtube.com/watch?v=VNo5WrKZ8Yc&ab_channel=TheJuliaProgrammingLanguage

function fib(n) n<2 ? 1 :	fib(n-1) + fib(n-2) end

function plot_iterate_days(n)
	for i=0:n, j=1:fib(i)
		println(repeat("  ",i), "E 1 2")
	end
end

plot_iterate_days(5)
