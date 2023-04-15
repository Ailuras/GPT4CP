include "globals.mzn";

int: nBoats;
set of int: Boats = 1..nBoats;
array[Boats] of int: capacities;
array[Boats] of int: crewSizes;
int: nPeriods = 6;

% Decision variables
array[Boats, Boats] of var 0..1: hostGuest;
array[Boats] of var 0..1: isHost;

% Objective: minimize number of host boats
solve minimize sum(isHost);

% Constraints
constraint
forall(b in Boats) (
% A boat is either a host or a guest, but not both
isHost[b] + sum(i in Boats)(hostGuest[i, b]) == 1
);

constraint
forall(b in Boats) (
% A guest boat visits nPeriods host boats
if isHost[b] = 0 then
sum(h in Boats)(hostGuest[b, h]) = nPeriods
else
true
endif
);

constraint
forall(h in Boats) (
% A host boat can't exceed its capacity
sum(g in Boats)(crewSizes[g] * hostGuest[g, h]) <= capacities[h] * isHost[h]
);

constraint
forall(g1, g2 in Boats where g1 < g2) (
% Guest boats can't meet more than once
sum(h in Boats)(hostGuest[g1, h] * hostGuest[g2, h]) <= 1
);

% Output
output [
"Host boats: ", show({b | b in Boats where isHost[b] = 1}), "\n",
"Guest-Host matrix:\n"
] ++ [if b2 = nBoats then "\n" else "" endif
| b1, b2 in Boats, g2 in (0..1)
where g2 = hostGuest[b1, b2]]