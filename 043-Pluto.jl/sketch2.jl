import Pkg
Pkg.activate(mktempdir())

Pkg.add("Plots")
using Plots

plotly()
years = 2001:2010
apples = [15, 25, 80, 75, 50, 30, 35, 15, 25, 35]
plot(years, apples)
plot(years, apples, legend=false, title="Number of apples per year")

begin
	plot(years, apples)
	plot!(legend=false)
	plot!(title="Number of apples per year")
end