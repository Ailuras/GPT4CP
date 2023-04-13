python
from ortools.sat.python import cp_model

model = cp_model.CpModel()

# Variables
bucket_8 = model.NewIntVar(0, 8, 'bucket_8')
bucket_5 = model.NewIntVar(0, 5, 'bucket_5')
bucket_3 = model.NewIntVar(0, 3, 'bucket_3')

# Constraints
model.Add(bucket_8 == 4 + bucket_5 + bucket_3)
model.Add(bucket_5 <= 4)
model.Add(bucket_3 <= 4)
model.Add(bucket_5 + bucket_3 >= 4)
model.Add(bucket_5 + bucket_3 <= 8)

# Objective
model.Minimize(bucket_5 + bucket_3)

# Solve
solver = cp_model.CpSolver()
status = solver.Solve(model)

# Output
if status == cp_model.OPTIMAL:
    print("Minimum number of transfers:", solver.ObjectiveValue())
    print("Bucket 8 contains:", solver.Value(bucket_8), "pints")
    print("Bucket 5 contains:", solver.Value(bucket_5), "pints")
    print("Bucket 3 contains:", solver.Value(bucket_3), "pints")
