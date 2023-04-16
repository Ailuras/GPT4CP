from ortools.sat.python import cp_model

def n_queens(n):
    model = cp_model.CpModel()

    # Variables
    queens = [model.NewIntVar(0, n - 1, f'queen_{i}') for i in range(n)]

    # Constraints
    # All queens must be on different rows
    model.AddAllDifferent(queens)

    # No two queens can be on the same diagonal
    for i in range(n):
        for j in range(i + 1, n):
            model.Add(queens[i] - queens[j] != j - i)
            model.Add(queens[i] - queens[j] != i - j)

    # Solve the model
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Output the solution
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        return [solver.Value(queens[i]) for i in range(n)]
    else:
        return None

# Example usage
n = 8
solution = n_queens(n)
if solution is not None:
    print('Solution found:', solution)
else:
    print('No solution found')
