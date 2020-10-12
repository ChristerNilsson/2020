# front

This file is used to keep dlx and sudoku-dlx together

# DLX

Original code: https://github.com/TimBeyer/node-dlx

dlx.coffee contains Dancing Links (translated from typescript)

To uniqely identifie each option the first column contains unique identifiers

This identifier is shown in the solution. 

Example:
* n-queens a1 (square)
* sudoku 231  (row column digit)

# Queens-dlx

node js/queens-dlx.js 8 | node js/dlx.js

queens.coffee creates an input file to dlx.

Performance
* 8  3ms
* 16 4ms
* 20 5ms
* 30 16ms
* 40 58ms
* 50 68ms
* 60 206ms
* 70 101s

# Sudoku-dlx

node js/sudoku-dlx 000000007004020600800000310000002900040090030009506000010000008006050200700000060 | node js/dlx

./all.bat runs the first ten puzzles from hardest_1106. Takes 364ms. 36 us per problem

tdoku handles 375 problems in 35ms. Takes 0.093ms = 93 us per problem.

Rewriting dlx.coffee in C++ should give roughly same speed as tdoku.
Without complex tech as simd and dpll.

all.bat crashes intermittently. No reason.

# Book 4B by Knuth

Downloaded fasc5c.ps from here: https://www-cs-faculty.stanford.edu/~knuth/musings.html (31MB)

Used p2pdf.com to convert to fasc5c.pdf. (4MB)

Chrome can display pdf and also print

Contents:

```
1-60 Dancing Links
60-119 Exercises
120-255 Answers
256-270 Index
```
