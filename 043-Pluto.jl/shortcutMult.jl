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

# ╔═╡ ac6d4270-244f-11eb-31a3-758272b4611f
@bind factor html"<input type=range min=2 max=10 value=2>"

# ╔═╡ 69fc2d10-2450-11eb-2d36-fb4f3ede4047
factor

# ╔═╡ 3efe1f70-244f-11eb-393e-b5e08c93bd38
@bind level html"<input type=range min=1 max=10 value=1>"

# ╔═╡ 6e1a8ef0-2450-11eb-3a12-b1e613ba71b0
level

# ╔═╡ 57d0b400-2449-11eb-371d-0b07b137e581
@bind operations html"<input value = ''>"		

# ╔═╡ 5ed6c6f0-2411-11eb-2c25-9f406cc09e9e
begin
	function op(value) 
		if value ∉ reached 
			push!(y,value) 
			push!(reached,value)
		end 
	end
	a = rand(1:10)
	reached = []
	x = [a]
	y = []
	for i in 1:level
		for item in x
			op(item+1)
			op(item*factor)
		end
		global x = y
		global y = []
	end
	b = rand(x)
	[a,b]
	
end

# ╔═╡ 56f7dc00-2450-11eb-25b5-2d4378504412
begin
	res = a
	history = string(res)
	for operation in operations
		if operation == 'a' global res += 1 end
		if operation == 's' global res *= factor end		
		global history *= " " * string(res)
	end
	if res == b history *= " Success!" end
	history
end

# ╔═╡ 67c8c390-2456-11eb-071e-630f0e8ca2e2
"$res to $b"

# ╔═╡ Cell order:
# ╠═ac6d4270-244f-11eb-31a3-758272b4611f
# ╠═69fc2d10-2450-11eb-2d36-fb4f3ede4047
# ╠═3efe1f70-244f-11eb-393e-b5e08c93bd38
# ╟─6e1a8ef0-2450-11eb-3a12-b1e613ba71b0
# ╠═67c8c390-2456-11eb-071e-630f0e8ca2e2
# ╟─57d0b400-2449-11eb-371d-0b07b137e581
# ╠═56f7dc00-2450-11eb-25b5-2d4378504412
# ╠═5ed6c6f0-2411-11eb-2c25-9f406cc09e9e
