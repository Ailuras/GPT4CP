
int: bucket1_capacity = 8;
int: bucket2_capacity = 5;
int: bucket3_capacity = 3;

set of int: buckets = 1..3;

set of int: transitions = {
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
};

% Define the possible state transitions as pairs of source and target buckets.
array[transitions, 1..2] of buckets: transition_map = array2d(transitions, 1..2, [
  % bucket1 to bucket2
  1, 2,
  % bucket1 to bucket3
  1, 3,
  % bucket2 to bucket1
  2, 1,
  % bucket2 to bucket3
  2, 3,
  % bucket3 to bucket1
  3, 1,
  % bucket3 to bucket2
  3, 2,
  % bucket1 to sink
  1, 0,
  % bucket2 to sink
  2, 0,
  % bucket3 to sink
  3, 0,
  % source is the sink (no action)
  0, 0,
  % target is the sink (no action)
  0, 0,
  % target is source (no action)
  1, 1,
  2, 2,
  3, 3,
  % fill bucket1 to capacity
  0, 1,
  % fill bucket2 to capacity
  0, 2
]);

% Define the starting state and the goal state.
array[buckets] of int: initial_state = [8, 0, 0];
array[buckets] of int: goal_state = [4, 4, 0];

% Define the state variables.
array[transitions] of var buckets: state;
array[buckets, transitions] of var 0..bucket1_capacity: bucket_levels;

% Set the initial state.
constraint state[1] = 0 /\ bucket_levels[1, 1] = initial_state[1] /\
  bucket_levels[2, 1] = initial_state[2] /\ bucket_levels[3, 1] = initial_state[3];

% Define the state transitions.
constraint forall(t in transitions) (
  let {
    var source = transition_map[t, 1];
    var target = transition_map[t, 2];
    var source_level = bucket_levels[source, t];
    var target_level = bucket_levels[target, t];
  } in (
    (
      % If the target is empty, fill it to capacity.
      target_level = bucket1_capacity /\
      bucket1_capacity > source_level /\ source != 3
    ) \/
    (
      % If the target is not empty and not full, pour water from source to target.
      target != 0 /\
      target != 3 /\
      source_level > 0 /\
      target_level < bucket_levels[target, t-1] /\
      target_level + source_level <= bucket3_capacity
    ) \/
    (
      % If the source is not empty and the target is not full, pour water from source to target.
      source != 0 /\
      target != 3 /\
      source_level > 0 /\
      target_level > bucket_levels[target, t-1] /\
      target_level + source_level > bucket3_capacity
    )
  ) /\
  (state[t] = source /\ state[t+1] = target) /\
  (
    % Update the levels of the buckets.
    bucket_levels[source, t+1] = source_level - (target_level - bucket_levels[target, t-1]) /\
    bucket_levels[target, t+1] = if target != 3 then target_level + (source_level - (target_level - bucket_levels[target, t-1])) else 0 else 0 endif
  )
);

% Define the goal state.
constraint bucket_levels[1, transitions] = goal_state[1] /\
  bucket_levels[2, transitions] = goal_state[2] /\
  bucket_levels[3, transitions] = goal_state[3];

% Define the objective: minimize the number of transitions.
solve minimize count(t in transitions) (state[t] > 0 /\ state[t] < 4);

% Output the solution: the sequence of transitions from the initial state to the goal state.
output [if state[t] > 0 then "Tranfer " ++ show(state[t]) ++ " from bucket " ++ show(transition_map[t, 1]) ++ " to bucket " ++ show(transition_map[t, 2]) else "Finish." endif ++ "\n" | t in transitions];
