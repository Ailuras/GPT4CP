int: n;
int: r;
set of int: NODES = 1..n;
set of int: RINGS = 1..r;
array[NODES, NODES] of 0..1: demand;
array[RINGS] of int: capacity_nodes;

% Decision variables
array[RINGS, NODES] of var 0..1: ring_assignment;
array[RINGS] of var int: adms_used;

% Constraints

% Node capacity constraint
constraint forall(ring in RINGS)(sum(node in NODES)(ring_assignment[ring, node]) <= capacity_nodes[ring]);

% Demand constraint
constraint forall(n1, n2 in NODES where demand[n1, n2] == 1)(exists(ring in RINGS)(ring_assignment[ring, n1] == 1 /\ ring_assignment[ring, n2] == 1));

% ADMs used
constraint forall(ring in RINGS)(adms_used[ring] = sum(node in NODES)(ring_assignment[ring, node]));

% Objective function
var int: total_adms = sum(ring in RINGS)(adms_used[ring]);
solve minimize total_adms;

% Output
output ["\nRing assignments: ", show(ring_assignment), "\nTotal ADMs used: ", show(total_adms)];
