// Generated by CoffeeScript 2.4.1
// https://artofmemory.com/blog/how-to-calculate-the-day-of-the-week-4203.html
var dayOfWeek, intDiv, leapYear;

leapYear = function(year) {
  if (year % 100 === 0) {
    return year % 400 === 0;
  } else {
    return year % 4 === 0;
  }
};

assert(false, leapYear(2019));

assert(true, leapYear(2016));

assert(true, leapYear(2000));

assert(false, leapYear(1700));

assert(false, leapYear(1800));

assert(false, leapYear(100));

intDiv = function(a, b) {
  return Math.floor(a / b);
};

assert(0, intDiv(3, 4));

assert(1, intDiv(4, 4));

assert(2, intDiv(9, 4));

assert(3, intDiv(15, 4));

dayOfWeek = function(year, month, day) {
  var CenturyCode, LeapYearCode, MonthCode, YY, YearCode;
  YY = year % 100;
  YearCode = (YY + intDiv(YY, 4)) % 7;
  MonthCode = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5][month - 1];
  CenturyCode = [4, 2, 0, 6, 4, 2, 0][intDiv(year, 100) - 17];
  LeapYearCode = month <= 2 && leapYear(year) ? 1 : 0;
  return (YearCode + MonthCode + CenturyCode + day - LeapYearCode) % 7;
};

assert(0, dayOfWeek(1954, 12, 19)); // Christer

assert(5, dayOfWeek(1982, 4, 30)); // Kasper Fredag

assert(3, dayOfWeek(1984, 6, 13)); // Miranda Onsdag

// assert 5, dayOfWeek 1982,4,30 # Dongjiao
assert(1, dayOfWeek(2013, 8, 5)); // Numa Måndag

assert(6, dayOfWeek(2018, 9, 29)); // Noah Lördag

assert(2, dayOfWeek(2019, 12, 31));

assert(0, dayOfWeek(2020, 2, 9));

assert(1, dayOfWeek(2020, 2, 10));

assert(2, dayOfWeek(2020, 2, 11));

assert(3, dayOfWeek(2020, 2, 12));

assert(4, dayOfWeek(2020, 2, 13));

assert(5, dayOfWeek(2020, 2, 14));

assert(6, dayOfWeek(2020, 2, 15));

