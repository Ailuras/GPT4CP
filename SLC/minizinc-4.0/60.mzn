int: n_drivers;
int: n_riders;
int: n_shifters;
int: n_locations;
int: MAX_SEATS = 10;

set of int: DRIVERS = 1..n_drivers;
set of int: RIDERS = 1..n_riders;
set of int: SHIFTERS = n_drivers+1..n_drivers+n_shifters;
set of int: ALL_DRIVERS = 1..n_drivers+n_shifters;
set of int: LOCATIONS = 1..n_locations;

array[ALL_DRIVERS] of int: driver_capacity;
array[ALL_DRIVERS, LOCATIONS, LOCATIONS] of int: driver_time_window;
array[ALL_DRIVERS, LOCATIONS, LOCATIONS] of int: travel_time;
array[RIDERS, LOCATIONS, LOCATIONS] of int: rider_time_window;
array[SHIFTERS] of int: shifter_request_start;
array[SHIFTERS] of int: shifter_request_end;

% Decision variables
array[ALL_DRIVERS, RIDERS] of var 0..1: rideshare_allocation;
array[SHIFTERS] of var 0..1: shifter_as_rider;
array[ALL_DRIVERS, RIDERS] of var int: driver_departure_time;
array[ALL_DRIVERS, RIDERS] of var int: driver_arrival_time;

% Constraints

% Each rider is assigned to at most one driver
constraint forall(r in RIDERS)(
  sum(d in ALL_DRIVERS)(rideshare_allocation[d, r]) <= 1
);

% Satisfy driver capacities
constraint forall(d in ALL_DRIVERS)(
  sum(r in RIDERS)(rideshare_allocation[d, r]) <= driver_capacity[d]
);

% Time window and route constraints for riders and drivers
constraint forall(d in ALL_DRIVERS, r in RIDERS)(
  rideshare_allocation[d, r] = 0
  \/
  (
    driver_time_window[d, shifter_request_start[r], shifter_request_end[r]] = 1
    /\
    driver_departure_time[d, r] >= rider_time_window[r, shifter_request_start[r], 1]
    /\
    driver_arrival_time[d, r] <= rider_time_window[r, shifter_request_end[r], 2]
    /\
    driver_arrival_time[d, r] - driver_departure_time[d, r] >= travel_time[d, shifter_request_start[r], shifter_request_end[r]]
  )
);

% Shifter constraints
constraint forall(s in SHIFTERS)(
  (
    sum(r in RIDERS)(rideshare_allocation[s, r]) > 0
    /\
    shifter_as_rider[s] = 0
  )
  \/
  (
    sum(r in RIDERS)(rideshare_allocation[s, r]) = 0
    /\
    shifter_as_rider[s] = 1
  )
);

% Objective function
var int: total_riders_served = sum(d in ALL_DRIVERS, r in RIDERS)(rideshare_allocation[d, r]);

solve maximize total_riders_served;

% Output
output ["\nRideshare allocation: ", show(rideshare_allocation), "\nShifter as rider: ", show(shifter_as_rider), "\nTotal riders served: ", show(total_riders_served)];
