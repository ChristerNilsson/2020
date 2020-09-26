// Generated by CoffeeScript 2.4.1
var Converter, b2w, bmp, w2b, wgs;

Converter = class Converter {
  constructor(inp, outp) {
    this.arr = this.solve(inp, outp);
  }

  convert(x, y) {
    var a, b, c, d, e, f;
    [a, b, c, d, e, f] = this.arr;
    return [a * x + b * y + c, d * x + e * y + f];
  }

  solve(inp, outp) {
    var a, b, c, d, e, eqns, f;
    [a, b, c, d, e, f] = inp;
    eqns = [];
    eqns.push([a, b, 1, 0, 0, 0]);
    eqns.push([0, 0, 0, a, b, 1]);
    eqns.push([c, d, 1, 0, 0, 0]);
    eqns.push([0, 0, 0, c, d, 1]);
    eqns.push([e, f, 1, 0, 0, 0]);
    eqns.push([0, 0, 0, e, f, 1]);
    return this.gauss(eqns, outp);
  }

  // https://github.com/itsravenous/gaussian-elimination/blob/master/gauss.js
  gauss(A, x) {
    var c, i, j, k, l, len, len1, len2, len3, len4, len5, len6, len7, m, maxEl, maxRow, n, o, p, q, r, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, res, s, t;
    n = A.length;
    ref = range(n);
    for (l = 0, len = ref.length; l < len; l++) {
      i = ref[l];
      A[i].push(x[i]);
    }
    ref1 = range(n);
    for (m = 0, len1 = ref1.length; m < len1; m++) {
      i = ref1[m];
      maxEl = Math.abs(A[i][i]);
      maxRow = i;
      ref2 = range(i + 1, n);
      for (o = 0, len2 = ref2.length; o < len2; o++) {
        k = ref2[o];
        if (maxEl < Math.abs(A[k][i])) {
          maxEl = Math.abs(A[k][i]);
          maxRow = k;
        }
      }
      ref3 = range(i, n + 1);
      for (p = 0, len3 = ref3.length; p < len3; p++) {
        k = ref3[p];
        [A[maxRow][k], A[i][k]] = [A[i][k], A[maxRow][k]];
      }
      ref4 = range(i + 1, n);
      for (q = 0, len4 = ref4.length; q < len4; q++) {
        k = ref4[q];
        c = -A[k][i] / A[i][i];
        ref5 = range(i, n + 1);
        for (r = 0, len5 = ref5.length; r < len5; r++) {
          j = ref5[r];
          A[k][j] = i === j ? 0 : A[k][j] + c * A[i][j];
        }
      }
    }
    res = range(n).map(function() {
      return 0;
    });
    ref6 = range(n - 1, -1);
    for (s = 0, len6 = ref6.length; s < len6; s++) {
      i = ref6[s];
      res[i] = A[i][n] / A[i][i];
      ref7 = range(i - 1, -1);
      for (t = 0, len7 = ref7.length; t < len7; t++) {
        k = ref7[t];
        A[k][n] -= A[k][i] * res[i];
      }
    }
    return res;
  }

};

bmp = [
  338,
  1491,
  4299,
  1948,
  2963,
  5596 // x1,y1, x2,y2, x3,y3
];

wgs = [
  18.150709,
  59.285624,
  18.179902,
  59.283048,
  18.168739,
  59.269496 // lng1,lat1, lng2,lat2, lng3,lat3
];

b2w = new Converter(bmp, wgs);

assert([18.150709, 59.28562399999999], b2w.convert(bmp[0], bmp[1]));

assert([18.179902, 59.283048], b2w.convert(bmp[2], bmp[3]));

assert([18.168739, 59.269496], b2w.convert(bmp[4], bmp[5]));

w2b = new Converter(wgs, bmp);

assert([338.00000000023283, 1491], w2b.convert(wgs[0], wgs[1]));

assert([4299, 1948], w2b.convert(wgs[2], wgs[3]));

