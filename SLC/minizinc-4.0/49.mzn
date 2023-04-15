include "globals.mzn";

int: N;
set of int: numbers = 1..N;
array[numbers] of var bool: set_A;

constraint sum([i * set_A[i] | i in numbers]) = sum([i * (1 - set_A[i]) | i in numbers]);
constraint sum([i * i * set_A[i] | i in numbers]) = sum([i * i * (1 - set_A[i]) | i in numbers]);
constraint sum([set_A[i] | i in numbers]) = N div 2;

solve satisfy;

output [if set_A[i] then show(i) ++ " " else "" endif | i in numbers] ++ ["\n"] ++
       [if not set_A[i] then show(i) ++ " " else "" endif | i in numbers];
