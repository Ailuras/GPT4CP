% Input parameters
int: n_tasks;
int: n_shifts;
set of int: TASKS = 1..n_tasks;
set of int: SHIFTS = 1..n_shifts;

% Shifts as subsets of tasks (0-1 matrix, where shift_task[i, j] = 1 if shift i covers task j)
array[SHIFTS, TASKS] of 0..1: shift_task;

% Decision variable
array[SHIFTS] of var 0..1: selected_shift;

% Constraints
% Each task is covered exactly once
constraint forall(j in TASKS)(
  sum(i in SHIFTS) (shift_task[i, j] * selected_shift[i]) = 1
);

% Objective
% Minimize the number of selected shifts
solve minimize sum(selected_shift);
