# https://en.wikipedia.org/wiki/Composition_of_the_human_body

AVOGADRO = 6.02214076e23 # /mol

weight = 19.2 # kg

number =
	O: 8
	C: 6
	H: 1
	N: 7 
	Ca: 20
	P: 15
	K: 19
	S: 16
	Na: 11
	Cl: 17
	Mg: 12

atoms = # % of mass
	O: 65.0
	C: 18.5
	H: 9.5
	N: 3.2 
	Ca: 1.5
	P: 1.0
	K: 0.4
	S: 0.3
	Na: 0.2
	Cl: 0.2
	Mg: 0.2

atomMass = # g/mol
	O: 16.0
	C: 12.011
	H: 1.008
	N: 14.006
	Ca: 40.078
	P: 30.974
	K: 39.0983
	S: 32.059
	Na: 22.989
	Cl: 35.446
	Mg: 24.304

# name grams atoms
for name of atoms
	w = atoms[name]/100 * weight * 1000 # g
	console.log name, number[name], atomMass[name],w.toFixed(0), atoms[name]/100 * weight * 1000 / atomMass[name] * AVOGADRO

console.log ''
console.log 'e+03 kilo'
console.log 'e+06 miljon'
console.log 'e+09 miljard'
console.log 'e+12 biljon'
console.log 'e+15 biljard'
console.log 'e+18 triljon'
console.log 'e+21 triljard'
console.log 'e+24 kvadriljon'
console.log 'e+27 kvadriljard'