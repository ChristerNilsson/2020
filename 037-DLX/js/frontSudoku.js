// Generated by CoffeeScript 2.4.1
var constraints, data, execute, findOne, fs, getSearchConfig, i, len, line, lines, makeData, oneSolution, ref, search;

({makeData, search, getSearchConfig, findOne} = require('./dlx'));

({execute} = require('./sudoku-dlx'));

console.time('readFile');

fs = require("fs");

lines = fs.readFileSync(0).toString();

console.timeEnd('readFile');

console.time('solve');

ref = lines.split('\n');
for (i = 0, len = ref.length; i < len; i++) {
  line = ref[i];
  //console.log line
  data = execute(line);
  //console.log data
  constraints = makeData(data);
  console.log('constraints', constraints);
  //console.log JSON.stringify getSearchConfig 1,constraints
  oneSolution = findOne(constraints);
}

//console.log oneSolution
console.timeEnd('solve');

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJvbnRTdWRva3UuanMiLCJzb3VyY2VSb290IjoiLi4iLCJzb3VyY2VzIjpbImNvZmZlZVxcZnJvbnRTdWRva3UuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFBQSxJQUFBLFdBQUEsRUFBQSxJQUFBLEVBQUEsT0FBQSxFQUFBLE9BQUEsRUFBQSxFQUFBLEVBQUEsZUFBQSxFQUFBLENBQUEsRUFBQSxHQUFBLEVBQUEsSUFBQSxFQUFBLEtBQUEsRUFBQSxRQUFBLEVBQUEsV0FBQSxFQUFBLEdBQUEsRUFBQTs7QUFBQSxDQUFBLENBQUMsUUFBRCxFQUFXLE1BQVgsRUFBbUIsZUFBbkIsRUFBb0MsT0FBcEMsQ0FBQSxHQUErQyxPQUFBLENBQVEsT0FBUixDQUEvQzs7QUFDQSxDQUFBLENBQUMsT0FBRCxDQUFBLEdBQVksT0FBQSxDQUFRLGNBQVIsQ0FBWjs7QUFFQSxPQUFPLENBQUMsSUFBUixDQUFhLFVBQWI7O0FBQ0EsRUFBQSxHQUFLLE9BQUEsQ0FBUSxJQUFSOztBQUNMLEtBQUEsR0FBUSxFQUFFLENBQUMsWUFBSCxDQUFnQixDQUFoQixDQUFrQixDQUFDLFFBQW5CLENBQUE7O0FBQ1IsT0FBTyxDQUFDLE9BQVIsQ0FBZ0IsVUFBaEI7O0FBRUEsT0FBTyxDQUFDLElBQVIsQ0FBYSxPQUFiOztBQUNBO0FBQUEsS0FBQSxxQ0FBQTtnQkFBQTs7RUFFQyxJQUFBLEdBQU8sT0FBQSxDQUFRLElBQVIsRUFBUDs7RUFFQSxXQUFBLEdBQWMsUUFBQSxDQUFTLElBQVQ7RUFDZCxPQUFPLENBQUMsR0FBUixDQUFZLGFBQVosRUFBMEIsV0FBMUIsRUFIQTs7RUFNQSxXQUFBLEdBQWMsT0FBQSxDQUFRLFdBQVI7QUFSZixDQVRBOzs7QUFtQkEsT0FBTyxDQUFDLE9BQVIsQ0FBZ0IsT0FBaEIiLCJzb3VyY2VzQ29udGVudCI6WyJ7bWFrZURhdGEsIHNlYXJjaCwgZ2V0U2VhcmNoQ29uZmlnLCBmaW5kT25lfSA9IHJlcXVpcmUgJy4vZGx4J1xyXG57ZXhlY3V0ZX0gPSByZXF1aXJlICcuL3N1ZG9rdS1kbHgnIFxyXG5cclxuY29uc29sZS50aW1lICdyZWFkRmlsZSdcclxuZnMgPSByZXF1aXJlIFwiZnNcIlxyXG5saW5lcyA9IGZzLnJlYWRGaWxlU3luYygwKS50b1N0cmluZygpXHJcbmNvbnNvbGUudGltZUVuZCAncmVhZEZpbGUnXHJcblxyXG5jb25zb2xlLnRpbWUgJ3NvbHZlJ1xyXG5mb3IgbGluZSBpbiBsaW5lcy5zcGxpdCAnXFxuJ1xyXG5cdCNjb25zb2xlLmxvZyBsaW5lXHJcblx0ZGF0YSA9IGV4ZWN1dGUgbGluZVxyXG5cdCNjb25zb2xlLmxvZyBkYXRhXHJcblx0Y29uc3RyYWludHMgPSBtYWtlRGF0YSBkYXRhXHJcblx0Y29uc29sZS5sb2cgJ2NvbnN0cmFpbnRzJyxjb25zdHJhaW50c1xyXG5cclxuXHQjY29uc29sZS5sb2cgSlNPTi5zdHJpbmdpZnkgZ2V0U2VhcmNoQ29uZmlnIDEsY29uc3RyYWludHNcclxuXHRvbmVTb2x1dGlvbiA9IGZpbmRPbmUgY29uc3RyYWludHNcclxuXHQjY29uc29sZS5sb2cgb25lU29sdXRpb25cclxuY29uc29sZS50aW1lRW5kICdzb2x2ZSdcclxuIl19
//# sourceURL=c:\github\2020\037-DLX\coffee\frontSudoku.coffee