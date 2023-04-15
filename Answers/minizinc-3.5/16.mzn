enum COLORS = {r, ry, g, y};

% Variables for traffic lights for vehicles (V) and pedestrians (P)
array[1..4] of var COLORS: V;
array[1..4] of var {r, g}: P;

% Constraints for traffic lights
constraint V[1] != r \/ V[2] != r \/ V[3] != g \/ V[4] != g;
constraint V[1] != ry \/ V[2] != r \/ V[3] != y \/ V[4] != r;
constraint V[1] != g \/ V[2] != g \/ V[3] != r \/ V[4] != r;
constraint V[1] != y \/ V[2] != r \/ V[3] != ry \/ V[4] != r;

% Solve the problem
solve satisfy;

% Output the solution
output [ "V = \(V)\n", "P = \(P)\n" ];
