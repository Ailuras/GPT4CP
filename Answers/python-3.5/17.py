from ortools.sat.python import cp_model

def build_ramsey(n, k):
    model = cp_model.CpModel()

    # Variables for the edge colours
    edges = {}
    for i in range(1, n):
        for j in range(i+1, n+1):
            edges[(i,j)] = model.NewIntVar(1, k, f"({i},{j})")

    # Constraints for the edge colours
    for i in range(1, n-1):
        for j in range(i+1, n):
            for m in range(j+1, n+1):
                # Constraints for triangles
                model.AddAllDifferent([edges[(i,j)], edges[(i,m)], edges[(j,m)]])
                
    # Solve the problem
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.FEASIBLE:
        # Output the solution
        print("Edges with their respective colours:")
        for i in range(1, n):
            for j in range(i+1, n+1):
                print(f"({i},{j}) -> {solver.Value(edges[(i,j)])}")
    else:
        print(f"No solution with {k} colours for the complete graph with {n} nodes.")
    
build_ramsey(6, 3)
