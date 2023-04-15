from ortools.sat.python import cp_model

model = cp_model.CpModel()

grid = {}
for i in range(10):
    for j in range(10):
        grid[(i,j)] = model.NewIntVar(0,1, f"grid_{i}_{j}")

# constraints
for i in range(10):
    row_count = model.NewIntVar(0,10,f"row_count_{i}")
    model.Add(row_count == sum(grid[(i,j)] for j in range(10)))
    model.Add(row_count == 1) # only one ship per row/col
    
    col_count = model.NewIntVar(0,10,f"col_count_{i}")
    model.Add(col_count == sum(grid[(j,i)] for j in range(10)))
    model.Add(col_count == 1) # only one ship per row/col
    
    for k in range(1,5): # ships from battleship to submarine
        for j in range(10-k+1): # iterate over indices where ship can fit
            horiz_var = [grid[(i,j+t)] for t in range(k)]
            vert_var = [grid[(j+t,i)] for t in range(k)]
            model.Add(sum(horiz_var) <= 1) # non-overlapping
            model.Add(sum(vert_var) <= 1)
            
for point in prohibited_gridpoints:
    model.Add(grid[point] == 0) # cannot be used
    
for i in range(4):
    model.Add(grid[submarine_positions[i]] == 1)
    
for i in range(2):
    model.Add(grid[battleship_head[i]] == 1)
    model.Add(grid[battleship_tail[i]] == 1)
    model.Add(sum(grid[battleship_head[i]], grid[battleship_tail[i]]) == 2)

# solve
solver = cp_model.CpSolver()
solver.parameters.num_search_workers = 8
status = solver.Solve(model)

if status == cp_model.Optimal:
    for i in range(10):
        row = ""
        for j in range(10):
            row += str(solver.Value(grid[(i,j)]))
        print(row)