assert([2963, 5595.999999998137], w2b.convert(wgs[4], wgs[5]));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUEsU0FBQSxFQUFBLEdBQUEsRUFBQSxHQUFBLEVBQUEsR0FBQSxFQUFBOztBQUFNLFlBQU4sTUFBQSxVQUFBO0VBQ0MsV0FBYyxDQUFDLEdBQUQsRUFBSyxJQUFMLENBQUE7SUFBYyxJQUFDLENBQUEsR0FBRCxHQUFPLElBQUMsQ0FBQSxLQUFELENBQU8sR0FBUCxFQUFXLElBQVg7RUFBckI7O0VBRWQsT0FBVSxDQUFDLENBQUQsRUFBRyxDQUFILENBQUE7QUFDVCxRQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUE7SUFBQSxDQUFDLENBQUQsRUFBRyxDQUFILEVBQUssQ0FBTCxFQUFPLENBQVAsRUFBUyxDQUFULEVBQVcsQ0FBWCxDQUFBLEdBQWdCLElBQUMsQ0FBQTtXQUNqQixDQUFDLENBQUEsR0FBRSxDQUFGLEdBQUksQ0FBQSxHQUFFLENBQU4sR0FBUSxDQUFULEVBQVksQ0FBQSxHQUFFLENBQUYsR0FBSSxDQUFBLEdBQUUsQ0FBTixHQUFRLENBQXBCO0VBRlM7O0VBSVYsS0FBUSxDQUFDLEdBQUQsRUFBSyxJQUFMLENBQUE7QUFDUCxRQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsSUFBQSxFQUFBO0lBQUEsQ0FBQyxDQUFELEVBQUcsQ0FBSCxFQUFLLENBQUwsRUFBTyxDQUFQLEVBQVMsQ0FBVCxFQUFXLENBQVgsQ0FBQSxHQUFnQjtJQUNoQixJQUFBLEdBQU87SUFDUCxJQUFJLENBQUMsSUFBTCxDQUFVLENBQUMsQ0FBRCxFQUFJLENBQUosRUFBTyxDQUFQLEVBQVUsQ0FBVixFQUFhLENBQWIsRUFBZ0IsQ0FBaEIsQ0FBVjtJQUNBLElBQUksQ0FBQyxJQUFMLENBQVUsQ0FBQyxDQUFELEVBQUksQ0FBSixFQUFPLENBQVAsRUFBVSxDQUFWLEVBQWEsQ0FBYixFQUFnQixDQUFoQixDQUFWO0lBQ0EsSUFBSSxDQUFDLElBQUwsQ0FBVSxDQUFDLENBQUQsRUFBSSxDQUFKLEVBQU8sQ0FBUCxFQUFVLENBQVYsRUFBYSxDQUFiLEVBQWdCLENBQWhCLENBQVY7SUFDQSxJQUFJLENBQUMsSUFBTCxDQUFVLENBQUMsQ0FBRCxFQUFJLENBQUosRUFBTyxDQUFQLEVBQVUsQ0FBVixFQUFhLENBQWIsRUFBZ0IsQ0FBaEIsQ0FBVjtJQUNBLElBQUksQ0FBQyxJQUFMLENBQVUsQ0FBQyxDQUFELEVBQUksQ0FBSixFQUFPLENBQVAsRUFBVSxDQUFWLEVBQWEsQ0FBYixFQUFnQixDQUFoQixDQUFWO0lBQ0EsSUFBSSxDQUFDLElBQUwsQ0FBVSxDQUFDLENBQUQsRUFBSSxDQUFKLEVBQU8sQ0FBUCxFQUFVLENBQVYsRUFBYSxDQUFiLEVBQWdCLENBQWhCLENBQVY7V0FDQSxJQUFDLENBQUEsS0FBRCxDQUFPLElBQVAsRUFBWSxJQUFaO0VBVE8sQ0FOUjs7O0VBa0JBLEtBQVEsQ0FBQyxDQUFELEVBQUksQ0FBSixDQUFBO0FBQ1AsUUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLEdBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBLElBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBLElBQUEsRUFBQSxJQUFBLEVBQUEsQ0FBQSxFQUFBLEtBQUEsRUFBQSxNQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxHQUFBLEVBQUEsSUFBQSxFQUFBLElBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBLElBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBLEdBQUEsRUFBQSxDQUFBLEVBQUE7SUFBQSxDQUFBLEdBQUksQ0FBQyxDQUFDO0FBQ047SUFBQSxLQUFBLHFDQUFBOztNQUNDLENBQUUsQ0FBQSxDQUFBLENBQUUsQ0FBQyxJQUFMLENBQVUsQ0FBRSxDQUFBLENBQUEsQ0FBWjtJQUREO0FBR0E7SUFBQSxLQUFBLHdDQUFBOztNQUNDLEtBQUEsR0FBUSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUUsQ0FBQSxDQUFBLENBQUcsQ0FBQSxDQUFBLENBQWQ7TUFDUixNQUFBLEdBQVM7QUFDVDtNQUFBLEtBQUEsd0NBQUE7O1FBQ0MsSUFBRyxLQUFBLEdBQVEsSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFFLENBQUEsQ0FBQSxDQUFHLENBQUEsQ0FBQSxDQUFkLENBQVg7VUFDQyxLQUFBLEdBQVEsSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFFLENBQUEsQ0FBQSxDQUFHLENBQUEsQ0FBQSxDQUFkO1VBQ1IsTUFBQSxHQUFTLEVBRlY7O01BREQ7QUFLQTtNQUFBLEtBQUEsd0NBQUE7O1FBQ0MsQ0FBQyxDQUFFLENBQUEsTUFBQSxDQUFRLENBQUEsQ0FBQSxDQUFYLEVBQWUsQ0FBRSxDQUFBLENBQUEsQ0FBRyxDQUFBLENBQUEsQ0FBcEIsQ0FBQSxHQUEwQixDQUFDLENBQUUsQ0FBQSxDQUFBLENBQUcsQ0FBQSxDQUFBLENBQU4sRUFBVSxDQUFFLENBQUEsTUFBQSxDQUFRLENBQUEsQ0FBQSxDQUFwQjtNQUQzQjtBQUdBO01BQUEsS0FBQSx3Q0FBQTs7UUFDQyxDQUFBLEdBQUksQ0FBQyxDQUFFLENBQUEsQ0FBQSxDQUFHLENBQUEsQ0FBQSxDQUFOLEdBQVcsQ0FBRSxDQUFBLENBQUEsQ0FBRyxDQUFBLENBQUE7QUFDcEI7UUFBQSxLQUFBLHdDQUFBOztVQUNDLENBQUUsQ0FBQSxDQUFBLENBQUcsQ0FBQSxDQUFBLENBQUwsR0FBYSxDQUFBLEtBQUcsQ0FBTixHQUFhLENBQWIsR0FBb0IsQ0FBRSxDQUFBLENBQUEsQ0FBRyxDQUFBLENBQUEsQ0FBTCxHQUFVLENBQUEsR0FBSSxDQUFFLENBQUEsQ0FBQSxDQUFHLENBQUEsQ0FBQTtRQURsRDtNQUZEO0lBWEQ7SUFnQkEsR0FBQSxHQUFNLEtBQUEsQ0FBTSxDQUFOLENBQVEsQ0FBQyxHQUFULENBQWEsUUFBQSxDQUFBLENBQUE7YUFBRztJQUFILENBQWI7QUFDTjtJQUFBLEtBQUEsd0NBQUE7O01BQ0MsR0FBSSxDQUFBLENBQUEsQ0FBSixHQUFTLENBQUUsQ0FBQSxDQUFBLENBQUcsQ0FBQSxDQUFBLENBQUwsR0FBVSxDQUFFLENBQUEsQ0FBQSxDQUFHLENBQUEsQ0FBQTtBQUN4QjtNQUFBLEtBQUEsd0NBQUE7O1FBQ0MsQ0FBRSxDQUFBLENBQUEsQ0FBRyxDQUFBLENBQUEsQ0FBTCxJQUFXLENBQUUsQ0FBQSxDQUFBLENBQUcsQ0FBQSxDQUFBLENBQUwsR0FBVSxHQUFJLENBQUEsQ0FBQTtNQUQxQjtJQUZEO1dBS0E7RUEzQk87O0FBbkJUOztBQWdEQSxHQUFBLEdBQU07RUFBQyxHQUFEO0VBQUssSUFBTDtFQUFXLElBQVg7RUFBZ0IsSUFBaEI7RUFBc0IsSUFBdEI7RUFBMkIsSUFBM0I7OztBQUNOLEdBQUEsR0FBTTtFQUFDLFNBQUQ7RUFBVyxTQUFYO0VBQXNCLFNBQXRCO0VBQWdDLFNBQWhDO0VBQTJDLFNBQTNDO0VBQXFELFNBQXJEOzs7QUFFTixHQUFBLEdBQU0sSUFBSSxTQUFKLENBQWMsR0FBZCxFQUFrQixHQUFsQjs7QUFDTixNQUFBLENBQU8sQ0FBQyxTQUFELEVBQVksaUJBQVosQ0FBUCxFQUF1QyxHQUFHLENBQUMsT0FBSixDQUFZLEdBQUksQ0FBQSxDQUFBLENBQWhCLEVBQW1CLEdBQUksQ0FBQSxDQUFBLENBQXZCLENBQXZDOztBQUNBLE1BQUEsQ0FBTyxDQUFDLFNBQUQsRUFBWSxTQUFaLENBQVAsRUFBK0IsR0FBRyxDQUFDLE9BQUosQ0FBWSxHQUFJLENBQUEsQ0FBQSxDQUFoQixFQUFtQixHQUFJLENBQUEsQ0FBQSxDQUF2QixDQUEvQjs7QUFDQSxNQUFBLENBQU8sQ0FBQyxTQUFELEVBQVksU0FBWixDQUFQLEVBQStCLEdBQUcsQ0FBQyxPQUFKLENBQVksR0FBSSxDQUFBLENBQUEsQ0FBaEIsRUFBbUIsR0FBSSxDQUFBLENBQUEsQ0FBdkIsQ0FBL0I7O0FBRUEsR0FBQSxHQUFNLElBQUksU0FBSixDQUFjLEdBQWQsRUFBa0IsR0FBbEI7O0FBQ04sTUFBQSxDQUFPLENBQUMsa0JBQUQsRUFBcUIsSUFBckIsQ0FBUCxFQUFtQyxHQUFHLENBQUMsT0FBSixDQUFZLEdBQUksQ0FBQSxDQUFBLENBQWhCLEVBQW1CLEdBQUksQ0FBQSxDQUFBLENBQXZCLENBQW5DOztBQUNBLE1BQUEsQ0FBTyxDQUFDLElBQUQsRUFBTyxJQUFQLENBQVAsRUFBc0IsR0FBRyxDQUFDLE9BQUosQ0FBWSxHQUFJLENBQUEsQ0FBQSxDQUFoQixFQUFtQixHQUFJLENBQUEsQ0FBQSxDQUF2QixDQUF0Qjs7QUFDQSxNQUFBLENBQU8sQ0FBQyxJQUFELEVBQU8saUJBQVAsQ0FBUCxFQUFrQyxHQUFHLENBQUMsT0FBSixDQUFZLEdBQUksQ0FBQSxDQUFBLENBQWhCLEVBQW1CLEdBQUksQ0FBQSxDQUFBLENBQXZCLENBQWxDIiwic291cmNlc0NvbnRlbnQiOlsiY2xhc3MgQ29udmVydGVyXHJcblx0Y29uc3RydWN0b3IgOiAoaW5wLG91dHApIC0+IEBhcnIgPSBAc29sdmUgaW5wLG91dHBcclxuXHJcblx0Y29udmVydCA6ICh4LHkpIC0+XHJcblx0XHRbYSxiLGMsZCxlLGZdID0gQGFyclxyXG5cdFx0W2EqeCtiKnkrYywgZCp4K2UqeStmXVxyXG5cclxuXHRzb2x2ZSA6IChpbnAsb3V0cCkgLT5cclxuXHRcdFthLGIsYyxkLGUsZl0gPSBpbnBcclxuXHRcdGVxbnMgPSBbXVxyXG5cdFx0ZXFucy5wdXNoIFthLCBiLCAxLCAwLCAwLCAwXVxyXG5cdFx0ZXFucy5wdXNoIFswLCAwLCAwLCBhLCBiLCAxXVxyXG5cdFx0ZXFucy5wdXNoIFtjLCBkLCAxLCAwLCAwLCAwXVxyXG5cdFx0ZXFucy5wdXNoIFswLCAwLCAwLCBjLCBkLCAxXVxyXG5cdFx0ZXFucy5wdXNoIFtlLCBmLCAxLCAwLCAwLCAwXVxyXG5cdFx0ZXFucy5wdXNoIFswLCAwLCAwLCBlLCBmLCAxXVxyXG5cdFx0QGdhdXNzIGVxbnMsb3V0cFxyXG5cclxuXHQjIGh0dHBzOi8vZ2l0aHViLmNvbS9pdHNyYXZlbm91cy9nYXVzc2lhbi1lbGltaW5hdGlvbi9ibG9iL21hc3Rlci9nYXVzcy5qc1xyXG5cdGdhdXNzIDogKEEsIHgpIC0+XHJcblx0XHRuID0gQS5sZW5ndGhcclxuXHRcdGZvciBpIGluIHJhbmdlIG5cclxuXHRcdFx0QVtpXS5wdXNoIHhbaV1cclxuXHJcblx0XHRmb3IgaSBpbiByYW5nZSBuIFxyXG5cdFx0XHRtYXhFbCA9IE1hdGguYWJzIEFbaV1baV1cclxuXHRcdFx0bWF4Um93ID0gaVxyXG5cdFx0XHRmb3IgayBpbiByYW5nZSBpKzEsIG5cclxuXHRcdFx0XHRpZiBtYXhFbCA8IE1hdGguYWJzIEFba11baV1cclxuXHRcdFx0XHRcdG1heEVsID0gTWF0aC5hYnMgQVtrXVtpXVxyXG5cdFx0XHRcdFx0bWF4Um93ID0ga1xyXG5cclxuXHRcdFx0Zm9yIGsgaW4gcmFuZ2UgaSxuKzFcclxuXHRcdFx0XHRbQVttYXhSb3ddW2tdLCBBW2ldW2tdXSA9IFtBW2ldW2tdLCBBW21heFJvd11ba11dXHJcblxyXG5cdFx0XHRmb3IgayBpbiByYW5nZSBpKzEsIG5cclxuXHRcdFx0XHRjID0gLUFba11baV0gLyBBW2ldW2ldXHJcblx0XHRcdFx0Zm9yIGogaW4gcmFuZ2UgaSxuKzFcclxuXHRcdFx0XHRcdEFba11bal0gPSBpZiBpPT1qIHRoZW4gMCBlbHNlIEFba11bal0gKyBjICogQVtpXVtqXVxyXG5cclxuXHRcdHJlcyA9IHJhbmdlKG4pLm1hcCAtPiAwXHJcblx0XHRmb3IgaSBpbiByYW5nZSBuLTEsIC0xXHJcblx0XHRcdHJlc1tpXSA9IEFbaV1bbl0gLyBBW2ldW2ldXHJcblx0XHRcdGZvciBrIGluIHJhbmdlIGktMSwgLTFcclxuXHRcdFx0XHRBW2tdW25dIC09IEFba11baV0gKiByZXNbaV1cclxuXHJcblx0XHRyZXNcclxuXHJcbmJtcCA9IFszMzgsMTQ5MSwgNDI5OSwxOTQ4LCAyOTYzLDU1OTZdICMgeDEseTEsIHgyLHkyLCB4Myx5M1xyXG53Z3MgPSBbMTguMTUwNzA5LDU5LjI4NTYyNCwgMTguMTc5OTAyLDU5LjI4MzA0OCwgMTguMTY4NzM5LDU5LjI2OTQ5Nl0gIyBsbmcxLGxhdDEsIGxuZzIsbGF0MiwgbG5nMyxsYXQzXHJcblxyXG5iMncgPSBuZXcgQ29udmVydGVyIGJtcCx3Z3NcclxuYXNzZXJ0IFsxOC4xNTA3MDksIDU5LjI4NTYyMzk5OTk5OTk5XSwgYjJ3LmNvbnZlcnQgYm1wWzBdLGJtcFsxXVxyXG5hc3NlcnQgWzE4LjE3OTkwMiwgNTkuMjgzMDQ4XSwgYjJ3LmNvbnZlcnQgYm1wWzJdLGJtcFszXVxyXG5hc3NlcnQgWzE4LjE2ODczOSwgNTkuMjY5NDk2XSwgYjJ3LmNvbnZlcnQgYm1wWzRdLGJtcFs1XVxyXG5cclxudzJiID0gbmV3IENvbnZlcnRlciB3Z3MsYm1wXHJcbmFzc2VydCBbMzM4LjAwMDAwMDAwMDIzMjgzLCAxNDkxXSwgdzJiLmNvbnZlcnQgd2dzWzBdLHdnc1sxXVxyXG5hc3NlcnQgWzQyOTksIDE5NDhdLCAgdzJiLmNvbnZlcnQgd2dzWzJdLHdnc1szXVxyXG5hc3NlcnQgWzI5NjMsIDU1OTUuOTk5OTk5OTk4MTM3XSwgdzJiLmNvbnZlcnQgd2dzWzRdLHdnc1s1XVxyXG4iXX0=
//# sourceURL=c:\Lab\2020\003-LinearSolve\coffee\sketch.coffee