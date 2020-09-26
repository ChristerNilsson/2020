// Generated by CoffeeScript 2.4.1
var f;

f = function(radius) {
  var count, i, j, k, l, len, len1, lst, r1;
  r1 = radius + 1;
  lst = range(radius);
  count = 0;
  for (k = 0, len = lst.length; k < len; k++) {
    i = lst[k];
    for (l = 0, len1 = lst.length; l < len1; l++) {
      j = lst[l];
      if (i * i + j * j <= radius * radius) {
        count++;
      }
    }
  }
  return 4 * count / r1 / r1;
};

assert(3.091118800461361, f(50));

assert(3.118517792373297, f(100));

assert(3.1292294745179574, f(200));

assert(3.1368161879833147, f(500));

assert(3.1392623360655327, f(1000));

assert(3.141362176151148, f(10000));

// assert 3.14147797434887, f 20000
// assert 3.1415467528732663, f 50000
// PI = 3.1415926535
print('Ready');

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUE7O0FBQUEsQ0FBQSxHQUFJLFFBQUEsQ0FBQyxNQUFELENBQUE7QUFDSCxNQUFBLEtBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsR0FBQSxFQUFBLElBQUEsRUFBQSxHQUFBLEVBQUE7RUFBQSxFQUFBLEdBQUssTUFBQSxHQUFPO0VBQ1osR0FBQSxHQUFNLEtBQUEsQ0FBTSxNQUFOO0VBQ04sS0FBQSxHQUFRO0VBQ1IsS0FBQSxxQ0FBQTs7SUFDQyxLQUFBLHVDQUFBOztNQUNDLElBQUcsQ0FBQSxHQUFFLENBQUYsR0FBSSxDQUFBLEdBQUUsQ0FBTixJQUFXLE1BQUEsR0FBTyxNQUFyQjtRQUFpQyxLQUFBLEdBQWpDOztJQUREO0VBREQ7U0FHQSxDQUFBLEdBQUksS0FBSixHQUFVLEVBQVYsR0FBYTtBQVBWOztBQVNKLE1BQUEsQ0FBTyxpQkFBUCxFQUEwQixDQUFBLENBQUUsRUFBRixDQUExQjs7QUFDQSxNQUFBLENBQU8saUJBQVAsRUFBMEIsQ0FBQSxDQUFFLEdBQUYsQ0FBMUI7O0FBQ0EsTUFBQSxDQUFPLGtCQUFQLEVBQTJCLENBQUEsQ0FBRSxHQUFGLENBQTNCOztBQUNBLE1BQUEsQ0FBTyxrQkFBUCxFQUEyQixDQUFBLENBQUUsR0FBRixDQUEzQjs7QUFDQSxNQUFBLENBQU8sa0JBQVAsRUFBMkIsQ0FBQSxDQUFFLElBQUYsQ0FBM0I7O0FBQ0EsTUFBQSxDQUFPLGlCQUFQLEVBQTBCLENBQUEsQ0FBRSxLQUFGLENBQTFCLEVBZEE7Ozs7O0FBbUJBLEtBQUEsQ0FBTSxPQUFOIiwic291cmNlc0NvbnRlbnQiOlsiZiA9IChyYWRpdXMpIC0+XHJcblx0cjEgPSByYWRpdXMrMVxyXG5cdGxzdCA9IHJhbmdlIHJhZGl1c1xyXG5cdGNvdW50ID0gMFxyXG5cdGZvciBpIGluIGxzdFxyXG5cdFx0Zm9yIGogaW4gbHN0XHJcblx0XHRcdGlmIGkqaStqKmogPD0gcmFkaXVzKnJhZGl1cyB0aGVuIGNvdW50KytcclxuXHQ0ICogY291bnQvcjEvcjFcclxuXHJcbmFzc2VydCAzLjA5MTExODgwMDQ2MTM2MSwgZiA1MFxyXG5hc3NlcnQgMy4xMTg1MTc3OTIzNzMyOTcsIGYgMTAwXHJcbmFzc2VydCAzLjEyOTIyOTQ3NDUxNzk1NzQsIGYgMjAwXHJcbmFzc2VydCAzLjEzNjgxNjE4Nzk4MzMxNDcsIGYgNTAwXHJcbmFzc2VydCAzLjEzOTI2MjMzNjA2NTUzMjcsIGYgMTAwMFxyXG5hc3NlcnQgMy4xNDEzNjIxNzYxNTExNDgsIGYgMTAwMDBcclxuXHJcbiMgYXNzZXJ0IDMuMTQxNDc3OTc0MzQ4ODcsIGYgMjAwMDBcclxuIyBhc3NlcnQgMy4xNDE1NDY3NTI4NzMyNjYzLCBmIDUwMDAwXHJcbiMgUEkgPSAzLjE0MTU5MjY1MzVcclxucHJpbnQgJ1JlYWR5J1xyXG4iXX0=
//# sourceURL=c:\Lab\2020\006-PiMonteCarlo\coffee\sketch.coffee