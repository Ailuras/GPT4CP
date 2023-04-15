from ortools.sat.python import cp_model

def crossfigures():
    model = cp_model.CpModel()

    grid = [[1, 2, None, 3, "X", 4, None, 5, 6],
            [7, None, "X", 8, None, None, "X", 9, None],
            [None, "X", 10, None, "X", 11, 12, "X", None],
            [13, 14, None, None, "X", 15, None, 16, None],
            ["X", None, "X", "X", "X", "X", "X", None, "X"],
            [17, None, 18, 19, "X", 24, None, "X", None],
            [None, "X", 23, None, "X", 24, None, "X", None],
            [25, 26, "X", 27, None, None, "X", 28, None],
            [29, None, None, None, "X", 30, None, None, None]]

    # Variables for the non-"X" cells
    cells = {}
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] is not None:
                cells[(i, j)] = model.NewIntVar(0, 9, f"({i},{j})")

    # Constraints for the horizontally arranged numbers
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] is not None and j < len(grid[0])-1 and grid[i][j+1] is not None:
                num = int(str(grid[i][j]) + str(grid[i][j+1]))
                model.Add(cells[(i,j)]*10 + cells[(i,j+1)] == num)

    # Constraints for the vertically arranged numbers
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] is not None and i < len(grid)-1 and grid[i+1][j] is not None:
                num = int(str(grid[i][j]) + str(grid[i+1][j]))
                model.Add(cells[(i,j)]*10 + cells[(i+1,j)] == num)

    # Constraints for the clues
    model.Add(cells[(0,0)] == cells[(0,6)] + 27)
    model.Add(cells[(0,3)] == cells[(3,3)] + 71)
    model.Add(cells[(2,8)] == 4*12)
    model.Add(cells[(3,0)] == 7*144)

    # Solve the problem
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.FEASIBLE:
        # Output the solution
        print("Crossfigure puzzle solution:")
        for i in range(len(grid)):
            row = []
            for j in range(len(grid[0])):
                if grid[i][j] is None:
                    row.append("X")
                else:
                    row.append(str(solver.Value(cells[(i,j)])))
            print(row)
    else:
        print("No solution found for the Crossfigure puzzle.")
    
crossfigures()
