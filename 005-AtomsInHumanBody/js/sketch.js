// Generated by CoffeeScript 2.4.1
// https://en.wikipedia.org/wiki/Composition_of_the_human_body
var AVOGADRO, atomMass, atoms, name, number, w, weight;

AVOGADRO = 6.02214076e23; // /mol

weight = 19.2; // kg

number = {
  O: 8,
  C: 6,
  H: 1,
  N: 7,
  Ca: 20,
  P: 15,
  K: 19,
  S: 16,
  Na: 11,
  Cl: 17,
  Mg: 12
};

atoms = { // % of mass
  O: 65.0,
  C: 18.5,
  H: 9.5,
  N: 3.2,
  Ca: 1.5,
  P: 1.0,
  K: 0.4,
  S: 0.3,
  Na: 0.2,
  Cl: 0.2,
  Mg: 0.2
};

atomMass = { // g/mol
  O: 16.0,
  C: 12.011,
  H: 1.008,
  N: 14.006,
  Ca: 40.078,
  P: 30.974,
  K: 39.0983,
  S: 32.059,
  Na: 22.989,
  Cl: 35.446,
  Mg: 24.304
};

// name grams atoms
for (name in atoms) {
  w = atoms[name] / 100 * weight * 1000; // g
  console.log(name, number[name], atomMass[name], w.toFixed(0), atoms[name] / 100 * weight * 1000 / atomMass[name] * AVOGADRO);
}

console.log('');

console.log('e+03 kilo');

console.log('e+06 miljon');

console.log('e+09 miljard');

console.log('e+12 biljon');

console.log('e+15 biljard');

console.log('e+18 triljon');

console.log('e+21 triljard');

console.log('e+24 kvadriljon');

