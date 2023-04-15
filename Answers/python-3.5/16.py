from ortools.sat.python import cp_model

model = cp_model.CpModel()

# Variables for traffic lights for vehicles (V) and pedestrians (P)
V = [model.NewIntVar(0, 3, f"V{i}") for i in range(1, 5)]
P = [model.NewIntVar(0, 1, f"P{i}") for i in range(1, 5)]

# Constraints for traffic lights
model.Add(V[0] != 0).OnlyEnforceIf(P[1] == 0, P[2] == 0, P[3] == 1)
model.Add(V[1] != 0).OnlyEnforceIf(P[2] == 0, P[3] == 1, P[0] == 0)
model.Add(V[2] != 0).OnlyEnforceIf(P[3] == 1, P[0] == 0, P[1] == 0)
model.Add(V[3] != 1).OnlyEnforceIf(P[0] == 0, P[1] == 0, P[2] == 0)
model.Add(V[0] != 1).OnlyEnforceIf(P[0] == 0, P[2] == 1)
model.Add(V[1] != 2).OnlyEnforceIf(P[1] == 0, P[3] == 0)
model.Add(V[2] != 0).OnlyEnforceIf(P[0] == 1, P[2] == 0)
model.Add(V[3] != 0).OnlyEnforceIf(P[1] == 1, P[3] == 0)

# Solve the problem
solver = cp_model.CpSolver()
status = solver.Solve(model)

if status == cp_model.FEASIBLE:
    # Output the solution
    print(f"V = {[solver.Value(v) for v in V]}")
    print(f"P = {[solver.Value(p) for p in P]}")
