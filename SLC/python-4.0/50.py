from ortools.sat.python import cp_model
import itertools

def diamond_free_degree_sequences(n):
    model = cp_model.CpModel()

    # Variables
    degrees = [model.NewIntVar(1, n, f'degree_{i}') for i in range(n)]

    # Constraints
    for i in range(n - 1):
        model.Add(degrees[i] >= degrees[i + 1])

    model.Add(sum(degrees) % 12 == 0)

    for degree in degrees:
        model.Add(degree % 3 == 0)

    # Diamond free constraint
    for u, v, w, x in itertools.combinations(range(n), 4):
        model.Add(degrees[u] + degrees[v] + degrees[w] + degrees[x] <= 4 * n - 10)

    # Solve
    solver = cp_model.CpSolver()
    solution_printer = cp_model.VarArrayAndObjectiveSolutionPrinter(degrees)
    status = solver.SearchForAllSolutions(model, solution_printer)

    if status == cp_model.UNKNOWN:
        print("No solution found.")

diamond_free_degree_sequences(8)
