% Input parameters
enum COLORS_V = {r, ry, g, y};
enum COLORS_P = {r, g};

% Decision variables
array[1..4] of var COLORS_V: V; % Traffic lights for vehicles
array[1..4] of var COLORS_P: P; % Traffic lights for pedestrians

% Constraints
constraint forall(i in 1..4)(
  % Quaternary constraints for traffic junction
  let {
    int: j = 1 + (i mod 4)
  } in (
    (V[i] = r /\ P[i] = r /\ V[j] = g /\ P[j] = g)
    \/ (V[i] = ry /\ P[i] = r /\ V[j] = y /\ P[j] = r)
    \/ (V[i] = g /\ P[i] = g /\ V[j] = r /\ P[j] = r)
    \/ (V[i] = y /\ P[i] = r /\ V[j] = ry /\ P[j] = r)
  )
);

% Solve the problem
solve satisfy;
