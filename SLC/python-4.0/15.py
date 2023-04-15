from ortools.sat.python import cp_model

def schurs_lemma(n):
    model = cp_model.CpModel()
    box_vars = [[model.NewBoolVar(f'box_{i}_{j}') for j in range(n)] for i in range(3)]
    ball_vars = [model.NewIntVar(0, 2, f'ball_{i}') for i in range(n)]
    
    for i in range(n):
        model.Add(sum(box_vars[j][i] for j in range(3)) == 1)
    
    for i in range(n):
        for j in range(i+1, n):
            if i+j < n:
                model.Add(sum(box_vars[k][i] * box_vars[l][j] for k in range(3) for l in range(3)) <= 1)
                model.Add(sum(box_vars[k][i] * box_vars[l][j] for k in range(3) for l in range(3)) + sum(box_vars[k][j] * box_vars[l][i] for k in range(3) for l in range(3)) <= 2)
    solver = cp_model.CpSolver()
    status = solver.Solve(model)
    if status == cp_model.FEASIBLE:
        boxes = [[] for i in range(3)]
        for i in range(n):
            for j in range(3):
                if solver.Value(box_vars[j][i]) == 1:
                    boxes[j].append(i+1)
        return boxes
    return None

print(schurs_lemma(10))
