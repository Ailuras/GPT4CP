from ortools.linear_solver import pywraplp

def number_partitioning(N):
    solver = pywraplp.Solver.CreateSolver('GLOP')

    # Variables
    x = []
    for i in range(N):
        x.append(solver.BoolVar(f'x_{i + 1}'))

    # Constraints
    sum_x = solver.Sum(x[i] for i in range(N))
    sum_x_squared = solver.Sum((i + 1) * (i + 1) * x[i] for i in range(N))

    solver.Add(sum_x == N // 2)
    solver.Add(sum_x_squared == N * (N + 1) * (2 * N + 1) // 8)

    # Objective function
    solver.Minimize(sum_x)

    status = solver.Solve()

    if status == pywraplp.Solver.OPTIMAL:
        A = [i + 1 for i in range(N) if x[i].solution_value() == 1]
        B = [i + 1 for i in range(N) if x[i].solution_value() == 0]
        return A, B
    else:
        return None, None

N = 6
A, B = number_partitioning(N)
print(A, B)
