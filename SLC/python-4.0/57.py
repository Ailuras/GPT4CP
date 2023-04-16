from ortools.sat.python import cp_model

def killer_sudoku(cages):
    model = cp_model.CpModel()

    # Variables
    board = [[model.NewIntVar(1, 9, f'cell_{i}_{j}') for j in range(9)] for i in range(9)]

    # Constraints
    # Rows and columns must contain all numbers 1 to 9
    for i in range(9):
        model.AddAllDifferent(board[i])  # Row constraints
        model.AddAllDifferent([board[j][i] for j in range(9)])  # Column constraints

    # 3x3 subsquares must contain all numbers 1 to 9
    for i in range(0, 9, 3):
        for j in range(0, 9, 3):
            model.AddAllDifferent([board[x][y] for x in range(i, i + 3) for y in range(j, j + 3)])

    # Cage constraints
    for cage in cages:
        total, *cells = cage
        model.Add(sum(board[i][j] for i, j in cells) == total)
        model.AddAllDifferent([board[i][j] for i, j in cells])

    # Solve the model
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Output the solution
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        solution = [[solver.Value(board[i][j]) for j in range(9)] for i in range(9)]
        return solution
    else:
        return None

# Example usage
cages = [
    (3, (0, 0), (0, 1)),
    (15, (0, 2), (0, 3), (1, 0), (1, 1)),
    # Add more cages here
]

solution = killer_sudoku(cages)
if solution is not None:
    print('Solution found:')
    for row in solution:
        print(row)
else:
    print('No solution found')
