include "globals.mzn";

int: n;
set of int: vertices = 1..n;
array[vertices] of var 0..n: degree;

% Degree constraints
constraint forall(i in 1..n-1)(degree[i] >= degree[i+1]);
constraint forall(i in vertices)(degree[i] > 0 /\ degree[i] mod 3 == 0);
constraint sum(degree) mod 12 == 0;

% Diamond-free graph constraints
constraint forall(u, v, w, x in vertices where u < v /\ v < w /\ w < x)(
    (degree[u] + degree[v] + degree[w] + degree[x]) * 
    ((degree[u] + degree[v] + degree[w] + degree[x]) - 1) / 2 <= 4);

% Number of edges constraint
constraint sum(degree) div 2 mod 6 == 0;

% Graph construction
array[vertices, vertices] of var 0..1: adjacency_matrix;
constraint forall(i, j in vertices)(adjacency_matrix[i, j] = adjacency_matrix[j, i]);
constraint forall(i in vertices)(adjacency_matrix[i, i] = 0);
constraint forall(i in vertices)(sum([adjacency_matrix[i, j] | j in vertices]) = degree[i]);

solve satisfy;

output [show(degree)];
