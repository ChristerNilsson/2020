// Generated by CoffeeScript 2.4.1
// Implementation of Knuth's Dancing Links technique for Algorithm X (exact cover).
var dlx_cover, dlx_search, dlx_solve, dlx_uncover, filename, fs, g, i, iter, j, l, len, len1, len2, m, puzzle, puzzles, r, range, ref, s, solve_sudoku;

fs = require('fs');

range = function(n) {
  return (function() {
    var results = [];
    for (var l = 0; 0 <= n ? l < n : l > n; 0 <= n ? l++ : l--){ results.push(l); }
    return results;
  }).apply(this);
};

iter = function(dir, c, body) { // replacing while with iter seems to slow down by 100%
  var i, results;
  i = c[dir];
  results = [];
  while (i !== c) {
    body(i);
    results.push(i = i[dir]);
  }
  return results;
};

dlx_cover = function(c) {
  c.right.left = c.left;
  c.left.right = c.right;
  return iter('down', c, function(i) {
    return iter('right', i, function(j) {
      j.down.up = j.up;
      j.up.down = j.down;
      return j.column.size--;
    });
  });
};

dlx_uncover = function(c) {
  iter('up', c, function(i) {
    return iter('left', i, function(j) {
      j.column.size++;
      j.down.up = j;
      return j.up.down = j;
    });
  });
  c.right.left = c;
  return c.left.right = c;
};

dlx_search = function(head, solution, k, solutions, maxsolutions) {
  var c, j, r, s;
  if (head.right === head) {
    solutions.push(solution.slice(0));
    if (solutions.length >= maxsolutions) {
      return solutions;
    }
    return null;
  }
  c = null;
  s = 99999;
  j = head.right;
  while (j !== head) {
    if (j.size === 0) {
      return null;
    }
    if (j.size < s) {
      s = j.size;
      c = j;
    }
    j = j.right;
  }
  dlx_cover(c);
  r = c.down;
  while (r !== c) {
    solution[k] = r.row;
    iter('right', r, function(j) {
      return dlx_cover(j.column);
    });
    s = dlx_search(head, solution, k + 1, solutions, maxsolutions);
    if (s !== null) {
      return s;
    }
    iter('left', r, function(j) {
      return dlx_uncover(j.column);
    });
    r = r.down;
  }
  dlx_uncover(c);
  return null;
};

dlx_solve = function(matrix, skip, maxsolutions) {
  var columns, head, i, j, l, last, len1, len2, len3, len4, m, node, o, p, ref, ref1, ref2, ref3, solutions;
  columns = new Array(matrix[0].length);
  ref = range(columns.length);
  for (l = 0, len1 = ref.length; l < len1; l++) {
    i = ref[l];
    columns[i] = {};
  }
  ref1 = range(columns.length);
  for (m = 0, len2 = ref1.length; m < len2; m++) {
    i = ref1[m];
    columns[i].index = i;
    columns[i].up = columns[i];
    columns[i].down = columns[i];
    if (i >= skip) {
      if (i - 1 >= skip) {
        columns[i].left = columns[i - 1];
      }
      if (i + 1 < columns.length) {
        columns[i].right = columns[i + 1];
      }
    } else {
      columns[i].left = columns[i];
      columns[i].right = columns[i];
    }
    columns[i].size = 0;
  }
  ref2 = range(matrix.length);
  for (o = 0, len3 = ref2.length; o < len3; o++) {
    i = ref2[o];
    last = null;
    ref3 = range(matrix[i].length);
    for (p = 0, len4 = ref3.length; p < len4; p++) {
      j = ref3[p];
      if (matrix[i][j]) {
        node = {};
        node.row = i;
        node.column = columns[j];
        node.up = columns[j].up;
        node.down = columns[j];
        if (last) {
          node.left = last;
          node.right = last.right;
          last.right.left = node;
          last.right = node;
        } else {
          node.left = node;
          node.right = node;
        }
        columns[j].up.down = node;
        columns[j].up = node;
        columns[j].size++;
        last = node;
      }
    }
  }
  head = {};
  head.right = columns[skip];
  head.left = columns[columns.length - 1];
  columns[skip].left = head;
  columns[columns.length - 1].right = head;
  solutions = [];
  dlx_search(head, [], 0, solutions, maxsolutions);
  return solutions;
};

