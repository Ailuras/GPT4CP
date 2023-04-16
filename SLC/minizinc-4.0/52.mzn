include "globals.mzn";

int: m; % Number of vertices
int: k; % Girth

% Decision variables
set of int: VERTICES = 1..m;
array[VERTICES, VERTICES] of var 0..1: adjacency_matrix;

% Constraints

% No loops
constraint forall(v in VERTICES)(adjacency_matrix[v, v] = 0);

% Undirected graph
constraint forall(v1, v2 in VERTICES where v1 < v2)(adjacency_matrix[v1, v2] = adjacency_matrix[v2, v1]);

% No cycles of length k or less
constraint forall(v in VERTICES, path in index_set_1of2(adjacency_matrix), i in 1..k-1)(if adjacency_matrix[v, path] = 1 /\ adjacency_matrix[path, (v+i) mod m + 1] = 1 then adjacency_matrix[v, (v+i) mod m + 1] = 0 else true endif);

% Objective function
var int: n_edges = sum(v1, v2 in VERTICES where v1 < v2)(adjacency_matrix[v1, v2]);
solve maximize n_edges;

% Output
output ["\nMaximal number of edges (fk(m)): ", show(n_edges), "\n"];
