int: n;
set of int: ROWS = 1..n;
set of int: COLS = 1..n;

% Decision variables
array[ROWS, COLS] of var 0..1: board;

% Constraints

% One queen per row
constraint forall(r in ROWS)(sum(c in COLS)(board[r, c]) = 1);

% One queen per column
constraint forall(c in COLS)(sum(r in ROWS)(board[r, c]) = 1);

% No two queens on the same diagonal
constraint forall(r1, c1, r2, c2 in ROWS where r1 < r2)(board[r1, c1] + board[r2, c2] <= 1 \/ abs(r1 - r2) != abs(c1 - c2));

% Solve
solve satisfy;

% Output
output [if fix(board[r, c]) = 1 then "Q" else "." endif ++ if c == n then "\n" else "" endif | r in ROWS, c in COLS];
