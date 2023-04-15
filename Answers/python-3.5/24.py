from ortools.sat.python import cp_model

def langford_numbers(n):
    model = cp_model.CpModel()
    variables = {}
    for i in range(1, n+1):
        variables[i] = [model.NewIntVar(0, 2*n-i-1, f'pos_{i}_{j}') for j in range(2)]

    for i in range(1, n+1):
        for j in range(2):
            model.Add(variables[i][j] + i <= 2*n)

    for i in range(1, n+1):
        for j in range(2):
            for k in range(j+1, 2):
                model.Add(variables[i][k] - variables[i][j] == i)

    for i in range(1, n+1):
        for j in range(i+1, n+1):
            for k in range(2):
                for l in range(2):
                    model.Add(variables[i][k] != variables[j][l])

    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.OPTIMAL:
        sequence = [0] * (2*n)
        for i in range(1, n+1):
            for j in range(2):
                pos = solver.Value(variables[i][j])
                sequence[pos] = i
        return sequence

print(langford_numbers(4))
