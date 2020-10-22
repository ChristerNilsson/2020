# https://www.youtube.com/watch?v=VNo5WrKZ8Yc&ab_channel=TheJuliaProgrammingLanguage

function fib(n) n<2 ? 1 : fib(n-1) + fib(n-2) end

function plot_iterate_days(n)
	for i=0:n, j=1:fib(i)
		println(repeat("  ",i), "E 1 2")
	end
end

plot_iterate_days(5)
