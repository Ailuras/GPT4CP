% Input parameter
int: n;
set of int: BALLS = 1..n;

% Decision variable
array[BALLS] of var 1..3: box; % Box number for each ball

% Constraints
constraint forall(x, y, z in BALLS where x + y = z)(
  % Not all balls in the same box for any triple (x, y, z) with x + y = z
  box[x] != box[y] \/ box[x] != box[z] \/ box[y] != box[z]
);

% Solve the problem
solve satisfy;
