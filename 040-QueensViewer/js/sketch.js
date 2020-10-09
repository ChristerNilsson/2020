// Generated by CoffeeScript 2.4.1
var constraints, current, drawChessBoard, drawOptions, explanations, keyPressed, preload, setColor, setup, showChoices, snapshots, xdraw;

constraints = null;

snapshots = null;

current = 1;

explanations = [];

explanations.push('All primary columns and rows have 8 options. Item CA is chosen. Option a1 is first');

explanations.push('Items CA and R1 is hidden. All remaining columns and rows have 6 legal options. Item CB is chosen. Option b3 is selected');

explanations.push('Items CB and R3 is hidden. Shortest item is CC. Option c5 is selected');

explanations.push('Items CC and R5 is hidden. Shortest item is CF. Option f4 is selected');

explanations.push('Items CF and R4 is hidden. Shortest item is CH. Option h7 is selected');

explanations.push('Items CH and R7 is hidden. Shortest item is CH. R6 is empty, h7 is backtracked');

explanations.push('Continue');

explanations.push("Option f4 can't be replaced. f4 is backtracked");

explanations.push('Continue');

explanations.push("Option c5 replaced by c6");

setColor = function(item, options) {
  
  //console.log item,'x',options
  return fill(options.includes(item) ? 'black' : 'red');
};

drawChessBoard = function() {
  var R, c, choices, i, index, j, k, l, len, len1, len2, m, ref, ref1, results, x, y;
  R = 50;
  x = width / 2 - 4 * R;
  y = height / 2 - R;
  ref = range(8);
  for (k = 0, len = ref.length; k < len; k++) {
    i = ref[k];
    ref1 = range(8);
    for (l = 0, len1 = ref1.length; l < len1; l++) {
      j = ref1[l];
      fill((i + j) % 2 === 0 ? 'white' : 'black');
      rect(x + R * i, y + R * j, R, R);
    }
  }
  fill('green');
  textSize(24);
  choices = snapshots[current].choices.trim().split(' ');
  results = [];
  for (index = m = 0, len2 = choices.length; m < len2; index = ++m) {
    c = choices[index];
    if (c === '') {
      continue;
    }
    //console.log c
    i = 0.5 + 'abcdefgh'.indexOf(c[0]);
    j = 8 - 0.5 - '12345678'.indexOf(c[1]);
    //console.log i,j
    //fill 'green'
    stroke('black');
    fill(index === choices.length - 1 ? 'yellow' : 'green');
    circle(x + R * i, y + R * j, 0.4 * R);
    noStroke();
    fill(index === choices.length - 1 ? 'green' : 'yellow');
    results.push(text(c, x + R * i, y + R * j));
  }
  return results;
};

preload = function() {
  return fetch("8queens.json").then((response) => {
    return response.json();
  }).then((json) => {
    ({constraints, snapshots} = json);
    console.log(json);
    return xdraw();
  });
};

setup = function() {
  return createCanvas(1200, 750);
};

drawOptions = function(prompt, offset, w, a, b) {
  var i, item, j, k, key, l, len, len1, option, results;
  textAlign(LEFT, CENTER);
  fill('yellow');
  noStroke();
  text(prompt, offset + 25 * 0.7, 50);
  stroke('yellow');
  line(offset + 25 * 0.7, 60, offset + w + 10, 60);
  line(offset + 25 * 0.7, 60, offset + w + 10, 60);
  noStroke();
  i = 0;
  textAlign(CENTER, CENTER);
  results = [];
  for (key in a) {
    option = a[key];
    option = option.split(' ');
    fill('yellow');
    text(key, offset + 25 + 25 * i, 50 + 25);
    //fill 'black'
    //text option.length,offset+25+25*i,50+25+25
    if (key in b) {
      for (j = k = 0, len = option.length; k < len; j = ++k) {
        item = option[j];
        if (b) {
          setColor(item, b[key]);
        } else {
          fill('black');
        }
        text(item, offset + 25 + 25 * i, 100 + 25 * j);
      }
    } else {
      fill('red');
      for (j = l = 0, len1 = option.length; l < len1; j = ++l) {
        item = option[j];
        text(item, offset + 25 + 25 * i, 100 + 25 * j);
      }
    }
    results.push(i++);
  }
  return results;
};

showChoices = function(snapshot) {
  var c, i, k, l, len, len1, ref, ref1, results;
  fill('white');
  stroke('black');
  ref = range(8);
  for (k = 0, len = ref.length; k < len; k++) {
    i = ref[k];
    rect(20 + 40 * i, 10, 40, 30);
  }
  noStroke();
  fill('black');
  textAlign(CENTER, CENTER);
  ref1 = snapshots[current].choices.trim().split(' ');
  results = [];
  for (i = l = 0, len1 = ref1.length; l < len1; i = ++l) {
    c = ref1[i];
    results.push(text(c, 40 + 40 * i, 28));
  }
  return results;
};

