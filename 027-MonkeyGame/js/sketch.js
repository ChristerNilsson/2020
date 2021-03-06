// Generated by CoffeeScript 2.4.1
var LEVEL, counter, draw, mousePressed, range, rectangles, setup, skapa, start;

range = _.range;

rectangles = [];

counter = 0;

LEVEL = 2;

start = 0;

setup = function() {
  createCanvas(600, 600);
  textAlign(CENTER, CENTER);
  return skapa();
};

skapa = function() {
  var a, antal, b, c, i, j, len, rectangle, results, x, y;
  start = frameCount;
  counter = LEVEL;
  results = [];
  while (rectangles.length < LEVEL) {
    i = rectangles.length;
    x = 30 + random(540);
    y = 30 + random(540);
    rectangle = [x, y, i];
    antal = 0;
    for (j = 0, len = rectangles.length; j < len; j++) {
      [a, b, c] = rectangles[j];
      if (abs(x - a) < 60 && abs(y - b) < 60) {
        antal++;
      }
    }
    if (antal === 0) {
      results.push(rectangles.push([x, y, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[i]]));
    } else {
      results.push(void 0);
    }
  }
  return results;
};

draw = function() {
  var j, len, nr, x, y;
  background(0);
  textSize(50);
  for (j = 0, len = rectangles.length; j < len; j++) {
    [x, y, nr] = rectangles[j];
    fill(255);
    if (frameCount < start + 60) {
      text(nr, x, y + 4);
    } else {
      rect(x - 30, y - 30, 60, 60);
    }
  }
  return fill(255);
};

