from ortools.sat.python import cp_model

def number_partitioning(N):
    model = cp_model.CpModel()

    # Variables
    partition = [model.NewIntVar(0, 1, f'partition_{i}') for i in range(1, N + 1)]

    # Constraints
    sum_A = sum([partition[i - 1] * i for i in range(1, N + 1)])
    sum_B = sum([(1 - partition[i - 1]) * i for i in range(1, N + 1)])

    sum_sq_A = sum([partition[i - 1] * i * i for i in range(1, N + 1)])
    sum_sq_B = sum([(1 - partition[i - 1]) * i * i for i in range(1, N + 1)])

    model.Add(sum_A == sum_B)
    model.Add(sum_sq_A == sum_sq_B)

    # Solve
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Print solution
    if status == cp_model.OPTIMAL:
        A = [i for i in range(1, N + 1) if solver.Value(partition[i - 1]) == 1]
        B = [i for i in range(1, N + 1) if solver.Value(partition[i - 1]) == 0]
        print("A:", A)
        print("B:", B)
    else:
        print("No solution found.")

number_partitioning(10)
