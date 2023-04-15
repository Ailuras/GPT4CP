
include "globals.mzn";

int: n;

set of int: NUMBERS = 1..n*n;

array[1..n, 1..n] of var NUMBERS: square;

constraint alldifferent(square);

int: MAGIC_SUM = n * (n*n + 1) / 2;

constraint forall(i in 1..n)(sum(square[i,..]) == MAGIC_SUM /\ sum(square[..,i]) == MAGIC_SUM);

constraint sum([square[i,i] | i in 1..n]) == MAGIC_SUM /\ sum([square[i,n-i+1] | i in 1..n]) == MAGIC_SUM;

solve satisfy;

output [
  "Magic Square:\n",
  if n <= 3 then
    "No solution for n <= 3\n"
  else
    concat([show(square[i,j]) ++ if j == n then "\n" else " " endif | i,j in 1..n])
  endif
];
