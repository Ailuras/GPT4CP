python
from ortools.sat.python import cp_model

def langford(n):
    model = cp_model.CpModel()
    positions = [model.NewIntVar(0, 2 * n, f'position_{i}') for i in range(2 * n)]
    for i in range(n):
        model.Add(positions[i] + i + 1 == positions[n + i])
        for j in range(i + 1, n):
            model.Add(abs(positions[i] - positions[j]) != j + 1)
            model.Add(abs(positions[n + i] - positions[n + j]) != j + 1)
    solver = cp_model.CpSolver()
    status = solver.Solve(model)
    if status == cp_model.FEASIBLE:
        sequence = [0] * 2 * n
        for i in range(2 * n):
            sequence[solver.Value(positions[i])] = i + 1
        return sequence
