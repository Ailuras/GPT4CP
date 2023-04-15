% Input parameters
set of int: NUMS = 1..19;

% Decision variables
array[1..5] of var NUMS: row1;
array[1..4] of var NUMS: row2;
array[1..5] of var NUMS: row3;
array[1..4] of var NUMS: row4;
array[1..3] of var NUMS: row5;

% Constraints
include "alldifferent.mzn";

% All diagonals must have a sum of 38
constraint row1[1] + row2[1] + row3[1] = 38;
constraint row1[2] + row2[2] + row3[2] + row4[1] = 38;
constraint row1[3] + row2[3] + row3[3] + row4[2] + row5[1] = 38;
constraint row2[4] + row3[4] + row4[3] + row5[2] = 38;
constraint row3[5] + row4[4] + row5[3] = 38;

constraint row1[1] + row1[2] + row2[1] = 38;
constraint row1[2] + row1[3] + row2[2] + row3[1] = 38;
constraint row1[3] + row2[3] + row3[2] + row4[1] = 38;
constraint row2[3] + row2[4] + row3[3] + row4[2] = 38;
constraint row3[3] + row3[4] + row4[3] = 38;

constraint row5[1] + row4[1] + row3[1] = 38;
constraint row5[2] + row4[2] + row3[2] + row2[1] = 38;
constraint row5[3] + row4[3] + row3[3] + row2[2] = 38;
constraint row4[3] + row4[4] + row3[4] + row2[3] = 38;
constraint row3[4] + row3[5] + row2[4] = 38;

% All numbers must be used and different
constraint alldifferent(row1 ++ row2 ++ row3 ++ row4 ++ row5);

% Solve the problem
solve satisfy;
