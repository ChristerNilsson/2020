### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f3d14430-2400-11eb-1572-91c8f467e279
md"```
operations
a = +2
s = *2
d = /2
```"

# ╔═╡ 3190d910-23f8-11eb-159e-150a1a7ea474
@bind operations html"<input value = ''>"

# ╔═╡ 5ed6c6f0-2411-11eb-2c25-9f406cc09e9e
begin
	logg = []
	reached = []
	x = []
	y = []
	function op(value) 
		if value ∉ reached 
			push!(y,value) 
			push!(reached,value)
		end 
	end
	function generate(n) 
		a = rand(1:20)
		global logg = []
		global reached = []
		global x = [a]
		global y = []
		for i in 1:n
			for item in x
				op(item+2)
				op(item*2)
				if item%2==0 op(item÷2) end
			end
			push!(logg,y)
			global x = y
			global y = []
		end
		Dict(:a => a, :b => rand(x))
	end
end

# ╔═╡ 0ef7fac0-2423-11eb-35db-cb3bf89fa17c
n=10

# ╔═╡ bed7c220-241b-11eb-1f1f-95bea78d15a1
problem = generate(n)

# ╔═╡ d1e78812-241f-11eb-2b42-21755145382e
md"# $(problem[:a]) to $(problem[:b]) in $n steps"

# ╔═╡ a4ebf200-23f8-11eb-094f-579042854c18
begin
	res = problem[:a]
	history = []
	push!(history,res)
	for operation in operations		
		if operation == 'a' global res += 2 end
		if operation == 's' global res *= 2 end
		if operation == 'd' && res % 2 == 0 global res ÷= 2 end				
		push!(history,res)
	end
	if res == problem[:b] push!(history,"Success!") end
	history
end

# ╔═╡ Cell order:
# ╟─f3d14430-2400-11eb-1572-91c8f467e279
# ╟─d1e78812-241f-11eb-2b42-21755145382e
# ╟─3190d910-23f8-11eb-159e-150a1a7ea474
# ╟─a4ebf200-23f8-11eb-094f-579042854c18
# ╟─5ed6c6f0-2411-11eb-2c25-9f406cc09e9e
# ╟─0ef7fac0-2423-11eb-35db-cb3bf89fa17c
# ╟─bed7c220-241b-11eb-1f1f-95bea78d15a1
