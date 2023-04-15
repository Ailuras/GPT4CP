% Input parameter
int: n;
set of int: PAIRS = 1..n;
set of int: SEQ = 1..(2*n);

% Decision variables
array[PAIRS] of var SEQ: pos1; % Position of first occurrence of each number i
array[PAIRS] of var SEQ: pos2; % Position of second occurrence of each number i

% Constraints
include "alldifferent.mzn";

% Distance constraint
constraint forall(i in PAIRS)(
  pos2[i] - pos1[i] = i + 1
);

% All positions must be different
constraint alldifferent(pos1 ++ pos2);

% Solve the problem
solve satisfy;
