% Input parameters
enum BUCKET = {A, B, C};
int: capacity_A = 8;
int: capacity_B = 5;
int: capacity_C = 3;

% State representation: (water in A, water in B, water in C)
tuple state {int a; int b; int c;}

% Decision variable
array[1..6] of var state: states;

% Initial state
constraint states[1] = state(capacity_A, 0, 0);

% Constraints
constraint forall(i in 2..6)(
  let {
    % Extract water amounts
    int: prev_A = states[i-1].a;
    int: prev_B = states[i-1].b;
    int: prev_C = states[i-1].c;

    % Calculate possible transfer amounts
    int: transfer_A_to_B = min(prev_A, capacity_B - prev_B);
    int: transfer_A_to_C = min(prev_A, capacity_C - prev_C);
    int: transfer_B_to_A = min(prev_B, capacity_A - prev_A);
    int: transfer_B_to_C = min(prev_B, capacity_C - prev_C);
    int: transfer_C_to_A = min(prev_C, capacity_A - prev_A);
    int: transfer_C_to_B = min(prev_C, capacity_B - prev_B);
  } in (
    % Possible next states
    states[i] = state(prev_A - transfer_A_to_B, prev_B + transfer_A_to_B, prev_C)
    \/ states[i] = state(prev_A - transfer_A_to_C, prev_B, prev_C + transfer_A_to_C)
    \/ states[i] = state(prev_A + transfer_B_to_A, prev_B - transfer_B_to_A, prev_C)
    \/ states[i] = state(prev_A, prev_B - transfer_B_to_C, prev_C + transfer_B_to_C)
    \/ states[i] = state(prev_A + transfer_C_to_A, prev_B, prev_C - transfer_C_to_A)
    \/ states[i] = state(prev_A, prev_B + transfer_C_to_B, prev_C - transfer_C_to_B)
  )
);

% Goal state
constraint states[6].a = 4 /\ states[6].b = 4 /\ states[6].c = 0;

% Solve the problem
solve satisfy;
