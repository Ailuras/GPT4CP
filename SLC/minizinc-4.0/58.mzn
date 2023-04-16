int: n_items;
int: n_periods;
set of int: ITEMS = 1..n_items;
set of int: PERIODS = 1..n_periods;

array[ITEMS, PERIODS] of int: demand;
array[ITEMS, ITEMS] of int: changeover_cost;
array[ITEMS, PERIODS] of int: storage_cost;

% Decision variables
array[PERIODS] of var ITEMS: production;
array[ITEMS, PERIODS] of var 0..n_periods: inventory;

% Constraints

% Production limit
constraint forall(p in PERIODS)(sum(i in ITEMS)(inventory[i, p]) <= 1);

% Production and demand constraints
constraint forall(i in ITEMS, p in PERIODS)(
  if p == 1 then
    inventory[i, p] = (production[p] == i) - demand[i, p]
  else
    inventory[i, p] = inventory[i, p - 1] + (production[p] == i) - demand[i, p]
  endif
);

% Objective function
var int: total_storage_cost = sum(i in ITEMS, p in PERIODS)(inventory[i, p] * storage_cost[i, p]);
var int: total_changeover_cost = sum(p in 2..n_periods)(changeover_cost[production[p - 1], production[p]]);
var int: total_cost = total_storage_cost + total_changeover_cost;

solve minimize total_cost;

% Output
output ["\nProduction schedule: ", show(production), "\nTotal cost: ", show(total_cost)];
