### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ adb88210-22d9-11eb-083e-b78af9d9da14
# Make sure Biden wins with this margin
aim = 0.03

# ╔═╡ 59a475d0-22d9-11eb-2208-37b59ed8c4e5
votes = [[100,90],[50,40],[3,4],[100,90],[1000,900],[10,2],[1,0],[1,0],[100,90]]

# ╔═╡ 91dadf20-22d9-11eb-20a5-9ddd0e8e17b5
begin
	trump = 0
	biden = 0
	stolen = Int[]
	original = [0,0]
	logg = []
	for vote in votes
		global original .+= vote
		global trump += vote[1]
		global biden += vote[2]
		count = 0
		steal = aim * (biden+trump) - (biden - trump)
		steal = ceil(steal / 2)
		if steal < 0 steal = 0 end
		trump -= steal
		biden += steal
		push!(stolen,steal)
		push!(logg,(biden-trump)/(biden+trump))
	end
end

# ╔═╡ ef3222a0-22d9-11eb-0ea7-9908d31dc840
original,trump,biden,(biden-trump)/(biden+trump)

# ╔═╡ 04afa9b0-22dd-11eb-1199-c1bde4e12efb
stolen

# ╔═╡ 2de65c70-22ec-11eb-1a52-57f193aab521
logg

# ╔═╡ Cell order:
# ╠═adb88210-22d9-11eb-083e-b78af9d9da14
# ╠═59a475d0-22d9-11eb-2208-37b59ed8c4e5
# ╠═91dadf20-22d9-11eb-20a5-9ddd0e8e17b5
# ╠═ef3222a0-22d9-11eb-0ea7-9908d31dc840
# ╠═04afa9b0-22dd-11eb-1199-c1bde4e12efb
# ╠═2de65c70-22ec-11eb-1a52-57f193aab521
