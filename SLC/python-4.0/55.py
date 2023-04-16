from ortools.sat.python import cp_model

def equidistant_frequency_permutation_arrays(v, q, lam, d):
    model = cp_model.CpModel()

    # Variables
    codewords = [[model.NewIntVar(1, q, f'codeword_{i}_symbol_{j}') for j in range(q * lam)] for i in range(v)]

    # Constraints
    # Each symbol occurs exactly lambda times in each codeword
    for codeword in codewords:
        for symbol in range(1, q + 1):
            model.Add(sum([1 for c in codeword if c == symbol]) == lam)

    # All pairs of codewords are Hamming distance d apart
    for i in range(v):
        for j in range(i + 1, v):
            model.Add(sum([codewords[i][k] != codewords[j][k] for k in range(q * lam)]) == d)

    # Solve the model
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Output the solution
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        solution = [[solver.Value(codewords[i][j]) for j in range(q * lam)] for i in range(v)]
        return solution
    else:
        return None

# Example usage
v = 4
q = 3
lam = 2
d = 3
solution = equidistant_frequency_permutation_arrays(v, q, lam, d)
if solution is not None:
    print('Solution found:')
    for codeword in solution:
        print(codeword)
else:
    print('No solution found')
