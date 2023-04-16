int: n_tasks;
int: n_servers;
int: n_periods;
set of int: TASKS = 1..n_tasks;
set of int: SERVERS = 1..n_servers;
set of int: PERIODS = 1..n_periods;

array[TASKS] of int: duration;
array[TASKS] of int: release;
array[TASKS] of int: due;
array[TASKS, 1..3] of int: resource_req;
array[SERVERS, 1..3] of int: server_capacity;
array[SERVERS] of int: idle_power;
array[SERVERS] of int: startup_cost;
array[SERVERS] of int: shutdown_cost;
array[PERIODS] of float: electricity_forecast;

% Decision variables
array[TASKS, SERVERS, PERIODS] of var 0..1: task_allocation;
array[SERVERS, PERIODS] of var 0..1: server_state;

% Constraints

% Task allocation constraints
constraint forall(t in TASKS)(
  sum(s in SERVERS, p in PERIODS)(task_allocation[t, s, p]) == 1
);

% Task release and due date constraints
constraint forall(t in TASKS, s in SERVERS, p in PERIODS)(
  task_allocation[t, s, p] == 0
  \/
  (p >= release[t] /\ p + duration[t] - 1 <= due[t])
);

% Server capacity constraints
constraint forall(s in SERVERS, p in PERIODS)(
  sum(t in TASKS, p_t in PERIODS where p_t >= p - duration[t] + 1 /\ p_t <= p)(task_allocation[t, s, p_t] * resource_req[t, 1]) <= server_capacity[s, 1]
  /\
  sum(t in TASKS, p_t in PERIODS where p_t >= p - duration[t] + 1 /\ p_t <= p)(task_allocation[t, s, p_t] * resource_req[t, 2]) <= server_capacity[s, 2]
  /\
  sum(t in TASKS, p_t in PERIODS where p_t >= p - duration[t] + 1 /\ p_t <= p)(task_allocation[t, s, p_t] * resource_req[t, 3]) <= server_capacity[s, 3]
);

% Server state constraints
constraint forall(s in SERVERS, p in PERIODS)(
  server_state[s, p] = sum(t in TASKS)(task_allocation[t, s, p]) > 0
);

% Server start-up and shut-down constraints
constraint forall(s in SERVERS)(
  server_state[s, 1] <= 1
  /\
  server_state[s, n_periods] == 0
);

% Objective function
var float: total_energy_cost = sum(s in SERVERS, p in PERIODS)(
  (idle_power[s] * server_state[s, p] + startup_cost[s] * (server_state[s, p] - server_state[s, max(1, p - 1)] > 0) + shutdown_cost[s] * (server_state[s, p + 1] - server_state[s, p] < 0)) * electricity_forecast[p]
);

solve minimize total_energy_cost;

% Output
output ["\nTask allocation: ", show(task_allocation), "\nServer states: ", show(server_state), "\nTotal energy cost: ", show(total_energy_cost)];