console.log('e+27 kvadriljard');

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsSUFBQSxRQUFBLEVBQUEsUUFBQSxFQUFBLEtBQUEsRUFBQSxJQUFBLEVBQUEsTUFBQSxFQUFBLENBQUEsRUFBQTs7QUFFQSxRQUFBLEdBQVcsY0FGWDs7QUFJQSxNQUFBLEdBQVMsS0FKVDs7QUFNQSxNQUFBLEdBQ0M7RUFBQSxDQUFBLEVBQUcsQ0FBSDtFQUNBLENBQUEsRUFBRyxDQURIO0VBRUEsQ0FBQSxFQUFHLENBRkg7RUFHQSxDQUFBLEVBQUcsQ0FISDtFQUlBLEVBQUEsRUFBSSxFQUpKO0VBS0EsQ0FBQSxFQUFHLEVBTEg7RUFNQSxDQUFBLEVBQUcsRUFOSDtFQU9BLENBQUEsRUFBRyxFQVBIO0VBUUEsRUFBQSxFQUFJLEVBUko7RUFTQSxFQUFBLEVBQUksRUFUSjtFQVVBLEVBQUEsRUFBSTtBQVZKOztBQVlELEtBQUEsR0FDQyxDQUFBO0VBQUEsQ0FBQSxFQUFHLElBQUg7RUFDQSxDQUFBLEVBQUcsSUFESDtFQUVBLENBQUEsRUFBRyxHQUZIO0VBR0EsQ0FBQSxFQUFHLEdBSEg7RUFJQSxFQUFBLEVBQUksR0FKSjtFQUtBLENBQUEsRUFBRyxHQUxIO0VBTUEsQ0FBQSxFQUFHLEdBTkg7RUFPQSxDQUFBLEVBQUcsR0FQSDtFQVFBLEVBQUEsRUFBSSxHQVJKO0VBU0EsRUFBQSxFQUFJLEdBVEo7RUFVQSxFQUFBLEVBQUk7QUFWSjs7QUFZRCxRQUFBLEdBQ0MsQ0FBQTtFQUFBLENBQUEsRUFBRyxJQUFIO0VBQ0EsQ0FBQSxFQUFHLE1BREg7RUFFQSxDQUFBLEVBQUcsS0FGSDtFQUdBLENBQUEsRUFBRyxNQUhIO0VBSUEsRUFBQSxFQUFJLE1BSko7RUFLQSxDQUFBLEVBQUcsTUFMSDtFQU1BLENBQUEsRUFBRyxPQU5IO0VBT0EsQ0FBQSxFQUFHLE1BUEg7RUFRQSxFQUFBLEVBQUksTUFSSjtFQVNBLEVBQUEsRUFBSSxNQVRKO0VBVUEsRUFBQSxFQUFJO0FBVkosRUFqQ0Q7OztBQThDQSxLQUFBLGFBQUE7RUFDQyxDQUFBLEdBQUksS0FBTSxDQUFBLElBQUEsQ0FBTixHQUFZLEdBQVosR0FBa0IsTUFBbEIsR0FBMkIsS0FBL0I7RUFDQSxPQUFPLENBQUMsR0FBUixDQUFZLElBQVosRUFBa0IsTUFBTyxDQUFBLElBQUEsQ0FBekIsRUFBZ0MsUUFBUyxDQUFBLElBQUEsQ0FBekMsRUFBK0MsQ0FBQyxDQUFDLE9BQUYsQ0FBVSxDQUFWLENBQS9DLEVBQTZELEtBQU0sQ0FBQSxJQUFBLENBQU4sR0FBWSxHQUFaLEdBQWtCLE1BQWxCLEdBQTJCLElBQTNCLEdBQWtDLFFBQVMsQ0FBQSxJQUFBLENBQTNDLEdBQW1ELFFBQWhIO0FBRkQ7O0FBSUEsT0FBTyxDQUFDLEdBQVIsQ0FBWSxFQUFaOztBQUNBLE9BQU8sQ0FBQyxHQUFSLENBQVksV0FBWjs7QUFDQSxPQUFPLENBQUMsR0FBUixDQUFZLGFBQVo7O0FBQ0EsT0FBTyxDQUFDLEdBQVIsQ0FBWSxjQUFaOztBQUNBLE9BQU8sQ0FBQyxHQUFSLENBQVksYUFBWjs7QUFDQSxPQUFPLENBQUMsR0FBUixDQUFZLGNBQVo7O0FBQ0EsT0FBTyxDQUFDLEdBQVIsQ0FBWSxjQUFaOztBQUNBLE9BQU8sQ0FBQyxHQUFSLENBQVksZUFBWjs7QUFDQSxPQUFPLENBQUMsR0FBUixDQUFZLGlCQUFaOztBQUNBLE9BQU8sQ0FBQyxHQUFSLENBQVksa0JBQVoiLCJzb3VyY2VzQ29udGVudCI6WyIjIGh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL0NvbXBvc2l0aW9uX29mX3RoZV9odW1hbl9ib2R5XHJcblxyXG5BVk9HQURSTyA9IDYuMDIyMTQwNzZlMjMgIyAvbW9sXHJcblxyXG53ZWlnaHQgPSAxOS4yICMga2dcclxuXHJcbm51bWJlciA9XHJcblx0TzogOFxyXG5cdEM6IDZcclxuXHRIOiAxXHJcblx0TjogNyBcclxuXHRDYTogMjBcclxuXHRQOiAxNVxyXG5cdEs6IDE5XHJcblx0UzogMTZcclxuXHROYTogMTFcclxuXHRDbDogMTdcclxuXHRNZzogMTJcclxuXHJcbmF0b21zID0gIyAlIG9mIG1hc3NcclxuXHRPOiA2NS4wXHJcblx0QzogMTguNVxyXG5cdEg6IDkuNVxyXG5cdE46IDMuMiBcclxuXHRDYTogMS41XHJcblx0UDogMS4wXHJcblx0SzogMC40XHJcblx0UzogMC4zXHJcblx0TmE6IDAuMlxyXG5cdENsOiAwLjJcclxuXHRNZzogMC4yXHJcblxyXG5hdG9tTWFzcyA9ICMgZy9tb2xcclxuXHRPOiAxNi4wXHJcblx0QzogMTIuMDExXHJcblx0SDogMS4wMDhcclxuXHROOiAxNC4wMDZcclxuXHRDYTogNDAuMDc4XHJcblx0UDogMzAuOTc0XHJcblx0SzogMzkuMDk4M1xyXG5cdFM6IDMyLjA1OVxyXG5cdE5hOiAyMi45ODlcclxuXHRDbDogMzUuNDQ2XHJcblx0TWc6IDI0LjMwNFxyXG5cclxuIyBuYW1lIGdyYW1zIGF0b21zXHJcbmZvciBuYW1lIG9mIGF0b21zXHJcblx0dyA9IGF0b21zW25hbWVdLzEwMCAqIHdlaWdodCAqIDEwMDAgIyBnXHJcblx0Y29uc29sZS5sb2cgbmFtZSwgbnVtYmVyW25hbWVdLCBhdG9tTWFzc1tuYW1lXSx3LnRvRml4ZWQoMCksIGF0b21zW25hbWVdLzEwMCAqIHdlaWdodCAqIDEwMDAgLyBhdG9tTWFzc1tuYW1lXSAqIEFWT0dBRFJPXHJcblxyXG5jb25zb2xlLmxvZyAnJ1xyXG5jb25zb2xlLmxvZyAnZSswMyBraWxvJ1xyXG5jb25zb2xlLmxvZyAnZSswNiBtaWxqb24nXHJcbmNvbnNvbGUubG9nICdlKzA5IG1pbGphcmQnXHJcbmNvbnNvbGUubG9nICdlKzEyIGJpbGpvbidcclxuY29uc29sZS5sb2cgJ2UrMTUgYmlsamFyZCdcclxuY29uc29sZS5sb2cgJ2UrMTggdHJpbGpvbidcclxuY29uc29sZS5sb2cgJ2UrMjEgdHJpbGphcmQnXHJcbmNvbnNvbGUubG9nICdlKzI0IGt2YWRyaWxqb24nXHJcbmNvbnNvbGUubG9nICdlKzI3IGt2YWRyaWxqYXJkJyJdfQ==
//# sourceURL=c:\Lab\2020\005-AtomsInHumanBody\coffee\sketch.coffee