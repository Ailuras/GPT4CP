include "globals.mzn";

int: q; % Number of edges
int: n_vertices;
set of int: VERTICES = 1..n_vertices;
array[VERTICES, VERTICES] of var 0..1: adjacency_matrix;

% Decision variables
array[VERTICES] of var 0..q: node_labels;
array[VERTICES, VERTICES] of var 0..q: edge_labels;

% Constraints

% No loops
constraint forall(v in VERTICES)(adjacency_matrix[v, v] = 0);

% Undirected graph
constraint forall(v1, v2 in VERTICES where v1 < v2)(adjacency_matrix[v1, v2] = adjacency_matrix[v2, v1]);

% Number of edges equals q
constraint sum(v1, v2 in VERTICES where v1 < v2)(adjacency_matrix[v1, v2]) = q;

% Unique node labels
constraint alldifferent(node_labels);

% Edge labelling constraints
constraint forall(v1, v2 in VERTICES where v1 < v2)(
  if adjacency_matrix[v1, v2] = 1 then
    edge_labels[v1, v2] = abs(node_labels[v1] - node_labels[v2]) /\ edge_labels[v2, v1] = edge_labels[v1, v2]
  else
    edge_labels[v1, v2] = 0 /\ edge_labels[v2, v1] = 0
  endif
);

% Unique edge labels
constraint alldifferent(array1d(edge_labels));

% Solve
solve satisfy;

% Output
output ["\nNode labels: ", show(node_labels), "\n"];