solve_sudoku = function(grid) {
  var g, i, j, l, len1, len2, len3, len4, m, mat, n, o, p, r, ref, ref1, ref2, ref3, rinfo, row, solutions;
  mat = [];
  rinfo = [];
  ref = range(9);
  for (l = 0, len1 = ref.length; l < len1; l++) {
    i = ref[l];
    ref1 = range(9);
    for (m = 0, len2 = ref1.length; m < len2; m++) {
      j = ref1[m];
      g = grid[i][j] - 1;
      if (g >= 0) {
        row = new Array(324);
        row[i * 9 + j] = 1;
        row[9 * 9 + i * 9 + g] = 1;
        row[9 * 9 * 2 + j * 9 + g] = 1;
        row[9 * 9 * 3 + (Math.floor(i / 3) * 3 + Math.floor(j / 3)) * 9 + g] = 1;
        mat.push(row);
        rinfo.push({
          'row': i,
          'col': j,
          'n': g + 1
        });
      } else {
        ref2 = range(9);
        for (o = 0, len3 = ref2.length; o < len3; o++) {
          n = ref2[o];
          row = new Array(324);
          row[i * 9 + j] = 1;
          row[9 * 9 + i * 9 + n] = 1;
          row[9 * 9 * 2 + j * 9 + n] = 1;
          row[9 * 9 * 3 + (Math.floor(i / 3) * 3 + Math.floor(j / 3)) * 9 + n] = 1;
          mat.push(row);
          rinfo.push({
            'row': i,
            'col': j,
            'n': n + 1
          });
        }
      }
    }
  }
  solutions = dlx_solve(mat, 0, 2);
  if (solutions.length > 0) {
    r = solutions[0];
    ref3 = range(r.length);
    for (p = 0, len4 = ref3.length; p < len4; p++) {
      i = ref3[p];
      grid[rinfo[r[i]]['row']][rinfo[r[i]]['col']] = rinfo[r[i]]['n'];
    }
    return solutions.length;
  }
  return 0;
};

filename = process.argv[2];

puzzles = fs.readFileSync(filename).toString().split('\n');

len = puzzles.shift();

console.time('puzzle');

for (l = 0, len1 = puzzles.length; l < len1; l++) {
  puzzle = puzzles[l];
  if (puzzle.length >= 81) {
    g = (function() {
      var len2, m, ref, results;
      ref = range(9);
      results = [];
      for (m = 0, len2 = ref.length; m < len2; m++) {
        i = ref[m];
        results.push((function() {
          var len3, o, ref1, results1;
          ref1 = range(9);
          results1 = [];
          for (o = 0, len3 = ref1.length; o < len3; o++) {
            j = ref1[o];
            results1.push(parseInt(puzzle[i * 9 + j]));
          }
          return results1;
        })());
      }
      return results;
    })();
    r = solve_sudoku(g); // this is the number of solutions
    if (r > 0) {
      s = '';
      ref = range(81);
      for (m = 0, len2 = ref.length; m < len2; m++) {
        i = ref[m];
        s += g[Math.floor(i / 9)][i % 9];
      }
    }
  }
}

