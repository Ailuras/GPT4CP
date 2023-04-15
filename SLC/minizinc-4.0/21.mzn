% Input parameters
int: n = 9;
set of int: ROWS = 1..n;
set of int: COLS = 1..n;

% Decision variables
array[ROWS, COLS] of var 0..9: grid;

% Constraints
% 1 across = 27 across plus twenty-seven
constraint grid[1,3]*100 + grid[1,4]*10 + grid[1,7] = grid[9,7]*10 + grid[9,8] + 27;

% 4 across = 4 down plus seventy-one
constraint grid[1,6]*100 + grid[1,7]*10 + grid[1,9] = grid[3,6]*1000 + grid[4,6]*100 + grid[5,6]*10 + grid[6,6] + 71;

% 28 across = Four dozen
constraint grid[9,7]*10 + grid[9,8] = 48;

% 29 across = Seven gross
constraint grid[9,2]*1000 + grid[9,3]*100 + grid[9,4]*10 + grid[9,5] = 1008;

% X grid constraints
constraint grid[1,5] = -1;
constraint grid[2,3] = -1;
constraint grid[2,6] = -1;
constraint grid[2,9] = -1;
constraint grid[3,2] = -1;
constraint grid[3,5] = -1;
constraint grid[3,7] = -1;
constraint grid[3,9] = -1;
constraint grid[4,1] = -1;
constraint grid[4,3] = -1;
constraint grid[4,4] = -1;
constraint grid[4,5] = -1;
constraint grid[4,7] = -1;
constraint grid[4,9] = -1;
constraint grid[5,2] = -1;
constraint grid[5,4] = -1;
constraint grid[5,6] = -1;
constraint grid[5,8] = -1;
constraint grid[6,3] = -1;
constraint grid[6,7] = -1;
constraint grid[7,2] = -1;
constraint grid[7,5] = -1;
constraint grid[7,7] = -1;
constraint grid[7,9] = -1;
constraint grid[8,1] = -1;
constraint grid[8,4] = -1;
constraint grid[8,6] = -1;
constraint grid[8,9] = -1;
constraint grid[9,1] = -1;
constraint grid[9,6] = -1;

% Solve the problem
solve satisfy;
