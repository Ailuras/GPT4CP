om ortools.sat.python import cp_model

def model_ramsey_numbers(n, k):
    model = cp_model.CpModel()

    nodes = list(range(n))
    edges = [(i, j) for i in nodes for j in nodes if i < j]

    variables = {}
    for edge in edges:
        for color in range(k):
            variables[edge, color] = model.NewBoolVar(f'edge_{edge}_color_{color}')

    for i in nodes:
        for j in nodes:
            if i < j:
                for color in range(k):
                    model.AddBoolOr([variables[(i, j), c] for c in range(k) if c != color])
    
    for i in nodes:
        for j in nodes:
            if i < j:
                for k in nodes:
                    if j < k:
                        for color in range(k):
                            model.AddBoolOr([variables[(i, j), c] for c in range(k) if c != color])
                            model.AddBoolOr([variables[(i, k), c] for c in range(k) if c != color])
                            model.AddBoolOr([variables[(j, k), c] for c in range(k) if c != color])
                            model.AddBoolOr([variables[(i, j), c] for c in range(k) if c != color] + [variables[(i, k), c] for c in range(k) if c != color] + [variables[(j, k), c] for c in range(k) if c != color])

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 60.0
    status = solver.Solve(model)

    if status == cp_model.FEASIBLE:
        solution = {(i, j): None for i, j in edges}
        for edge, color in variables.items():
            if solver.Value(color):
                solution[edge[:2]] = edge[2]
        return solution
    else:
        return Non