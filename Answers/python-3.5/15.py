from ortools.sat.python import cp_model

model = cp_model.CpModel()

n = 10  # the number of balls

# Variables for the boxes
boxes = [model.NewIntVar(0, 2, f"box{i}") for i in range(n)]

# Constraints for pairs of balls
for i in range(n):
    for j in range(i+1, n):
        if i + j < n:
            # Constraints for pairs of balls that sum to a third ball
            k = i + j
            model.Add(boxes[i] != boxes[j]).OnlyEnforceIf(boxes[k] != boxes[i])
            model.Add(boxes[i] != boxes[k]).OnlyEnforceIf(boxes[j] != boxes[i])
            model.Add(boxes[j] != boxes[k]).OnlyEnforceIf(boxes[i] != boxes[j])

# Solve the problem
solver = cp_model.CpSolver()
status = solver.Solve(model)

if status == cp_model.FEASIBLE:
    # Output the solution
    print([solver.Value(box) for box in boxes])