console.log('Ready!');

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsSUFBQSxTQUFBLEVBQUEsTUFBQSxFQUFBOztBQUVBLFFBQUEsR0FBVyxRQUFBLENBQUMsSUFBRCxDQUFBO0VBQVUsSUFBRyxJQUFBLEdBQU8sR0FBUCxLQUFjLENBQWpCO1dBQXdCLElBQUEsR0FBTyxHQUFQLEtBQWMsRUFBdEM7R0FBQSxNQUFBO1dBQTZDLElBQUEsR0FBTyxDQUFQLEtBQVksRUFBekQ7O0FBQVY7O0FBQ1gsTUFBQSxDQUFPLEtBQVAsRUFBYSxRQUFBLENBQVMsSUFBVCxDQUFiOztBQUNBLE1BQUEsQ0FBTyxJQUFQLEVBQVksUUFBQSxDQUFTLElBQVQsQ0FBWjs7QUFDQSxNQUFBLENBQU8sSUFBUCxFQUFZLFFBQUEsQ0FBUyxJQUFULENBQVo7O0FBQ0EsTUFBQSxDQUFPLEtBQVAsRUFBYSxRQUFBLENBQVMsSUFBVCxDQUFiOztBQUNBLE1BQUEsQ0FBTyxLQUFQLEVBQWEsUUFBQSxDQUFTLElBQVQsQ0FBYjs7QUFDQSxNQUFBLENBQU8sS0FBUCxFQUFhLFFBQUEsQ0FBUyxHQUFULENBQWI7O0FBRUEsTUFBQSxHQUFTLFFBQUEsQ0FBQyxDQUFELEVBQUcsQ0FBSCxDQUFBO1NBQVMsSUFBSSxDQUFDLEtBQUwsQ0FBVyxDQUFBLEdBQUUsQ0FBYjtBQUFUOztBQUNULE1BQUEsQ0FBTyxDQUFQLEVBQVUsTUFBQSxDQUFPLENBQVAsRUFBUyxDQUFULENBQVY7O0FBQ0EsTUFBQSxDQUFPLENBQVAsRUFBVSxNQUFBLENBQU8sQ0FBUCxFQUFTLENBQVQsQ0FBVjs7QUFDQSxNQUFBLENBQU8sQ0FBUCxFQUFVLE1BQUEsQ0FBTyxDQUFQLEVBQVMsQ0FBVCxDQUFWOztBQUNBLE1BQUEsQ0FBTyxDQUFQLEVBQVUsTUFBQSxDQUFPLEVBQVAsRUFBVSxDQUFWLENBQVY7O0FBRUEsU0FBQSxHQUFZLFFBQUEsQ0FBQyxJQUFELEVBQU0sS0FBTixFQUFZLEdBQVosQ0FBQTtBQUNYLE1BQUEsV0FBQSxFQUFBLFlBQUEsRUFBQSxTQUFBLEVBQUEsRUFBQSxFQUFBO0VBQUEsRUFBQSxHQUFLLElBQUEsR0FBTztFQUNaLFFBQUEsR0FBVyxDQUFDLEVBQUEsR0FBRyxNQUFBLENBQU8sRUFBUCxFQUFVLENBQVYsQ0FBSixDQUFBLEdBQW9CO0VBQy9CLFNBQUEsR0FBWSxDQUFDLENBQUQsRUFBRyxDQUFILEVBQUssQ0FBTCxFQUFPLENBQVAsRUFBUyxDQUFULEVBQVcsQ0FBWCxFQUFhLENBQWIsRUFBZSxDQUFmLEVBQWlCLENBQWpCLEVBQW1CLENBQW5CLEVBQXFCLENBQXJCLEVBQXVCLENBQXZCLENBQTBCLENBQUEsS0FBQSxHQUFNLENBQU47RUFDdEMsV0FBQSxHQUFjLENBQUMsQ0FBRCxFQUFHLENBQUgsRUFBSyxDQUFMLEVBQU8sQ0FBUCxFQUFTLENBQVQsRUFBVyxDQUFYLEVBQWEsQ0FBYixDQUFnQixDQUFBLE1BQUEsQ0FBTyxJQUFQLEVBQVksR0FBWixDQUFBLEdBQWlCLEVBQWpCO0VBQzlCLFlBQUEsR0FBa0IsS0FBQSxJQUFTLENBQVQsSUFBZSxRQUFBLENBQVMsSUFBVCxDQUFsQixHQUFxQyxDQUFyQyxHQUE0QztTQUMzRCxDQUFDLFFBQUEsR0FBVyxTQUFYLEdBQXVCLFdBQXZCLEdBQXFDLEdBQXJDLEdBQTJDLFlBQTVDLENBQUEsR0FBNEQ7QUFOakQ7O0FBUVosTUFBQSxDQUFPLENBQVAsRUFBVSxTQUFBLENBQVUsSUFBVixFQUFlLEVBQWYsRUFBa0IsRUFBbEIsQ0FBVixFQXhCQTs7QUF5QkEsTUFBQSxDQUFPLENBQVAsRUFBVSxTQUFBLENBQVUsSUFBVixFQUFlLENBQWYsRUFBaUIsRUFBakIsQ0FBVixFQXpCQTs7QUEwQkEsTUFBQSxDQUFPLENBQVAsRUFBVSxTQUFBLENBQVUsSUFBVixFQUFlLENBQWYsRUFBaUIsRUFBakIsQ0FBVixFQTFCQTs7O0FBNEJBLE1BQUEsQ0FBTyxDQUFQLEVBQVUsU0FBQSxDQUFVLElBQVYsRUFBZSxDQUFmLEVBQWlCLENBQWpCLENBQVYsRUE1QkE7O0FBNkJBLE1BQUEsQ0FBTyxDQUFQLEVBQVUsU0FBQSxDQUFVLElBQVYsRUFBZSxDQUFmLEVBQWlCLEVBQWpCLENBQVYsRUE3QkE7O0FBK0JBLE1BQUEsQ0FBTyxDQUFQLEVBQVUsU0FBQSxDQUFVLElBQVYsRUFBZSxFQUFmLEVBQWtCLEVBQWxCLENBQVY7O0FBRUEsTUFBQSxDQUFPLENBQVAsRUFBVSxTQUFBLENBQVUsSUFBVixFQUFlLENBQWYsRUFBaUIsQ0FBakIsQ0FBVjs7QUFDQSxNQUFBLENBQU8sQ0FBUCxFQUFVLFNBQUEsQ0FBVSxJQUFWLEVBQWUsQ0FBZixFQUFpQixFQUFqQixDQUFWOztBQUNBLE1BQUEsQ0FBTyxDQUFQLEVBQVUsU0FBQSxDQUFVLElBQVYsRUFBZSxDQUFmLEVBQWlCLEVBQWpCLENBQVY7O0FBQ0EsTUFBQSxDQUFPLENBQVAsRUFBVSxTQUFBLENBQVUsSUFBVixFQUFlLENBQWYsRUFBaUIsRUFBakIsQ0FBVjs7QUFDQSxNQUFBLENBQU8sQ0FBUCxFQUFVLFNBQUEsQ0FBVSxJQUFWLEVBQWUsQ0FBZixFQUFpQixFQUFqQixDQUFWOztBQUNBLE1BQUEsQ0FBTyxDQUFQLEVBQVUsU0FBQSxDQUFVLElBQVYsRUFBZSxDQUFmLEVBQWlCLEVBQWpCLENBQVY7O0FBQ0EsTUFBQSxDQUFPLENBQVAsRUFBVSxTQUFBLENBQVUsSUFBVixFQUFlLENBQWYsRUFBaUIsRUFBakIsQ0FBVjs7QUFFQSxPQUFPLENBQUMsR0FBUixDQUFZLFFBQVoiLCJzb3VyY2VzQ29udGVudCI6WyIjIGh0dHBzOi8vYXJ0b2ZtZW1vcnkuY29tL2Jsb2cvaG93LXRvLWNhbGN1bGF0ZS10aGUtZGF5LW9mLXRoZS13ZWVrLTQyMDMuaHRtbFxyXG5cclxubGVhcFllYXIgPSAoeWVhcikgLT4gaWYgeWVhciAlIDEwMCA9PSAwIHRoZW4geWVhciAlIDQwMCA9PSAwIGVsc2UgeWVhciAlIDQgPT0gMCBcclxuYXNzZXJ0IGZhbHNlLGxlYXBZZWFyIDIwMTlcclxuYXNzZXJ0IHRydWUsbGVhcFllYXIgMjAxNlxyXG5hc3NlcnQgdHJ1ZSxsZWFwWWVhciAyMDAwXHJcbmFzc2VydCBmYWxzZSxsZWFwWWVhciAxNzAwXHJcbmFzc2VydCBmYWxzZSxsZWFwWWVhciAxODAwXHJcbmFzc2VydCBmYWxzZSxsZWFwWWVhciAxMDBcclxuXHJcbmludERpdiA9IChhLGIpIC0+IE1hdGguZmxvb3IgYS9iXHJcbmFzc2VydCAwLCBpbnREaXYgMyw0XHJcbmFzc2VydCAxLCBpbnREaXYgNCw0XHJcbmFzc2VydCAyLCBpbnREaXYgOSw0XHJcbmFzc2VydCAzLCBpbnREaXYgMTUsNFxyXG5cclxuZGF5T2ZXZWVrID0gKHllYXIsbW9udGgsZGF5KSAtPlxyXG5cdFlZID0geWVhciAlIDEwMFxyXG5cdFllYXJDb2RlID0gKFlZK2ludERpdihZWSw0KSkgJSA3XHJcblx0TW9udGhDb2RlID0gWzAsMywzLDYsMSw0LDYsMiw1LDAsMyw1XVttb250aC0xXVxyXG5cdENlbnR1cnlDb2RlID0gWzQsMiwwLDYsNCwyLDBdW2ludERpdih5ZWFyLDEwMCktMTddXHJcblx0TGVhcFllYXJDb2RlID0gaWYgbW9udGggPD0gMiBhbmQgbGVhcFllYXIgeWVhciB0aGVuIDEgZWxzZSAwXHJcblx0KFllYXJDb2RlICsgTW9udGhDb2RlICsgQ2VudHVyeUNvZGUgKyBkYXkgLSBMZWFwWWVhckNvZGUpICUgN1xyXG5cclxuYXNzZXJ0IDAsIGRheU9mV2VlayAxOTU0LDEyLDE5ICMgQ2hyaXN0ZXJcclxuYXNzZXJ0IDUsIGRheU9mV2VlayAxOTgyLDQsMzAgIyBLYXNwZXIgRnJlZGFnXHJcbmFzc2VydCAzLCBkYXlPZldlZWsgMTk4NCw2LDEzICMgTWlyYW5kYSBPbnNkYWdcclxuIyBhc3NlcnQgNSwgZGF5T2ZXZWVrIDE5ODIsNCwzMCAjIERvbmdqaWFvXHJcbmFzc2VydCAxLCBkYXlPZldlZWsgMjAxMyw4LDUgIyBOdW1hIE3DpW5kYWdcclxuYXNzZXJ0IDYsIGRheU9mV2VlayAyMDE4LDksMjkgIyBOb2FoIEzDtnJkYWdcclxuXHJcbmFzc2VydCAyLCBkYXlPZldlZWsgMjAxOSwxMiwzMVxyXG5cclxuYXNzZXJ0IDAsIGRheU9mV2VlayAyMDIwLDIsOVxyXG5hc3NlcnQgMSwgZGF5T2ZXZWVrIDIwMjAsMiwxMFxyXG5hc3NlcnQgMiwgZGF5T2ZXZWVrIDIwMjAsMiwxMVxyXG5hc3NlcnQgMywgZGF5T2ZXZWVrIDIwMjAsMiwxMlxyXG5hc3NlcnQgNCwgZGF5T2ZXZWVrIDIwMjAsMiwxM1xyXG5hc3NlcnQgNSwgZGF5T2ZXZWVrIDIwMjAsMiwxNFxyXG5hc3NlcnQgNiwgZGF5T2ZXZWVrIDIwMjAsMiwxNVxyXG5cclxuY29uc29sZS5sb2cgJ1JlYWR5ISciXX0=
//# sourceURL=c:\Lab\2020\004-DayOfWeek\coffee\sketch.coffee