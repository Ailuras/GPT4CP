from ortools.sat.python import cp_model

def magic_square(n):
    model = cp_model.CpModel()

    # Variables for the cells
    cells = {}
    for i in range(n):
        for j in range(n):
            cells[(i, j)] = model.NewIntVar(1, n*n, f"({i},{j})")

    # Constraints for the rows and columns
    for i in range(n):
        row_sum = model.NewIntVar(n*(n*n+1)//2, n*(n*n+1)//2, f"row_sum{i}")
        col_sum = model.NewIntVar(n*(n*n+1)//2, n*(n*n+1)//2, f"col_sum{i}")
        model.Add(sum(cells[(i, j)] for j in range(n)) == row_sum)
        model.Add(sum(cells[(j, i)] for j in range(n)) == col_sum)

    # Constraints for the diagonals
    diag1_sum = model.NewIntVar(n*(n*n+1)//2, n*(n*n+1)//2, "diag1_sum")
    diag2_sum = model.NewIntVar(n*(n*n+1)//2, n*(n*n+1)//2, "diag2_sum")
    model.Add(sum(cells[(i, i)] for i in range(n)) == diag1_sum)
    model.Add(sum(cells[(i, n-i-1)] for i in range(n)) == diag2_sum)

    # Constraints for all cells to be different
    model.AddAllDifferent(list(cells.values()))

    # Solve the problem
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.FEASIBLE:
        # Output the solution
        print("Magic square:")
        for i in range(n):
            row = [solver.Value(cells[(i,j)]) for j in range(n)]
            print(row)
    else:
        print(f"No solution for a {n}x{n} magic square.")
    
magic_square(4)