mousePressed = function() {
  var i, rectangle, x, y;
  rectangle = rectangles[0];
  [x, y, i] = rectangle;
  if (mouseX < 600 && mouseY < 600) {
    counter--;
  }
  if ((x - 30 < mouseX && mouseX < x + 30) && (y - 30 < mouseY && mouseY < y + 30)) {
    rectangles.shift();
  }
  if (rectangles.length === 0) {
    if (counter === 0) {
      LEVEL++;
    } else {
      LEVEL--;
    }
    if (LEVEL === 0) {
      LEVEL++;
    }
    return skapa();
  }
};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUEsS0FBQSxFQUFBLE9BQUEsRUFBQSxJQUFBLEVBQUEsWUFBQSxFQUFBLEtBQUEsRUFBQSxVQUFBLEVBQUEsS0FBQSxFQUFBLEtBQUEsRUFBQTs7QUFBQSxLQUFBLEdBQVEsQ0FBQyxDQUFDOztBQUNWLFVBQUEsR0FBYTs7QUFDYixPQUFBLEdBQVU7O0FBQ1YsS0FBQSxHQUFROztBQUNSLEtBQUEsR0FBUTs7QUFFUixLQUFBLEdBQVEsUUFBQSxDQUFBLENBQUE7RUFDUCxZQUFBLENBQWEsR0FBYixFQUFpQixHQUFqQjtFQUNBLFNBQUEsQ0FBVSxNQUFWLEVBQWlCLE1BQWpCO1NBQ0EsS0FBQSxDQUFBO0FBSE87O0FBS1IsS0FBQSxHQUFRLFFBQUEsQ0FBQSxDQUFBO0FBQ1AsTUFBQSxDQUFBLEVBQUEsS0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxHQUFBLEVBQUEsU0FBQSxFQUFBLE9BQUEsRUFBQSxDQUFBLEVBQUE7RUFBQSxLQUFBLEdBQVE7RUFDUixPQUFBLEdBQVU7QUFDVjtTQUFNLFVBQVUsQ0FBQyxNQUFYLEdBQW9CLEtBQTFCO0lBQ0MsQ0FBQSxHQUFJLFVBQVUsQ0FBQztJQUNmLENBQUEsR0FBSSxFQUFBLEdBQUssTUFBQSxDQUFPLEdBQVA7SUFDVCxDQUFBLEdBQUksRUFBQSxHQUFLLE1BQUEsQ0FBTyxHQUFQO0lBQ1QsU0FBQSxHQUFZLENBQUMsQ0FBRCxFQUFHLENBQUgsRUFBSyxDQUFMO0lBQ1osS0FBQSxHQUFRO0lBQ1IsS0FBQSw0Q0FBQTtNQUFJLENBQUMsQ0FBRCxFQUFHLENBQUgsRUFBSyxDQUFMO01BQ0gsSUFBRyxHQUFBLENBQUksQ0FBQSxHQUFFLENBQU4sQ0FBQSxHQUFXLEVBQVgsSUFBa0IsR0FBQSxDQUFJLENBQUEsR0FBRSxDQUFOLENBQUEsR0FBVyxFQUFoQztRQUF5QyxLQUFBLEdBQXpDOztJQUREO0lBRUEsSUFBRyxLQUFBLEtBQVMsQ0FBWjttQkFBbUIsVUFBVSxDQUFDLElBQVgsQ0FBZ0IsQ0FBQyxDQUFELEVBQUcsQ0FBSCxFQUFLLHNDQUF1QyxDQUFBLENBQUEsQ0FBNUMsQ0FBaEIsR0FBbkI7S0FBQSxNQUFBOzJCQUFBOztFQVJELENBQUE7O0FBSE87O0FBYVIsSUFBQSxHQUFPLFFBQUEsQ0FBQSxDQUFBO0FBQ04sTUFBQSxDQUFBLEVBQUEsR0FBQSxFQUFBLEVBQUEsRUFBQSxDQUFBLEVBQUE7RUFBQSxVQUFBLENBQVcsQ0FBWDtFQUNBLFFBQUEsQ0FBUyxFQUFUO0VBQ0EsS0FBQSw0Q0FBQTtJQUFJLENBQUMsQ0FBRCxFQUFHLENBQUgsRUFBSyxFQUFMO0lBQ0gsSUFBQSxDQUFLLEdBQUw7SUFDQSxJQUFHLFVBQUEsR0FBYSxLQUFBLEdBQVEsRUFBeEI7TUFDQyxJQUFBLENBQUssRUFBTCxFQUFRLENBQVIsRUFBVSxDQUFBLEdBQUUsQ0FBWixFQUREO0tBQUEsTUFBQTtNQUdDLElBQUEsQ0FBSyxDQUFBLEdBQUUsRUFBUCxFQUFVLENBQUEsR0FBRSxFQUFaLEVBQWUsRUFBZixFQUFrQixFQUFsQixFQUhEOztFQUZEO1NBTUEsSUFBQSxDQUFLLEdBQUw7QUFUTTs7QUFXUCxZQUFBLEdBQWUsUUFBQSxDQUFBLENBQUE7QUFDZCxNQUFBLENBQUEsRUFBQSxTQUFBLEVBQUEsQ0FBQSxFQUFBO0VBQUEsU0FBQSxHQUFZLFVBQVcsQ0FBQSxDQUFBO0VBQ3ZCLENBQUMsQ0FBRCxFQUFHLENBQUgsRUFBSyxDQUFMLENBQUEsR0FBVTtFQUNWLElBQUcsTUFBQSxHQUFTLEdBQVQsSUFBaUIsTUFBQSxHQUFTLEdBQTdCO0lBQXNDLE9BQUEsR0FBdEM7O0VBQ0EsSUFBRyxDQUFBLENBQUEsR0FBRSxFQUFGLEdBQU8sTUFBUCxJQUFPLE1BQVAsR0FBZ0IsQ0FBQSxHQUFFLEVBQWxCLENBQUEsSUFBeUIsQ0FBQSxDQUFBLEdBQUUsRUFBRixHQUFPLE1BQVAsSUFBTyxNQUFQLEdBQWdCLENBQUEsR0FBRSxFQUFsQixDQUE1QjtJQUNDLFVBQVUsQ0FBQyxLQUFYLENBQUEsRUFERDs7RUFFQSxJQUFHLFVBQVUsQ0FBQyxNQUFYLEtBQXFCLENBQXhCO0lBQ0MsSUFBRyxPQUFBLEtBQVcsQ0FBZDtNQUFxQixLQUFBLEdBQXJCO0tBQUEsTUFBQTtNQUFrQyxLQUFBLEdBQWxDOztJQUNBLElBQUcsS0FBQSxLQUFTLENBQVo7TUFBbUIsS0FBQSxHQUFuQjs7V0FDQSxLQUFBLENBQUEsRUFIRDs7QUFOYyIsInNvdXJjZXNDb250ZW50IjpbInJhbmdlID0gXy5yYW5nZSBcclxucmVjdGFuZ2xlcyA9IFtdXHJcbmNvdW50ZXIgPSAwXHJcbkxFVkVMID0gMlxyXG5zdGFydCA9IDBcclxuXHJcbnNldHVwID0gLT5cclxuXHRjcmVhdGVDYW52YXMgNjAwLDYwMFxyXG5cdHRleHRBbGlnbiBDRU5URVIsQ0VOVEVSXHJcblx0c2thcGEoKVxyXG5cclxuc2thcGEgPSAtPlxyXG5cdHN0YXJ0ID0gZnJhbWVDb3VudFxyXG5cdGNvdW50ZXIgPSBMRVZFTFxyXG5cdHdoaWxlIHJlY3RhbmdsZXMubGVuZ3RoIDwgTEVWRUxcclxuXHRcdGkgPSByZWN0YW5nbGVzLmxlbmd0aFxyXG5cdFx0eCA9IDMwICsgcmFuZG9tIDU0MFxyXG5cdFx0eSA9IDMwICsgcmFuZG9tIDU0MFxyXG5cdFx0cmVjdGFuZ2xlID0gW3gseSxpXVxyXG5cdFx0YW50YWwgPSAwXHJcblx0XHRmb3IgW2EsYixjXSBpbiByZWN0YW5nbGVzXHJcblx0XHRcdGlmIGFicyh4LWEpIDwgNjAgYW5kIGFicyh5LWIpIDwgNjAgIHRoZW4gYW50YWwrK1xyXG5cdFx0aWYgYW50YWwgPT0gMCB0aGVuIHJlY3RhbmdsZXMucHVzaCBbeCx5LCcwMTIzNDU2Nzg5QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVonW2ldXVxyXG5cclxuZHJhdyA9IC0+XHJcblx0YmFja2dyb3VuZCAwXHJcblx0dGV4dFNpemUgNTBcclxuXHRmb3IgW3gseSxucl0gaW4gcmVjdGFuZ2xlc1xyXG5cdFx0ZmlsbCAyNTVcclxuXHRcdGlmIGZyYW1lQ291bnQgPCBzdGFydCArIDYwIFxyXG5cdFx0XHR0ZXh0IG5yLHgseSs0XHJcblx0XHRlbHNlXHJcblx0XHRcdHJlY3QgeC0zMCx5LTMwLDYwLDYwXHJcblx0ZmlsbCAyNTVcclxuXHJcbm1vdXNlUHJlc3NlZCA9IC0+XHJcblx0cmVjdGFuZ2xlID0gcmVjdGFuZ2xlc1swXVxyXG5cdFt4LHksaV0gPSByZWN0YW5nbGVcclxuXHRpZiBtb3VzZVggPCA2MDAgYW5kIG1vdXNlWSA8IDYwMCB0aGVuIGNvdW50ZXItLVxyXG5cdGlmIHgtMzAgPCBtb3VzZVggPCB4KzMwIGFuZCB5LTMwIDwgbW91c2VZIDwgeSszMFxyXG5cdFx0cmVjdGFuZ2xlcy5zaGlmdCgpXHJcblx0aWYgcmVjdGFuZ2xlcy5sZW5ndGggPT0gMFxyXG5cdFx0aWYgY291bnRlciA9PSAwIHRoZW4gTEVWRUwrKyBlbHNlIExFVkVMLS1cclxuXHRcdGlmIExFVkVMID09IDAgdGhlbiBMRVZFTCsrXHJcblx0XHRza2FwYSgpXHJcbiJdfQ==
//# sourceURL=c:\Lab\2020\027-MonkeyGame\coffee\sketch.coffee