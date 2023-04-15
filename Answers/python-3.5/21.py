python
from ortools.sat.python import cp_model

model = cp_model.CpModel()

grid = [[model.NewIntVar(0, 9, f"grid_{i}_{j}") for j in range(9)] for i in range(9)]

# Define constraints
for i in range(9):
    # Rows and columns can't have repeated numbers
    model.AddAllDifferent(grid[i])
    model.AddAllDifferent([grid[j][i] for j in range(9)])
    
    # Add constraints for each clue
    if i == 0:
        model.Add(grid[0][0] == 2)
        model.Add(grid[0][1] == 7)
        model.Add(grid[0][3] == 4)
        model.Add(grid[0][5] == 3)
        model.Add(grid[0][6] == 0)
        model.Add(grid[0][7] == 2)
        model.Add(grid[0][8] == 4)
        
    if i == 3:
        model.Add(grid[3][0] == 1)
        model.Add(grid[3][1] == 6)
        model.Add(grid[3][3] == 2)
        model.Add(grid[3][5] == 5)
        model.Add(grid[3][7] == 8)
        model.Add(grid[3][8] == 7)
        
    if i == 5:
        model.Add(grid[5][0] == 1)
        model.Add(grid[5][2] == 8)
        model.Add(grid[5][3] == 4)
        model.Add(grid[5][5] == 7)
        model.Add(grid[5][7] == 2)
        model.Add(grid[5][8] == 5)
        
    if i == 6:
        model.Add(grid[6][1] == 2)
        model.Add(grid[6][3] == 8)
        model.Add(grid[6][5] == 4)
        model.Add(grid[6][7] == 9)
        
    if i == 7:
        model.Add(grid[7][0] == 2)
        model.Add(grid[7][2] == 3)
        model.Add(grid[7][3] == 6)
        model.Add(grid[7][6] == 4)
        model.Add(grid[7][7] == 7)
        
    if i == 8:
        model.Add(grid[8][0] == 2)
        model.Add(grid[8][1] == 9)
        model.Add(grid[8][4] == 4)
        model.Add(grid[8][5] == 6)
        model.Add(grid[8][8] == 0)
        
model.Add(grid[1][0] * 10000 + grid[1][1] * 1000 + grid[1][3] * 100 + grid[1][4] * 10 + grid[1][5] == 
          (grid[1][7] * 1000 + grid[1][8] * 100 + 20 * 27))

model.Add(grid[3][0] * 1000 + grid[3][1] * 100 + grid[3][3] * 10 + grid[3][5] + 71 == 
          grid[0][1] * 1000 + grid[1][1] * 100 + grid[3][1] * 10 + grid[4][1])

model.Add(grid[2][2] * 1000 + grid[2][3] * 100 + grid[2][4] * 10 + grid[2][5] == 4 * 12)

model.Add(grid[2][6] * 1000 + grid[2][7] * 100 + grid[2][8] == 7 * 144)

# Solve model
solver = cp_model.CpSolver()
status = solver.Solve(model)

if status == cp_model.FEASIBLE:
    for i in range(9):
        print([int(solver.Value(grid[i][j])) if solver.Value(grid[i][j]) is not None else "X" for j in range(9)])
