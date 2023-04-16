int: n = 9;
set of int: ROWS = 1..n;
set of int: COLS = 1..n;
set of int: NUMS = 1..n;

% Cage information
int: n_cages;
set of int: CAGES = 1..n_cages;
array[CAGES] of int: cage_total;
array[CAGES, ROWS, COLS] of 0..1: cage_assignment;

% Decision variables
array[ROWS, COLS] of var NUMS: sudoku;

% Constraints

% Row and column constraints
constraint forall(r in ROWS, c in COLS)(
  alldifferent([sudoku[r, c2] | c2 in COLS]) /\ alldifferent([sudoku[r2, c] | r2 in ROWS])
);

% Box constraints
constraint forall(b_row, b_col in 1..3)(
  alldifferent([sudoku[3 * b_row + r - 3, 3 * b_col + c - 3] | r, c in 1..3])
);

% Cage constraints
constraint forall(cage in CAGES)(
  let {
    var set of ROWS: cage_rows = {r | r in ROWS where exists(c in COLS)(cage_assignment[cage, r, c] == 1)};
    var set of COLS: cage_cols = {c | c in COLS where exists(r in ROWS)(cage_assignment[cage, r, c] == 1)};
  } in (
    alldifferent([sudoku[r, c] | r in cage_rows, c in cage_cols])
    /\ sum([sudoku[r, c] | r in cage_rows, c in cage_cols]) == cage_total[cage]
  )
);

% Solve
solve satisfy;

% Output
output [if c == 1 then "\n" else "" endif ++ show(sudoku[r, c]) | r in ROWS, c in COLS];