//console.log puzzle 
//console.log s
console.timeEnd('puzzle');

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic3Vkb2t1LmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHN1ZG9rdS5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsSUFBQSxTQUFBLEVBQUEsVUFBQSxFQUFBLFNBQUEsRUFBQSxXQUFBLEVBQUEsUUFBQSxFQUFBLEVBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLElBQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLEdBQUEsRUFBQSxJQUFBLEVBQUEsSUFBQSxFQUFBLENBQUEsRUFBQSxNQUFBLEVBQUEsT0FBQSxFQUFBLENBQUEsRUFBQSxLQUFBLEVBQUEsR0FBQSxFQUFBLENBQUEsRUFBQTs7QUFFQSxFQUFBLEdBQUssT0FBQSxDQUFRLElBQVI7O0FBQ0wsS0FBQSxHQUFRLFFBQUEsQ0FBQyxDQUFELENBQUE7U0FBTzs7Ozs7QUFBUDs7QUFFUixJQUFBLEdBQU8sUUFBQSxDQUFDLEdBQUQsRUFBTSxDQUFOLEVBQVMsSUFBVCxDQUFBLEVBQUE7QUFDTixNQUFBLENBQUEsRUFBQTtFQUFBLENBQUEsR0FBSSxDQUFFLENBQUEsR0FBQTtBQUNOO1NBQU0sQ0FBQSxLQUFLLENBQVg7SUFDQyxJQUFBLENBQUssQ0FBTDtpQkFDQSxDQUFBLEdBQUksQ0FBRSxDQUFBLEdBQUE7RUFGUCxDQUFBOztBQUZNOztBQU1QLFNBQUEsR0FBWSxRQUFBLENBQUMsQ0FBRCxDQUFBO0VBQ1gsQ0FBQyxDQUFDLEtBQUssQ0FBQyxJQUFSLEdBQWUsQ0FBQyxDQUFDO0VBQ2pCLENBQUMsQ0FBQyxJQUFJLENBQUMsS0FBUCxHQUFlLENBQUMsQ0FBQztTQUNqQixJQUFBLENBQUssTUFBTCxFQUFhLENBQWIsRUFBZ0IsUUFBQSxDQUFDLENBQUQsQ0FBQTtXQUNmLElBQUEsQ0FBSyxPQUFMLEVBQWMsQ0FBZCxFQUFpQixRQUFBLENBQUMsQ0FBRCxDQUFBO01BQ2hCLENBQUMsQ0FBQyxJQUFJLENBQUMsRUFBUCxHQUFZLENBQUMs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OztBQWdDZixRQUFBLEdBQVcsT0FBTyxDQUFDLElBQUssQ0FBQSxDQUFBOztBQUN4QixPQUFBLEdBQVUsRUFBRSxDQUFDLFlBQUgsQ0FBZ0IsUUFBaEIsQ0FBeUIsQ0FBQyxRQUExQixDQUFBLENBQW9DLENBQUMsS0FBckMsQ0FBMkMsSUFBM0M7O0FBQ1YsR0FBQSxHQUFNLE9BQU8sQ0FBQyxLQUFSLENBQUE7O0FBQ04sT0FBTyxDQUFDLElBQVIsQ0FBYSxRQUFiOztBQUNBLEtBQUEsMkNBQUE7O0VBQ0MsSUFBRyxNQUFNLENBQUMsTUFBUCxJQUFpQixFQUFwQjtJQUNDLENBQUE7O0FBQW1EO0FBQUE7TUFBQSxLQUFBLHVDQUFBOzs7O0FBQWxCO0FBQUE7VUFBQSxLQUFBLHdDQUFBOzswQkFBM0IsUUFBQSxDQUFTLE1BQU8sQ0FBQSxDQUFBLEdBQUksQ0FBSixHQUFRLENBQVIsQ0FBaEI7VUFBMkIsQ0FBQTs7O01BQWtCLENBQUE7OztJQUNuRCxDQUFBLEdBQUksWUFBQSxDQUFhLENBQWIsRUFESjtJQUVBLElBQUcsQ0FBQSxHQUFJLENBQVA7TUFDQyxDQUFBLEdBQUk7QUFDSjtNQUFBLEtBQUEsdUNBQUE7O1FBQ0MsQ0FBQSxJQUFLLENBQUUsQ0FBQSxJQUFJLENBQUMsS0FBTCxDQUFXLENBQUEsR0FBRSxDQUFiLENBQUEsQ0FBaUIsQ0FBQSxDQUFBLEdBQUUsQ0FBRjtNQUR6QixDQUZEO0tBSEQ7O0FBREQsQ0FqSkE7Ozs7QUEySkEsT0FBTyxDQUFDLE9BQVIsQ0FBZ0IsUUFBaEIiLCJzb3VyY2VzQ29udGVudCI6WyIjIEltcGxlbWVudGF0aW9uIG9mIEtudXRoJ3MgRGFuY2luZyBMaW5rcyB0ZWNobmlxdWUgZm9yIEFsZ29yaXRobSBYIChleGFjdCBjb3ZlcikuXHJcblxyXG5mcyA9IHJlcXVpcmUgJ2ZzJ1xyXG5yYW5nZSA9IChuKSAtPiBbMC4uLm5dXHJcblxyXG5pdGVyID0gKGRpciwgYywgYm9keSkgLT4gIyByZXBsYWNpbmcgd2hpbGUgd2l0aCBpdGVyIHNlZW1zIHRvIHNsb3cgZG93biBieSAxMDAlXHJcblx0aSA9IGNbZGlyXVxyXG5cdHdoaWxlIGkgIT0gY1xyXG5cdFx0Ym9keSBpXHJcblx0XHRpID0gaVtkaXJdXHJcblxyXG5kbHhfY292ZXIgPSAoYykgLT5cclxuXHRjLnJpZ2h0LmxlZnQgPSBjLmxlZnRcclxuXHRjLmxlZnQucmlnaHQgPSBjLnJpZ2h0XHJcblx0aXRlciAnZG93bicsIGMsIChpKSAtPlxyXG5cdFx0aXRlciAncmlnaHQnLCBpLCAoaikgLT5cclxuXHRcdFx0ai5kb3duLnVwID0gai51cFxyXG5cdFx0XHRqLnVwLmRvd24gPSBqLmRvd25cclxuXHRcdFx0ai5jb2x1bW4uc2l6ZS0tXHJcblxyXG5kbHhfdW5jb3ZlciA9IChjKSAtPlxyXG5cdGl0ZXIgJ3VwJywgYywgKGkpIC0+XHJcblx0XHRpdGVyICdsZWZ0JywgaSwgKGopIC0+XHJcblx0XHRcdGouY29sdW1uLnNpemUrK1xyXG5cdFx0XHRqLmRvd24udXAgPSBqXHJcblx0XHRcdGoudXAuZG93biA9IGpcclxuXHRjLnJpZ2h0LmxlZnQgPSBjXHJcblx0Yy5sZWZ0LnJpZ2h0ID0gY1xyXG5cclxuZGx4X3NlYXJjaCA9IChoZWFkLCBzb2x1dGlvbiwgaywgc29sdXRpb25zLCBtYXhzb2x1dGlvbnMpIC0+XHJcblx0aWYgaGVhZC5yaWdodCA9PSBoZWFkXHJcblx0XHRzb2x1dGlvbnMucHVzaCBzb2x1dGlvbi5zbGljZSAwXHJcblx0XHRpZiBzb2x1dGlvbnMubGVuZ3RoID49IG1heHNvbHV0aW9ucyB0aGVuIHJldHVybiBzb2x1dGlvbnNcclxuXHRcdHJldHVybiBudWxsXHJcblx0YyA9IG51bGxcclxuXHRzID0gOTk5OTlcclxuXHJcblx0aiA9IGhlYWQucmlnaHRcclxuXHR3aGlsZSBqICE9IGhlYWRcclxuXHRcdGlmIGouc2l6ZSA9PSAwIHRoZW4gcmV0dXJuIG51bGxcclxuXHRcdGlmIGouc2l6ZSA8IHNcclxuXHRcdFx0cyA9IGouc2l6ZVxyXG5cdFx0XHRjID0galxyXG5cdFx0aiA9IGoucmlnaHRcclxuXHJcblx0ZGx4X2NvdmVyIGNcclxuXHRyID0gYy5kb3duXHJcblx0d2hpbGUgciAhPSBjXHJcblx0XHRzb2x1dGlvbltrXSA9IHIucm93XHJcblx0XHRpdGVyICdyaWdodCcsIHIsIChqKSAtPiBkbHhfY292ZXIgai5jb2x1bW5cclxuXHRcdHMgPSBkbHhfc2VhcmNoIGhlYWQsIHNvbHV0aW9uLCBrKzEsIHNvbHV0aW9ucywgbWF4c29sdXRpb25zXHJcblx0XHRpZiBzICE9IG51bGwgdGhlbiByZXR1cm4gc1xyXG5cdFx0aXRlciAnbGVmdCcsIHIsIChqKSAtPiBkbHhfdW5jb3ZlciBqLmNvbHVtblxyXG5cdFx0ciA9IHIuZG93blxyXG5cclxuXHRkbHhfdW5jb3ZlciBjXHJcblx0cmV0dXJuIG51bGxcclxuXHJcbmRseF9zb2x2ZSA9IChtYXRyaXgsIHNraXAsIG1heHNvbHV0aW9ucykgLT5cclxuXHRjb2x1bW5zID0gbmV3IEFycmF5IG1hdHJpeFswXS5sZW5ndGhcclxuXHRmb3IgaSBpbiByYW5nZSBjb2x1bW5zLmxlbmd0aFxyXG5cdFx0Y29sdW1uc1tpXSA9IHt9XHJcblx0Zm9yIGkgaW4gcmFuZ2UgY29sdW1ucy5sZW5ndGhcclxuXHRcdGNvbHVtbnNbaV0uaW5kZXggPSBpXHJcblx0XHRjb2x1bW5zW2ldLnVwID0gY29sdW1uc1tpXVxyXG5cdFx0Y29sdW1uc1tpXS5kb3duID0gY29sdW1uc1tpXVxyXG5cdFx0aWYgaSA+PSBza2lwXHJcblx0XHRcdGlmIGktMSA+PSBza2lwXHJcblx0XHRcdFx0Y29sdW1uc1tpXS5sZWZ0ID0gY29sdW1uc1tpLTFdXHJcblx0XHRcdFxyXG5cdFx0XHRpZiBpKzEgPCBjb2x1bW5zLmxlbmd0aFxyXG5cdFx0XHRcdGNvbHVtbnNbaV0ucmlnaHQgPSBjb2x1bW5zW2krMV1cclxuXHRcdGVsc2VcclxuXHRcdFx0Y29sdW1uc1tpXS5sZWZ0ID0gY29sdW1uc1tpXVxyXG5cdFx0XHRjb2x1bW5zW2ldLnJpZ2h0ID0gY29sdW1uc1tpXVxyXG5cdFx0XHJcblx0XHRjb2x1bW5zW2ldLnNpemUgPSAwXHJcblx0XHJcblx0Zm9yIGkgaW4gcmFuZ2UgbWF0cml4Lmxlbmd0aFxyXG5cdFx0bGFzdCA9IG51bGxcclxuXHRcdGZvciBqIGluIHJhbmdlIG1hdHJpeFtpXS5sZW5ndGhcclxuXHRcdFx0aWYgbWF0cml4W2ldW2pdXHJcblx0XHRcdFx0bm9kZSA9IHt9XHJcblx0XHRcdFx0bm9kZS5yb3cgPSBpXHJcblx0XHRcdFx0bm9kZS5jb2x1bW4gPSBjb2x1bW5zW2pdXHJcblx0XHRcdFx0bm9kZS51cCA9IGNvbHVtbnNbal0udXBcclxuXHRcdFx0XHRub2RlLmRvd24gPSBjb2x1bW5zW2pdXHJcblx0XHRcdFx0aWYgbGFzdFxyXG5cdFx0XHRcdFx0bm9kZS5sZWZ0ID0gbGFzdFxyXG5cdFx0XHRcdFx0bm9kZS5yaWdodCA9IGxhc3QucmlnaHRcclxuXHRcdFx0XHRcdGxhc3QucmlnaHQubGVmdCA9IG5vZGVcclxuXHRcdFx0XHRcdGxhc3QucmlnaHQgPSBub2RlXHJcblx0XHRcdFx0ZWxzZVxyXG5cdFx0XHRcdFx0bm9kZS5sZWZ0ID0gbm9kZVxyXG5cdFx0XHRcdFx0bm9kZS5yaWdodCA9IG5vZGVcclxuXHRcdFx0XHRjb2x1bW5zW2pdLnVwLmRvd24gPSBub2RlXHJcblx0XHRcdFx0Y29sdW1uc1tqXS51cCA9IG5vZGVcclxuXHRcdFx0XHRjb2x1bW5zW2pdLnNpemUrK1xyXG5cdFx0XHRcdGxhc3QgPSBub2RlXHJcblxyXG5cdGhlYWQgPSB7fVxyXG5cdGhlYWQucmlnaHQgPSBjb2x1bW5zW3NraXBdXHJcblx0aGVhZC5sZWZ0ID0gY29sdW1uc1tjb2x1bW5zLmxlbmd0aC0xXVxyXG5cdGNvbHVtbnNbc2tpcF0ubGVmdCA9IGhlYWRcclxuXHRjb2x1bW5zW2NvbHVtbnMubGVuZ3RoLTFdLnJpZ2h0ID0gaGVhZFxyXG5cdHNvbHV0aW9ucyA9IFtdXHJcblx0ZGx4X3NlYXJjaCBoZWFkLCBbXSwgMCwgc29sdXRpb25zLCBtYXhzb2x1dGlvbnNcclxuXHRyZXR1cm4gc29sdXRpb25zXHJcblxyXG5zb2x2ZV9zdWRva3UgPSAoZ3JpZCkgLT5cclxuXHRtYXQgPSBbXVxyXG5cdHJpbmZvID0gW11cclxuXHRmb3IgaSBpbiByYW5nZSA5XHJcblx0XHRmb3IgaiBpbiByYW5nZSA5XHJcblx0XHRcdGcgPSBncmlkW2ldW2pdIC0gMVxyXG5cdFx0XHRpZiBnID49IDBcclxuXHRcdFx0XHRyb3cgPSBuZXcgQXJyYXkgMzI0XHJcblx0XHRcdFx0cm93W2kqOStqXSA9IDFcclxuXHRcdFx0XHRyb3dbOSo5K2kqOStnXSA9IDFcclxuXHRcdFx0XHRyb3dbOSo5KjIraio5K2ddID0gMVxyXG5cdFx0XHRcdHJvd1s5KjkqMysoTWF0aC5mbG9vcihpLzMpKjMrTWF0aC5mbG9vcihqLzMpKSo5K2ddID0gMVxyXG5cdFx0XHRcdG1hdC5wdXNoIHJvd1xyXG5cdFx0XHRcdHJpbmZvLnB1c2ggeydyb3cnOiBpLCAnY29sJzogaiwgJ24nOiBnKzF9XHJcblx0XHRcdGVsc2VcclxuXHRcdFx0XHRmb3IgbiBpbiByYW5nZSA5XHJcblx0XHRcdFx0XHRyb3cgPSBuZXcgQXJyYXkgMzI0XHJcblx0XHRcdFx0XHRyb3dbaSo5K2pdID0gMVxyXG5cdFx0XHRcdFx0cm93WzkqOStpKjkrbl0gPSAxXHJcblx0XHRcdFx0XHRyb3dbOSo5KjIraio5K25dID0gMVxyXG5cdFx0XHRcdFx0cm93WzkqOSozKyhNYXRoLmZsb29yKGkvMykqMytNYXRoLmZsb29yKGovMykpKjkrbl0gPSAxXHJcblx0XHRcdFx0XHRtYXQucHVzaCByb3dcclxuXHRcdFx0XHRcdHJpbmZvLnB1c2ggeydyb3cnOiBpLCAnY29sJzogaiwgJ24nOiBuKzF9XHJcblxyXG5cdHNvbHV0aW9ucyA9IGRseF9zb2x2ZSBtYXQsIDAsIDJcclxuXHRpZiBzb2x1dGlvbnMubGVuZ3RoID4gMFxyXG5cdFx0ciA9IHNvbHV0aW9uc1swXVxyXG5cdFx0Zm9yIGkgaW4gcmFuZ2Ugci5sZW5ndGhcclxuXHRcdFx0Z3JpZFtyaW5mb1tyW2ldXVsncm93J11dW3JpbmZvW3JbaV1dWydjb2wnXV0gPSByaW5mb1tyW2ldXVsnbiddXHJcblx0XHRyZXR1cm4gc29sdXRpb25zLmxlbmd0aFxyXG5cdHJldHVybiAwXHJcblx0XHJcbmZpbGVuYW1lID0gcHJvY2Vzcy5hcmd2WzJdXHJcbnB1enpsZXMgPSBmcy5yZWFkRmlsZVN5bmMoZmlsZW5hbWUpLnRvU3RyaW5nKCkuc3BsaXQoJ1xcbicpXHJcbmxlbiA9IHB1enpsZXMuc2hpZnQoKVxyXG5jb25zb2xlLnRpbWUgJ3B1enpsZSdcclxuZm9yIHB1enpsZSBpbiBwdXp6bGVzXHJcblx0aWYgcHV6emxlLmxlbmd0aCA+PSA4MVxyXG5cdFx0ZyA9ICgocGFyc2VJbnQgcHV6emxlW2kgKiA5ICsgal0gZm9yIGogaW4gcmFuZ2UgOSkgZm9yIGkgaW4gcmFuZ2UgOSlcclxuXHRcdHIgPSBzb2x2ZV9zdWRva3UgZyAjIHRoaXMgaXMgdGhlIG51bWJlciBvZiBzb2x1dGlvbnNcclxuXHRcdGlmIHIgPiAwXHJcblx0XHRcdHMgPSAnJ1xyXG5cdFx0XHRmb3IgaSBpbiByYW5nZSA4MVxyXG5cdFx0XHRcdHMgKz0gZ1tNYXRoLmZsb29yKGkvOSldW2klOV1cclxuXHRcdFx0I2NvbnNvbGUubG9nIHB1enpsZSBcclxuXHRcdFx0I2NvbnNvbGUubG9nIHNcclxuY29uc29sZS50aW1lRW5kICdwdXp6bGUnIl19
//# sourceURL=c:\Lab\2020\031-SudokuPLB\coffee\sudoku.coffee