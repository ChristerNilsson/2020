
persons = []
persons.push {name:'Adam', age:12}
persons.push {name:'Bertil', age:11}

persons.sort (a,b) -> a.name.localeCompare b.name 
assert '[{"name":"Adam","age":12},{"name":"Bertil","age":11}]', JSON.stringify persons

persons.sort (a,b) -> a.age - b.age
assert '[{"name":"Bertil","age":11},{"name":"Adam","age":12}]', JSON.stringify persons

console.log 'Ready!'

