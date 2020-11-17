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

# ╔═╡ 27e40a90-23f8-11eb-1ec8-cbea56e6311b
a=9+3im

# ╔═╡ 06a727b2-2400-11eb-2c16-e50460a9a239
md"## start value $a"

# ╔═╡ 2fb5fe90-23f8-11eb-144e-b76133c5f659
b=6

# ╔═╡ ea6157a0-2400-11eb-1e4e-b7bd577c559a
md"## end value $b"

# ╔═╡ f3d14430-2400-11eb-1572-91c8f467e279
md"## operations
```
t = translate
r = rotate
s = scale
m = mirror
```"

# ╔═╡ 3190d910-23f8-11eb-159e-150a1a7ea474
@bind add html"<input value = ''>"

# ╔═╡ a4ebf200-23f8-11eb-094f-579042854c18
begin
	res = a
	history = [res]
	for ch in add
		
		# if ch == 'a' global res += 2 end
		# if ch == 's' global res *= 2 end
		# if ch == 'd' && res % 2 == 0 global res ÷= 2 end
		
		if ch == 't' global res += 1 end
		if ch == 'r' global res *= im end
		if ch == 's' global res *= 2 end
		if ch == 'm' global res = imag(res) + real(res)im end
		
		push!(history,res)
	end
	history
end

# ╔═╡ 5ed6c6f0-2411-11eb-2c25-9f406cc09e9e
function generate(n) 
	x = [a]
	for i in 1:n
		y = []
		for item in x
			push!(y,item+2)
			push!(y,item*2)
			push!(y,item/2)
		end
		x = []
	end
	y
end

# ╔═╡ Cell order:
# ╟─06a727b2-2400-11eb-2c16-e50460a9a239
# ╟─27e40a90-23f8-11eb-1ec8-cbea56e6311b
# ╟─ea6157a0-2400-11eb-1e4e-b7bd577c559a
# ╟─2fb5fe90-23f8-11eb-144e-b76133c5f659
# ╟─f3d14430-2400-11eb-1572-91c8f467e279
# ╟─3190d910-23f8-11eb-159e-150a1a7ea474
# ╠═a4ebf200-23f8-11eb-094f-579042854c18
# ╠═5ed6c6f0-2411-11eb-2c25-9f406cc09e9e
