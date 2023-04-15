om ortools.sat.python import cp_model

model = cp_model.CpModel()

# Define variables
num_vars = 19
vars_matrix = [[None] * (i + 1) for i in range(num_vars)]
for i in range(num_vars):
    for j in range(i + 1):
        vars_matrix[i][j] = model.NewIntVar(1, 19, f'x{i}_{j}')

# Define constraints
diag1 = [vars_matrix[0][0], vars_matrix[1][0], vars_matrix[2][0], vars_matrix[3][0]]
diag2 = [vars_matrix[0][1], vars_matrix[1][1], vars_matrix[2][1], vars_matrix[3][1], vars_matrix[4][0]]
diag3 = [vars_matrix[0][2], vars_matrix[1][2], vars_matrix[2][2], vars_matrix[3][2], vars_matrix[4][1], vars_matrix[5][0]]
diag4 = [vars_matrix[0][3], vars_matrix[1][3], vars_matrix[2][3], vars_matrix[3][3], vars_matrix[4][2], vars_matrix[5][1]]
diag5 = [vars_matrix[1][4], vars_matrix[2][4], vars_matrix[3][4], vars_matrix[4][3], vars_matrix[5][2]]
diag6 = [vars_matrix[2][5], vars_matrix[3][5], vars_matrix[4][4], vars_matrix[5][3]]

model.Add(sum(diag1) == 38)
model.Add(sum(diag2) == 38)
model.Add(sum(diag3) == 38)
model.Add(sum(diag4) == 38)
model.Add(sum(diag5) == 38)
model.Add(sum(diag6) == 38)

for i in range(num_vars):
    if i < 4:
        model.Add(sum(vars_matrix[i]) == 38)
    elif i < 9:
        model.Add(sum([row[i - 4] for row in vars_matrix]) == 38)
    elif i < 14:
        model.Add(sum([vars_matrix[j][i - j - 5] for j in range(i - 8, i + 1)]) == 38)
    else:
        model.Add(sum([vars_matrix[j][i - j - 5] for j in range(i - 8, 14)]) == 38)

for i in range(num_vars):
    for j in range(i + 1):
        for k in range(j + 1, i + 1):
            model.Add(vars_matrix[i][j] != vars_matrix[i][k])

# Define solution strategy
solver = cp_model.CpSolver()
solution_printer = cp_model.VarArrayAndObjectiveSolutionPrinter(vars_matrix)
status = solver.SolveWithSolutionCallback(model, solution_printer)

# Print output
if status == cp_model.OPTIMAL:
    for i in range(num_vars):
        for j in range(i + 1):
            print(f'{solver.Value(vars_matrix[i][j])} ', end='')
        print(