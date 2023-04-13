
from ortools.sat.python import cp_model


def progressive_party():
    model = cp_model.CpModel()

    # Data
    boats = range(7)
    time_periods = range(6)
    capacities = [4, 5, 4, 5, 4, 5, 999]
    crew_sizes = [2, 2, 1, 1, 1, 1, 0]

    # Variables
    host = [model.NewBoolVar(f"boat_{i}_host") for i in boats]
    visit = {(i, j): [model.NewBoolVar(f"time_{t}_on_{i}_visiting_{j}")
                       for t in time_periods]
             for i in boats[:-1] for j in boats[:-1] if i != j}

    # Constraints
    # Each guest must visit exactly one host
    for j in boats[:-1]:
        model.Add(sum(visit[(i, j)][t] for i in boats[:-1] if i != j
                      for t in time_periods) == 1)

    # Each host must be visited by at least one guest
    for i in boats[:-1]:
        model.Add(sum(visit[(i, j)][t] for j in boats[:-1] if i != j
                      for t in time_periods) >= host[i])

    # Guest boats can only visit hosts once
    for i in boats[:-1]:
        for j in boats[:-1]:
            if i != j:
                for t in time_periods:
                    model.Add(visit[(i, j)][t] + visit[(j, i)][t] <= 1)

    # Capacity constraints
    for i in boats:
        for t in time_periods:
            model.Add(sum(crew_sizes[j]*visit[(j, i)][t]
                          for j in boats[:-1] if j != i) <= capacities[i])

    # Objective
    model.Minimize(sum(host))

    # Solve
    solver = cp_model.CpSolver()
    solver.Solve(model)

    # Print solution
    for i in boats[:-1]:
        print(f"Boat {i}: Host={solver.Value(host[i])}\tVisiting=", end="")
        for j in boats[:-1]:
            if i != j and solver.Value(visit[(i, j)][0]) == 1:
                print(f"{j}", end="")
        print()


progressive_party()
