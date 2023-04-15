
% Progressive Party Problem
% Given some boats, certain boats are to be designated hosts, and the crews of the remaining boats in turn visit the host boats for several successive periods.
% The crew of a host boat remains on board to act as hosts while the crew of a guest boat together visits several hosts.
% Every boat can only hold a limited number of people at a time (its capacity) and crew sizes are different.
% The total number of people aboard a boat, including the host crew and guest crews, must not exceed the capacity.
% A table with boat capacities and crew sizes can be found below; there were six time periods.
% A guest boat cannot revisit a host and guest crews cannot meet more than once.
% The goal is to minimize the number of host boats.

% Define data
int: n = 14; % Number of boats
set of int: BOATS = 1..n;
int: periods = 6; % Number of time periods
int: max_capacity = 100;
array[BOATS] of int: capacity = [8, 8, 6, 10, 10, 6, 6, 6, 10, 10, 6, 8, 8, 6]; % Capacity of each boat
array[BOATS] of int: crew_size = [6, 6, 4, 8, 8, 3, 3, 3, 8, 8, 3, 6, 6, 4]; % Crew size of each boat

% Define variables
% Assign host to each time period
array[1..periods] of var BOATS: host;
% Assign each guest to a host and a time period
array[BOATS, 1..periods] of var BOATS: guest;

% Define constraints
constraint all_different(host);

constraint forall(i in BOATS, j in 1..periods where i != host[j]) (
    sum(k in 1..periods where k != j) (
        if guest[i,k] == 0 then 0
        else if guest[i,k] = host[j] then crew_size[i]
        else 0
        endif
    ) + crew_size[i] <= capacity[i] % capacity constraint
);

constraint forall(i in BOATS, j in 1..periods) (
    if guest[i,j] = 0 then true % no guest assigned
    else if guest[i,j] = host[j] then false % cannot be on their own boat
    else (guest[i,j] not in host[1..j-1]) % unique visit to a host boat
    endif
);

% Define objective
solve minimize count(host);

% Output solution
output ["Number of host boats: \(count(host))\n",
        "Host assignments: \(host)\n",
        "Guest assignments: \(guest)\n"];
