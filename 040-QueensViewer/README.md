# Queens Viewer

I'm trying to illustrate how Dancing Links by Donald Knuth works graphically, using N-Queens.

The clever choice of options ordering is too smart in QUEENS-DLX by Knuth. No backtracking occurs below n=16. I decided to start with a naive order. Now backtracking happens even for n=8.

* Use left and right arrow keys to navigate amongst the snapshots.
* Black labels shows possible moves. Ones
* The red labels are being removed. A one is replaced by a zero.

## Primary items

Must be used. All rows and all columns must be covered.

## Secondary items

Not mandatory. Not more than one queen per diagonal.

## Items (8 + 8 + 15 + 15 = 46)

* RA..RH rows
* CA..CH columns
* AA..AO left diagonals
* BA..BO right diagonals

The four corner diagonals, AA, AO, BA and BO have only one option, so they are actually not needed. No risk for two queens on these.

## Options (8 x 8 = 64)

* aa..ah first row, RA
* ha..hh last row, RH
* aa..ha first column, CA
* ah..hh last column, CH
* aa..aa first left diagonal, AA
* hh..hh last left diagonal, AO
* ha..ha first right diagonal, BA
* ah..ah last right diagonal, BO

## Target

When all queens are placed on the board and in legal positions, the first solutions has been found. This viewer only shows the first solution.

## Mousemove

Use the mouse to see how everything is connected.

## Explanations

### step 1
All columns in primary items have eight options.
The first option in CA is chosen, a1.

Now we have seven items with six options each.
b3 is chosen.

### step 2

CB will be removed. The shortest primary item is CC. c5 is chosen.

### step 3

CC and R5 will be removed. The shortest primary item is CF. f4 is chosen. Not d7.

### step 4

CF and R4 will be removed. Shortest primary item is CH. h7 will be chosen.

### step 5

R6 was taken in previous step. No queen can be placed on row 6. Backtracking!

### step 6

h7, f4 and c5 backtracked. c6 selected. d2 selected

