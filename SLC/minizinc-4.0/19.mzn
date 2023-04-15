% Input parameter
int: n;
set of int: ROWS = 1..n;
set of int: COLS = 1..n;
int: magic_sum = n * (n * n + 1) div 2;

% Decision variables
array[ROWS, COLS] of var 1..n*n: magic_square;

% Constraints
include "alldifferent.mzn";

% All rows, columns, and diagonals have the same sum
constraint forall(i in ROWS)(
  % Row sums
  sum(j in COLS) (magic_square[i, j]) = magic_sum
);

constraint forall(j in COLS)(
  % Column sums
  sum(i in ROWS) (magic_square[i, j]) = magic_sum
);

% Diagonal sums
constraint sum(i in ROWS) (magic_square[i, i]) = magic_sum;
constraint sum(i in ROWS) (magic_square[i, n - i + 1]) = magic_sum;

% All numbers 1 to n^2 must be used
constraint alldifferent([magic_square[i, j] | i in ROWS, j in COLS]);

% Solve the problem
solve satisfy;
