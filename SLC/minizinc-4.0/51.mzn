include "globals.mzn";

int: n_tanks;
int: n_cargos;
set of int: TANKS = 1..n_tanks;
set of int: CARGOS = 1..n_cargos;

array[TANKS] of int: tank_capacity;
array[TANKS] of set of int: forbidden_cargo;
array[TANKS] of set of int: adjacent_tanks;

array[CARGOS] of int: cargo_volume;
array[CARGOS] of set of int: incompatible_cargo;

% Decision variable
array[TANKS] of var 0..n_cargos: tank_content;

% Constraints

% One cargo per tank
constraint forall(t in TANKS)(tank_content[t] != 0 -> sum([tank_content[t2] == tank_content[t] | t2 in adjacent_tanks[t]]) == 0);

% Forbidden cargo constraint
constraint forall(t in TANKS, c in forbidden_cargo[t])(tank_content[t] != c);

% Incompatible cargo constraint
constraint forall(c1 in CARGOS, c2 in incompatible_cargo[c1], t in TANKS)(tank_content[t] == c1 -> not exists(t2 in adjacent_tanks[t])(tank_content[t2] == c2));

% Cargo volume constraint
constraint forall(c in CARGOS)(sum([tank_capacity[t] * bool2int(tank_content[t] == c) | t in TANKS]) >= cargo_volume[c]);

% Objective function
var int: unused_volume = sum(t in TANKS)(tank_capacity[t]) - sum(c in CARGOS)(sum([tank_capacity[t] * bool2int(tank_content[t] == c) | t in TANKS]));
solve maximize unused_volume;

% Output
output ["\nTank content: ", show(tank_content), "\nUnused volume: ", show(unused_volume)];
