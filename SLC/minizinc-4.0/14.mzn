include "globals.mzn";

% Input parameters
int: n = 10;
set of int: ROWS = 1..n;
set of int: COLS = 1..n;
array[ROWS] of int: row_counts;
array[COLS] of int: col_counts;
array[ROWS, COLS] of 0..1: prohibited;
array[ROWS, COLS] of 0..1: submarines;
array[ROWS, COLS] of 0..1: battleship_ends;

% Decision variables
array[ROWS, COLS] of var 0..1: battleship;
array[ROWS, COLS] of var 0..1: cruisers;
array[ROWS, COLS] of var 0..1: destroyers;

% Constraints
constraint forall(i in ROWS, j in COLS)(
  % Prohibited grid locations
  if prohibited[i, j] = 1 then
    battleship[i, j] = 0 /\ cruisers[i, j] = 0 /\ destroyers[i, j] = 0
  endif
);

constraint forall(i in ROWS, j in COLS)(
  % Submarines positions
  if submarines[i, j] = 1 then
    battleship[i, j] = 0 /\ cruisers[i, j] = 0 /\ destroyers[i, j] = 0
  endif
);

% Battleship placement
constraint
  sum(i in ROWS, j in COLS) (battleship[i, j]) = 3
  /\ exists(i in ROWS, j in COLS)(
    % Battleship head and tail
    battleship_ends[i, j] = 1 /\ battleship[i, j] = 1
  );

constraint forall(i in 1..n-3, j in COLS)(
  % Horizontal battleship
  (battleship[i, j] = 1 /\ battleship[i + 3, j] = 1)
  -> (battleship[i + 1, j] = 1 /\ battleship[i + 2, j] = 1)
);

constraint forall(i in ROWS, j in 1..n-3)(
  % Vertical battleship
  (battleship[i, j] = 1 /\ battleship[i, j + 3] = 1)
  -> (battleship[i, j + 1] = 1 /\ battleship[i, j + 2] = 1)
);

% Cruisers placement
constraint
  sum(i in ROWS, j in COLS) (cruisers[i, j]) = 4
  /\ forall(i in ROWS, j in COLS)(
    % Cruisers cannot be adjacent to battleship
    if battleship[i, j] = 1 then cruisers[i, j] = 0 endif
  );

constraint forall(i in 1..n-2, j in COLS)(
  % Horizontal cruisers
  cruisers[i, j] = cruisers[i + 2, j] -> cruisers[i + 1, j] = 1
);

constraint forall(i in ROWS, j in 1..n-2)(
  % Vertical cruisers
  cruisers[i, j] = cruisers[i, j + 2] -> cruisers[i, j + 1] = 1
);

% Destroyers placement
constraint
  sum(i in ROWS, j in COLS) (destroyers[i, j]) = 6
  /\ forall(i in ROWS, j in COLS)(
    % Destroyers cannot be adjacent to battleship or cruisers
    if battleship[i, j] = 1 \/ cruisers[i, j] = 1 then destroyers[i, j] = 0 endif
  );

constraint forall(i in 1..n-1, j in COLS)(
  % Horizontal destroyers
  destroyers[i, j] = destroyers[i + 1, j] -> destroyers[i, j] = 1
);

constraint forall(i in ROWS, j in 1..n-1)(
  % Vertical destroyers
  destroyers[i, j] = destroyers[i, j + 1] -> destroyers[i, j] = 1
);

% No two ships can occupy adjacent grids, even diagonally
constraint forall(i in 1..n-1, j in 1..n-1)(
  sum([battleship[i+k, j+l] + cruisers[i+k, j+l] + destroyers[i+k, j+l] : k in 0..1, l in 0..1]) <= 1
);

% Row and column counts
constraint forall(i in ROWS)(
  sum(j in COLS) (battleship[i, j] + cruisers[i, j] + destroyers[i, j] + submarines[i, j]) = row_counts[i]
);

constraint forall(j in COLS)(
  sum(i in ROWS) (battleship[i, j] + cruisers[i, j] + destroyers[i, j] + submarines[i, j]) = col_counts[j]
);

% Solve the problem
solve satisfy;
