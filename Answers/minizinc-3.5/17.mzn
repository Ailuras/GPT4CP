
int: n;  % number of nodes
int: k;  % number of colours

set of int: NODES = 1..n;

set of int: COLOURS = 1..k;

array[NODES, NODES, COLOURS] of var bool: x;

% At least one colour is used for each edge
constraint forall (i, j in NODES where i<j) (
    sum(c in COLOURS) (x[i,j,c]) >= 1
);

% At most two edges have the same colour in any triangle
predicate is_triangle(int: i, int: j, int: k) =
    i < j /\ j < k /\ x[i,j,_] /\ x[j,k,_] /\ x[i,k,_];

constraint forall (i, j, k in NODES where is_triangle(i,j,k)) (
    sum(c in COLOURS) (x[i,j,c] /\ x[j,k,c] /\ x[i,k,c]) <= 2
);

solve satisfy;
