% Input parameters
int: n;
int: k;
set of int: NODES = 1..n;
set of int: COLORS = 1..k;

% Decision variable
array[NODES, NODES] of var COLORS: edge_color;

% Constraints
constraint forall(i, j in NODES where i < j)(
  % Symmetric edge coloring
  edge_color[i, j] = edge_color[j, i]
);

constraint forall(i, j, k in NODES where i < j /\ j < k)(
  % No monochromatic triangle
  edge_color[i, j] != edge_color[j, k] \/ edge_color[i, j] != edge_color[i, k] \/ edge_color[i, k] != edge_color[j, k]
);

% Solve the problem
solve satisfy;
