### A Pluto.jl notebook ###
# v0.12.10

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

# ╔═╡ ffe25340-27f7-11eb-2ea6-117bc0fb2686
using JSON,PlutoUI

# ╔═╡ 0208f040-25e9-11eb-0599-bf29f848179d
states = split("AZ CA FL GA IA MA MI NC NV NY OH PA TX WI"," ")

# ╔═╡ c7130910-286a-11eb-2ec8-c5d8ea51cd86
types = ["relative","absolute","diff"]

# ╔═╡ ada802e0-2861-11eb-1fdd-e31fb55f7226
@bind state Select(states)

# ╔═╡ da4b85c0-27f7-11eb-0c72-21f4d15b09a0
data = JSON.parse(String(read(state * ".json")));

# ╔═╡ 68906bc0-27f8-11eb-05cf-438e593d9256
race = data["data"]["races"][1];

# ╔═╡ 84bc43d0-27fa-11eb-0bf7-359e55d96d8c
visa(key) = "$key: $(race[key])";

# ╔═╡ de31f240-27f8-11eb-39ca-75ba182c7b10
visa("votes")

# ╔═╡ c62af9d0-27f8-11eb-1fb9-0d72905c9fc3
visa("electoral_votes")

# ╔═╡ 0e268ebe-27f9-11eb-262e-c3c35212cfb3
visa("absentee_votes")

# ╔═╡ 22f00f6e-27f9-11eb-0564-8b6449fb4a33
visa("precincts_reporting")

# ╔═╡ 3c2f60d0-27f9-11eb-02ca-edf3102193ef
visa("precincts_total")

# ╔═╡ 8507e840-27f9-11eb-0754-3b03df6ace57
"counties: $(length(race["counties"]))"

# ╔═╡ 85c58190-286a-11eb-2609-6fca4f8944d3
@bind itype Select(types)

# ╔═╡ d2ad67c0-290f-11eb-067d-8f0923bbed74


# ╔═╡ cada850e-282d-11eb-3b82-77740872ff39
begin
	timeseries = []
	for t in race["timeseries"]
		biden = t["vote_shares"]["bidenj"]
		trump = t["vote_shares"]["trumpd"]	
		timestamp = t["timestamp"] #[12:19]	
		votes = t["votes"]	
		if votes > 0 push!(timeseries,[timestamp,votes,biden,trump,Int(round(biden*votes)),Int(round(trump*votes)),0,0,0,0]) end
	end
	timeseries
end

# ╔═╡ 33be3830-290d-11eb-250a-0dc229b96971
timeseries

# ╔═╡ b47b52c0-2839-11eb-070d-610fd9bbc69e
begin
	using Plots #,PlotlyJS
	plotly()
	#x = 1:length(timeseries)
	x = [t[1] for t in timeseries]
	typ = findfirst((t) -> itype==t,types)
	y1 = [t[2*typ+1] for t in timeseries]
	y2 = [t[2*typ+2] for t in timeseries]
	
	if itype == "relative" legend = :topright end
	if itype == "absolute" legend = :right end
	if itype == "diff" legend = :topright end
		
	plot(x, [y1,y2], label = ["Biden" "Trump"],legend=legend)
	title!("Votes in " * state)
	xlabel!("timestamp")
end

# ╔═╡ 092df7ae-2834-11eb-105a-177098ce2e51
begin
	for i in 1:length(timeseries)
		i1 = i-1
		if i1==0 i1=1 end
		t1 = timeseries[i1]
		t2 = timeseries[i]
		dvotes = t2[2]-t1[2]
		dbiden = t2[5]-t1[5]
		dtrump = t2[6]-t1[6]
		t2[7] = dbiden
		t2[8] = dtrump
		t2[9]  = round(dbiden/dvotes,digits=3)
		t2[10] = round(dtrump/dvotes,digits=3)
	end
	timeseries
end

# ╔═╡ 822ab720-2834-11eb-1486-c5786b172247
#filter((x) -> x[7] < -2000 || x[8] < -2000, timeseries)
filter((x) -> x[8] < -100000, timeseries)

# ╔═╡ Cell order:
# ╠═ffe25340-27f7-11eb-2ea6-117bc0fb2686
# ╠═84bc43d0-27fa-11eb-0bf7-359e55d96d8c
# ╠═0208f040-25e9-11eb-0599-bf29f848179d
# ╠═c7130910-286a-11eb-2ec8-c5d8ea51cd86
# ╠═da4b85c0-27f7-11eb-0c72-21f4d15b09a0
# ╠═68906bc0-27f8-11eb-05cf-438e593d9256
# ╠═de31f240-27f8-11eb-39ca-75ba182c7b10
# ╠═c62af9d0-27f8-11eb-1fb9-0d72905c9fc3
# ╠═0e268ebe-27f9-11eb-262e-c3c35212cfb3
# ╠═22f00f6e-27f9-11eb-0564-8b6449fb4a33
# ╠═3c2f60d0-27f9-11eb-02ca-edf3102193ef
# ╠═8507e840-27f9-11eb-0754-3b03df6ace57
# ╠═ada802e0-2861-11eb-1fdd-e31fb55f7226
# ╠═85c58190-286a-11eb-2609-6fca4f8944d3
# ╠═33be3830-290d-11eb-250a-0dc229b96971
# ╠═b47b52c0-2839-11eb-070d-610fd9bbc69e
# ╠═d2ad67c0-290f-11eb-067d-8f0923bbed74
# ╠═cada850e-282d-11eb-3b82-77740872ff39
# ╠═092df7ae-2834-11eb-105a-177098ce2e51
# ╠═822ab720-2834-11eb-1486-c5786b172247
