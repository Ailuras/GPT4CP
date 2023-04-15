include "globals.mzn";

% Input parameters
int: n_boats; % Number of boats
int: n_periods = 6; % Number of periods
set of int: BOATS = 1..n_boats;
array[BOATS] of int: capacity; % Capacity of each boat
array[BOATS] of int: crew_size; % Crew size of each boat

% Decision variables
array[BOATS] of var 0..1: host; % Whether a boat is a host (1) or guest (0)
array[BOATS, BOATS] of var 0..1: visit; % Whether a guest boat i visits host boat j

% Objective: Minimize the number of host boats
solve minimize sum(host);

% Constraints
constraint forall(i in BOATS)(
  % If a boat is a host, it doesn't visit other boats
  if host[i] = 1 then sum(j in BOATS) (visit[i,j]) = 0 endif
);

constraint forall(i in BOATS)(
  % If a boat is a guest, it visits exactly n_periods host boats
  if host[i] = 0 then sum(j in BOATS) (visit[i,j]) = n_periods endif
);

constraint forall(i, j in BOATS)(
  % A guest boat cannot visit another guest boat
  if visit[i,j] = 1 then host[j] = 1 endif
);

constraint forall(i, j in BOATS)(
  % A guest boat can only visit a host boat once
  if visit[i,j] = 1 then sum(k in BOATS) (visit[i,k] * visit[j,k]) = 0 endif
);

constraint forall(j in BOATS)(
  % Total number of people aboard a host boat must not exceed its capacity
  sum(i in BOATS) (visit[i,j] * crew_size[i]) + (host[j] * crew_size[j]) <= capacity[j]
);