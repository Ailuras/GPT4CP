
%Bus Driver Scheduling problem

%Number of tasks
int: n;

%Number of shifts
int: m;

%task (i) is in shift(j) if 1, otherwise if 0
array[1..n,1..m] of var 0..1: x;

%Variable to store the number of selected shifts
var int: numShifts;

%Each task should be covered exactly once
constraint forall(i in 1..n)
    (
        sum(j in 1..m)(x[i,j]) = 1
    );

%Minimize the number of selected shifts
solve minimize numShifts;

%The goal is to cover each task exactly once, so the number of selected shifts should be equal to the number of tasks
%Otherwise, there is no solution
constraint numShifts = n;
