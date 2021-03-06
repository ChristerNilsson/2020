// Generated by CoffeeScript 2.4.1
var setup;

setup = function() {
  var H, S, W, c, i, j, k, l, len, len1, len2, len3, m, n, ref, ref1, ref2, ref3;
  S = 36 * 1.055;
  W = 19;
  H = 27;
  c = createCanvas(W * S + 1, H * S + 1);
  bg(1);
  sc(0);
  fc(0.9);
  sc();
  ref = range(2 * W + 1);
  for (k = 0, len = ref.length; k < len; k++) {
    i = ref[k];
    ref1 = range(2 * H + 1);
    for (l = 0, len1 = ref1.length; l < len1; l++) {
      j = ref1[l];
      if ((i + j) % 2 === 0) {
        rect(S / 2 * i, S / 2 * j, S / 2, S / 2);
      }
    }
  }
  sc(0);
  ref2 = range(W + 1);
  for (m = 0, len2 = ref2.length; m < len2; m++) {
    i = ref2[m];
    line(S * i, 0, S * i, H * S);
  }
  ref3 = range(H + 1);
  for (n = 0, len3 = ref3.length; n < len3; n++) {
    j = ref3[n];
    line(0, S * j, W * S, S * j);
  }
  return saveCanvas(c, 'lattice', 'bmp');
};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUE7O0FBQUEsS0FBQSxHQUFRLFFBQUEsQ0FBQSxDQUFBO0FBQ1AsTUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLEdBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBLElBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLEdBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBO0VBQUEsQ0FBQSxHQUFJLEVBQUEsR0FBRztFQUNQLENBQUEsR0FBSTtFQUNKLENBQUEsR0FBSTtFQUNKLENBQUEsR0FBSSxZQUFBLENBQWEsQ0FBQSxHQUFFLENBQUYsR0FBSSxDQUFqQixFQUFtQixDQUFBLEdBQUUsQ0FBRixHQUFJLENBQXZCO0VBQ0osRUFBQSxDQUFHLENBQUg7RUFDQSxFQUFBLENBQUcsQ0FBSDtFQUVBLEVBQUEsQ0FBRyxHQUFIO0VBQ0EsRUFBQSxDQUFBO0FBQ0E7RUFBQSxLQUFBLHFDQUFBOztBQUNDO0lBQUEsS0FBQSx3Q0FBQTs7TUFDQyxJQUFHLENBQUMsQ0FBQSxHQUFFLENBQUgsQ0FBQSxHQUFNLENBQU4sS0FBUyxDQUFaO1FBQW1CLElBQUEsQ0FBSyxDQUFBLEdBQUUsQ0FBRixHQUFJLENBQVQsRUFBVyxDQUFBLEdBQUUsQ0FBRixHQUFJLENBQWYsRUFBaUIsQ0FBQSxHQUFFLENBQW5CLEVBQXFCLENBQUEsR0FBRSxDQUF2QixFQUFuQjs7SUFERDtFQUREO0VBSUEsRUFBQSxDQUFHLENBQUg7QUFDQTtFQUFBLEtBQUEsd0NBQUE7O0lBQ0MsSUFBQSxDQUFLLENBQUEsR0FBRSxDQUFQLEVBQVMsQ0FBVCxFQUFXLENBQUEsR0FBRSxDQUFiLEVBQWUsQ0FBQSxHQUFFLENBQWpCO0VBREQ7QUFFQTtFQUFBLEtBQUEsd0NBQUE7O0lBQ0MsSUFBQSxDQUFLLENBQUwsRUFBTyxDQUFBLEdBQUUsQ0FBVCxFQUFXLENBQUEsR0FBRSxDQUFiLEVBQWUsQ0FBQSxHQUFFLENBQWpCO0VBREQ7U0FFQSxVQUFBLENBQVcsQ0FBWCxFQUFjLFNBQWQsRUFBeUIsS0FBekI7QUFuQk8iLCJzb3VyY2VzQ29udGVudCI6WyJzZXR1cCA9IC0+XHJcblx0UyA9IDM2KjEuMDU1XHJcblx0VyA9IDE5XHJcblx0SCA9IDI3XHJcblx0YyA9IGNyZWF0ZUNhbnZhcyBXKlMrMSxIKlMrMVxyXG5cdGJnIDFcclxuXHRzYyAwXHJcblxyXG5cdGZjIDAuOVxyXG5cdHNjKClcclxuXHRmb3IgaSBpbiByYW5nZSAyKlcrMVxyXG5cdFx0Zm9yIGogaW4gcmFuZ2UgMipIKzFcclxuXHRcdFx0aWYgKGkraiklMj09MCB0aGVuIHJlY3QgUy8yKmksUy8yKmosUy8yLFMvMlxyXG5cclxuXHRzYyAwXHJcblx0Zm9yIGkgaW4gcmFuZ2UgVysxXHJcblx0XHRsaW5lIFMqaSwwLFMqaSxIKlNcclxuXHRmb3IgaiBpbiByYW5nZSBIKzFcclxuXHRcdGxpbmUgMCxTKmosVypTLFMqalxyXG5cdHNhdmVDYW52YXMgYywgJ2xhdHRpY2UnLCAnYm1wJ1xyXG4iXX0=
//# sourceURL=c:\Lab\2020\007-LatticeMult\coffee\sketch.coffee