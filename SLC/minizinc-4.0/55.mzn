int: v;
int: q;
int: lambda;
int: d;
set of int: SEQUENCES = 1..v;
set of int: POSITIONS = 1..(q * lambda);
set of int: SYMBOLS = 1..q;

% Decision variables
array[SEQUENCES, POSITIONS] of var SYMBOLS: codewords;

% Constraints

% Each symbol occurs lambda times per codeword
constraint forall(s in SEQUENCES, sym in SYMBOLS)(sum(p in POSITIONS)(codewords[s, p] == sym) = lambda);

% Hamming distance constraint
constraint forall(s1, s2 in SEQUENCES where s1 < s2)(sum(p in POSITIONS)(codewords[s1, p] != codewords[s2, p]) = d);

% Solve
solve satisfy;

% Output
output [if p == 1 then "\n" else "" endif ++ show(codewords[s, p]) | s in SEQUENCES, p in POSITIONS];
