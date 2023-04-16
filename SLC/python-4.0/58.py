from ortools.sat.python import cp_model

def discrete_lot_sizing(n_items, n_periods, demands, changeover_costs, storage_costs):
    model = cp_model.CpModel()

    # Variables
    production = [[model.NewBoolVar(f'production_{i}_{t}') for t in range(n_periods)] for i in range(n_items)]
    changeover = [[model.NewBoolVar(f'changeover_{i}_{j}_{t}') for j in range(n_items)] for i in range(n_items) for t in range(1, n_periods)]

    # Constraints
    # Production capacity limited to one per period
    for t in range(n_periods):
        model.Add(sum(production[i][t] for i in range(n_items)) <= 1)

    # Satisfy demands before demand time
    for i in range(n_items):
        model.Add(sum(production[i][t] for t in range(demands[i][0])) >= 1)

    # Changeover constraints
    for t in range(1, n_periods):
        for i in range(n_items):
            for j in range(n_items):
                if i != j:
                    model.Add(production[i][t] + production[j][t - 1] - 1 <= changeover[i][j][t])

    # Objective: minimize sum of stocking costs and changeover costs
    total_stocking_costs = sum(production[i][t] * storage_costs[i] * (t - demands[i][0]) for i in range(n_items) for t in range(demands[i][0], n_periods))
    total_changeover_costs = sum(changeover[i][j][t] * changeover_costs[i][j] for i in range(n_items) for j in range(n_items) for t in range(1, n_periods))
    model.Minimize(total_stocking_costs + total_changeover_costs)

    # Solve the model
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Output the solution
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        solution = [[solver.Value(production[i][t]) for t in range(n_periods)] for i in range(n_items)]
        return solution
    else:
        return None

# Example usage
n_items = 3
n_periods = 5
demands = [(2, 2), (3, 1), (1, 1)]
changeover_costs = [
    [0, 10, 15],
    [10, 0, 20],
    [15, 20, 0],
]
storage_costs = [2, 3, 4]

solution = discrete_lot_sizing(n_items, n_periods, demands, changeover_costs, storage_costs)
if solution is not None:
    print('Solution found:')
    for i, item in enumerate(solution):
        print(f'Item {i + 1}:', item)
else:
    print('No solution found')