xdraw = function() {
  var a, ap, ax, b, bp, bx, items, snapshot;
  bg(0.5);
  if (!constraints) {
    return;
  }
  items = constraints.primaries.concat(constraints.secondaries);
  textSize(14);
  textAlign(CENTER, CENTER);
  fill('yellow');
  a = snapshots[current - 1];
  b = snapshots[current];
  ap = a ? a.primaries : {};
  ax = a ? a.secondaries : {};
  bp = b ? b.primaries : {};
  bx = b ? b.secondaries : {};
  drawOptions('primary items', 0 * 25, 16 * 25, ap, bp);
  drawOptions('secondary items', 16 * 25, 30 * 25, ax, bx);
  drawChessBoard();
  snapshot = b;
  fill('black');
  textSize(32);
  if (snapshot) {
    showChoices();
    textAlign(CENTER, CENTER);
    text(snapshot.action, width / 2, 25);
  }
  textAlign(RIGHT, CENTER);
  text(`${current - 1} of ${snapshots.length - 2} snapshots`, width - 40, 25);
  textAlign(LEFT, CENTER);
  textSize(14);
  fill('white');
  return text(explanations[current], 15, 100 + 8 * 25);
};

keyPressed = function() {
  if (key === 'ArrowLeft') {
    current--;
  }
  if (key === 'ArrowRight') {
    current++;
  }
  if (current < 1) {
    current = 1;
  }
  if (current >= snapshots.length) {
    current = snapshots.length - 1;
  }
  return xdraw();
};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUEsV0FBQSxFQUFBLE9BQUEsRUFBQSxjQUFBLEVBQUEsV0FBQSxFQUFBLFlBQUEsRUFBQSxVQUFBLEVBQUEsT0FBQSxFQUFBLFFBQUEsRUFBQSxLQUFBLEVBQUEsV0FBQSxFQUFBLFNBQUEsRUFBQTs7QUFBQSxXQUFBLEdBQWM7O0FBQ2QsU0FBQSxHQUFZOztBQUNaLE9BQUEsR0FBVTs7QUFFVixZQUFBLEdBQWU7O0FBQ2YsWUFBWSxDQUFDLElBQWIsQ0FBa0Isb0ZBQWxCOztBQUNBLFlBQVksQ0FBQyxJQUFiLENBQWtCLDBIQUFsQjs7QUFDQSxZQUFZLENBQUMsSUFBYixDQUFrQix1RUFBbEI7O0FBQ0EsWUFBWSxDQUFDLElBQWIsQ0FBa0IsdUVBQWxCOztBQUNBLFlBQVksQ0FBQyxJQUFiLENBQWtCLHVFQUFsQjs7QUFDQSxZQUFZLENBQUMsSUFBYixDQUFrQixnRkFBbEI7O0FBQ0EsWUFBWSxDQUFDLElBQWIsQ0FBa0IsVUFBbEI7O0FBQ0EsWUFBWSxDQUFDLElBQWIsQ0FBa0IsZ0RBQWxCOztBQUNBLFlBQVksQ0FBQyxJQUFiLENBQWtCLFVBQWxCOztBQUNBLFlBQVksQ0FBQyxJQUFiLENBQWtCLDBCQUFsQjs7QUFFQSxRQUFBLEdBQVcsUUFBQSxDQUFDLElBQUQsRUFBTyxPQUFQLENBQUEsRUFBQTs7O1NBRVYsSUFBQSxDQUFRLE9BQU8sQ0FBQyxRQUFSLENBQWlCLElBQWpCLENBQUgsR0FBOEIsT0FBOUIsR0FBMkMsS0FBaEQ7QUFGVTs7QUFJWCxjQUFBLEdBQWlCLFFBQUEsQ0FBQSxDQUFBO0FBQ2hCLE1BQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxPQUFBLEVBQUEsQ0FBQSxFQUFBLEtBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxHQUFBLEVBQUEsSUFBQSxF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Q0FBYjtJQUFvQixPQUFBLEdBQVUsRUFBOUI7O0VBQ0EsSUFBRyxPQUFBLElBQVcsU0FBUyxDQUFDLE1BQXhCO0lBQW9DLE9BQUEsR0FBVSxTQUFTLENBQUMsTUFBVixHQUFpQixFQUEvRDs7U0FDQSxLQUFBLENBQUE7QUFMWSIsInNvdXJjZXNDb250ZW50IjpbImNvbnN0cmFpbnRzID0gbnVsbFxyXG5zbmFwc2hvdHMgPSBudWxsXHJcbmN1cnJlbnQgPSAxXHJcblxyXG5leHBsYW5hdGlvbnMgPSBbXVxyXG5leHBsYW5hdGlvbnMucHVzaCAnQWxsIHByaW1hcnkgY29sdW1ucyBhbmQgcm93cyBoYXZlIDggb3B0aW9ucy4gSXRlbSBDQSBpcyBjaG9zZW4uIE9wdGlvbiBhMSBpcyBmaXJzdCdcclxuZXhwbGFuYXRpb25zLnB1c2ggJ0l0ZW1zIENBIGFuZCBSMSBpcyBoaWRkZW4uIEFsbCByZW1haW5pbmcgY29sdW1ucyBhbmQgcm93cyBoYXZlIDYgbGVnYWwgb3B0aW9ucy4gSXRlbSBDQiBpcyBjaG9zZW4uIE9wdGlvbiBiMyBpcyBzZWxlY3RlZCdcclxuZXhwbGFuYXRpb25zLnB1c2ggJ0l0ZW1zIENCIGFuZCBSMyBpcyBoaWRkZW4uIFNob3J0ZXN0IGl0ZW0gaXMgQ0MuIE9wdGlvbiBjNSBpcyBzZWxlY3RlZCdcclxuZXhwbGFuYXRpb25zLnB1c2ggJ0l0ZW1zIENDIGFuZCBSNSBpcyBoaWRkZW4uIFNob3J0ZXN0IGl0ZW0gaXMgQ0YuIE9wdGlvbiBmNCBpcyBzZWxlY3RlZCdcclxuZXhwbGFuYXRpb25zLnB1c2ggJ0l0ZW1zIENGIGFuZCBSNCBpcyBoaWRkZW4uIFNob3J0ZXN0IGl0ZW0gaXMgQ0guIE9wdGlvbiBoNyBpcyBzZWxlY3RlZCdcclxuZXhwbGFuYXRpb25zLnB1c2ggJ0l0ZW1zIENIIGFuZCBSNyBpcyBoaWRkZW4uIFNob3J0ZXN0IGl0ZW0gaXMgQ0guIFI2IGlzIGVtcHR5LCBoNyBpcyBiYWNrdHJhY2tlZCdcclxuZXhwbGFuYXRpb25zLnB1c2ggJ0NvbnRpbnVlJ1xyXG5leHBsYW5hdGlvbnMucHVzaCBcIk9wdGlvbiBmNCBjYW4ndCBiZSByZXBsYWNlZC4gZjQgaXMgYmFja3RyYWNrZWRcIlxyXG5leHBsYW5hdGlvbnMucHVzaCAnQ29udGludWUnXHJcbmV4cGxhbmF0aW9ucy5wdXNoIFwiT3B0aW9uIGM1IHJlcGxhY2VkIGJ5IGM2XCJcclxuXHJcbnNldENvbG9yID0gKGl0ZW0sIG9wdGlvbnMpIC0+IFxyXG5cdCNjb25zb2xlLmxvZyBpdGVtLCd4JyxvcHRpb25zXHJcblx0ZmlsbCBpZiBvcHRpb25zLmluY2x1ZGVzIGl0ZW0gdGhlbiAnYmxhY2snIGVsc2UgJ3JlZCdcclxuXHJcbmRyYXdDaGVzc0JvYXJkID0gKCkgLT5cclxuXHRSID0gNTBcclxuXHR4ID0gd2lkdGgvMi00KlJcclxuXHR5ID0gaGVpZ2h0LzItUlxyXG5cdGZvciBpIGluIHJhbmdlIDhcclxuXHRcdGZvciBqIGluIHJhbmdlIDhcclxuXHRcdFx0ZmlsbCBpZiAoaStqKSUyPT0wIHRoZW4gJ3doaXRlJyBlbHNlICdibGFjaydcclxuXHRcdFx0cmVjdCB4K1IqKGkpLHkrUiooaiksUixSXHJcblx0ZmlsbCAnZ3JlZW4nXHJcblx0dGV4dFNpemUgMjRcclxuXHRjaG9pY2VzID0gc25hcHNob3RzW2N1cnJlbnRdLmNob2ljZXMudHJpbSgpLnNwbGl0ICcgJ1xyXG5cdGZvciBjLGluZGV4IGluIGNob2ljZXNcclxuXHRcdGlmIGM9PScnIHRoZW4gY29udGludWVcclxuXHRcdCNjb25zb2xlLmxvZyBjXHJcblx0XHRpID0gMC41ICsgJ2FiY2RlZmdoJy5pbmRleE9mIGNbMF1cclxuXHRcdGogPSA4IC0gMC41IC0gJzEyMzQ1Njc4Jy5pbmRleE9mIGNbMV1cclxuXHRcdCNjb25zb2xlLmxvZyBpLGpcclxuXHRcdCNmaWxsICdncmVlbidcclxuXHRcdHN0cm9rZSAnYmxhY2snXHJcblx0XHRmaWxsIGlmIGluZGV4ID09IGNob2ljZXMubGVuZ3RoLTEgdGhlbiAneWVsbG93JyBlbHNlICdncmVlbidcclxuXHRcdGNpcmNsZSB4K1IqaSx5K1IqaiwwLjQqUlxyXG5cdFx0bm9TdHJva2UoKVxyXG5cdFx0ZmlsbCBpZiBpbmRleCA9PSBjaG9pY2VzLmxlbmd0aC0xIHRoZW4gJ2dyZWVuJyBlbHNlICd5ZWxsb3cnXHJcblx0XHR0ZXh0IGMseCtSKmkseStSKmpcclxuXHJcbnByZWxvYWQgPSAtPlxyXG5cdGZldGNoIFwiOHF1ZWVucy5qc29uXCJcclxuXHRcdC50aGVuIChyZXNwb25zZSkgPT4gcmVzcG9uc2UuanNvbigpIFxyXG5cdFx0LnRoZW4gKGpzb24pID0+IFxyXG5cdFx0XHR7Y29uc3RyYWludHMsc25hcHNob3RzfSA9IGpzb25cclxuXHRcdFx0Y29uc29sZS5sb2cganNvblxyXG5cdFx0XHR4ZHJhdygpXHJcblxyXG5zZXR1cCA9IC0+XHJcblx0Y3JlYXRlQ2FudmFzIDEyMDAsNzUwXHJcblxyXG5kcmF3T3B0aW9ucyA9IChwcm9tcHQsb2Zmc2V0LHcsYSxiKSAtPlxyXG5cclxuXHR0ZXh0QWxpZ24gTEVGVCxDRU5URVJcclxuXHRmaWxsICd5ZWxsb3cnXHJcblx0bm9TdHJva2UoKVxyXG5cdHRleHQgcHJvbXB0LG9mZnNldCsyNSowLjcsNTBcclxuXHJcblx0c3Ryb2tlICd5ZWxsb3cnXHJcblx0bGluZSBvZmZzZXQrMjUqMC43LDYwLG9mZnNldCt3KzEwLDYwXHJcblx0bGluZSBvZmZzZXQrMjUqMC43LDYwLG9mZnNldCt3KzEwLDYwXHJcblx0bm9TdHJva2UoKVxyXG5cclxuXHRpPTBcclxuXHR0ZXh0QWxpZ24gQ0VOVEVSLENFTlRFUlxyXG5cdGZvciBrZXksb3B0aW9uIG9mIGFcclxuXHRcdG9wdGlvbiA9IG9wdGlvbi5zcGxpdCAnICdcclxuXHRcdGZpbGwgJ3llbGxvdydcclxuXHRcdHRleHQga2V5LG9mZnNldCsyNSsyNSppLDUwKzI1XHJcblx0XHQjZmlsbCAnYmxhY2snXHJcblx0XHQjdGV4dCBvcHRpb24ubGVuZ3RoLG9mZnNldCsyNSsyNSppLDUwKzI1KzI1XHJcblx0XHJcblx0XHRpZiBrZXkgb2YgYlxyXG5cdFx0XHRmb3IgaXRlbSxqIGluIG9wdGlvblxyXG5cdFx0XHRcdGlmIGIgXHJcblx0XHRcdFx0XHRzZXRDb2xvciBpdGVtLGJba2V5XVxyXG5cdFx0XHRcdGVsc2VcclxuXHRcdFx0XHRcdGZpbGwgJ2JsYWNrJ1xyXG5cdFx0XHRcdHRleHQgaXRlbSxvZmZzZXQrMjUrMjUqaSwxMDArMjUqalxyXG5cdFx0ZWxzZVxyXG5cdFx0XHRmaWxsICdyZWQnXHJcblx0XHRcdGZvciBpdGVtLGogaW4gb3B0aW9uXHJcblx0XHRcdFx0dGV4dCBpdGVtLG9mZnNldCsyNSsyNSppLDEwMCsyNSpqXHJcblx0XHRpKytcclxuXHJcblxyXG5zaG93Q2hvaWNlcyA9IChzbmFwc2hvdCkgLT5cclxuXHRmaWxsICd3aGl0ZSdcclxuXHRzdHJva2UgJ2JsYWNrJ1xyXG5cdGZvciBpIGluIHJhbmdlIDhcclxuXHRcdHJlY3QgMjArNDAqaSwxMCw0MCwzMFxyXG5cdG5vU3Ryb2tlKClcclxuXHRmaWxsICdibGFjaydcclxuXHR0ZXh0QWxpZ24gQ0VOVEVSLENFTlRFUlxyXG5cdGZvciBjLGkgaW4gc25hcHNob3RzW2N1cnJlbnRdLmNob2ljZXMudHJpbSgpLnNwbGl0ICcgJ1xyXG5cdFx0dGV4dCBjLDQwKzQwKmksMjhcclxuXHJcbnhkcmF3ID0gLT5cclxuXHRiZyAwLjVcclxuXHRpZiBub3QgY29uc3RyYWludHMgdGhlbiByZXR1cm5cclxuXHRpdGVtcyA9IGNvbnN0cmFpbnRzLnByaW1hcmllcy5jb25jYXQgY29uc3RyYWludHMuc2Vjb25kYXJpZXNcclxuXHJcblx0dGV4dFNpemUgMTRcclxuXHR0ZXh0QWxpZ24gQ0VOVEVSLENFTlRFUlxyXG5cdGZpbGwgJ3llbGxvdydcclxuXHJcblx0YSA9IHNuYXBzaG90c1tjdXJyZW50LTFdXHJcblx0YiA9IHNuYXBzaG90c1tjdXJyZW50XVxyXG5cdGFwID0gaWYgYSB0aGVuIGEucHJpbWFyaWVzIGVsc2Uge31cclxuXHRheCA9IGlmIGEgdGhlbiBhLnNlY29uZGFyaWVzIGVsc2Uge31cclxuXHRicCA9IGlmIGIgdGhlbiBiLnByaW1hcmllcyBlbHNlIHt9XHJcblx0YnggPSBpZiBiIHRoZW4gYi5zZWNvbmRhcmllcyBlbHNlIHt9XHJcblxyXG5cdGRyYXdPcHRpb25zICdwcmltYXJ5IGl0ZW1zJywgIDAqMjUsICAxNioyNSwgYXAsYnBcclxuXHRkcmF3T3B0aW9ucyAnc2Vjb25kYXJ5IGl0ZW1zJywxNioyNSwgMzAqMjUsIGF4LGJ4XHJcblxyXG5cdGRyYXdDaGVzc0JvYXJkKClcclxuXHJcblx0c25hcHNob3QgPSBiXHJcblx0ZmlsbCAnYmxhY2snXHJcblx0dGV4dFNpemUgMzJcclxuXHRpZiBzbmFwc2hvdFxyXG5cdFx0c2hvd0Nob2ljZXMoKVxyXG5cdFx0dGV4dEFsaWduIENFTlRFUixDRU5URVJcclxuXHRcdHRleHQgc25hcHNob3QuYWN0aW9uLHdpZHRoLzIsMjVcclxuXHR0ZXh0QWxpZ24gUklHSFQsQ0VOVEVSXHJcblx0dGV4dCBcIiN7Y3VycmVudC0xfSBvZiAje3NuYXBzaG90cy5sZW5ndGgtMn0gc25hcHNob3RzXCIsd2lkdGgtNDAsMjVcclxuXHJcblx0dGV4dEFsaWduIExFRlQsQ0VOVEVSXHJcblx0dGV4dFNpemUgMTRcclxuXHRmaWxsICd3aGl0ZSdcclxuXHR0ZXh0IGV4cGxhbmF0aW9uc1tjdXJyZW50XSwxNSwxMDArOCoyNVxyXG5cclxua2V5UHJlc3NlZCA9IC0+XHJcblx0aWYga2V5PT0nQXJyb3dMZWZ0JyB0aGVuIGN1cnJlbnQtLVxyXG5cdGlmIGtleT09J0Fycm93UmlnaHQnIHRoZW4gY3VycmVudCsrXHJcblx0aWYgY3VycmVudCA8IDEgdGhlbiBjdXJyZW50ID0gMVxyXG5cdGlmIGN1cnJlbnQgPj0gc25hcHNob3RzLmxlbmd0aCB0aGVuIGN1cnJlbnQgPSBzbmFwc2hvdHMubGVuZ3RoLTFcclxuXHR4ZHJhdygpXHJcbiJdfQ==
//# sourceURL=c:\github\2020\040-QueensViewer\coffee\sketch.coffee