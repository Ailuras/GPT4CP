from ortools.sat.python import cp_model

def extremal_graphs_with_small_girth(m, k):
    model = cp_model.CpModel()

    # Variables
    edge_vars = {}
    for u in range(m):
        for v in range(u + 1, m):
            edge_vars[u, v] = model.NewBoolVar(f'edge_{u}_{v}')

    # Constraints
    # No cycles of length k or less
    for cycle_size in range(3, k + 1):
        for start_vertex in range(m):
            for cycle_shift in range(1, (m - start_vertex) // (cycle_size - 1) + 1):
                cycle_vertices = [start_vertex + i * cycle_shift for i in range(cycle_size)]
                if cycle_vertices[-1] < m:
                    model.Add(sum(edge_vars[u, v] for u, v in zip(cycle_vertices, cycle_vertices[1:] + [cycle_vertices[0]])) <= cycle_size - 1)

    # Objective: maximize the number of edges
    model.Maximize(sum(edge_vars.values()))

    # Solve the model
    solver = cp_model.CpSolver()
    solver.Solve(model)

    # Output the solution
    fk_m = solver.ObjectiveValue()
    # The number of non-isomorphic extremal graphs with m vertices and fk(m) edges, Fk(m), is not supported by CP-SAT solver.
    # This value generally requires more complex graph theoretical approaches or specialized software for graph enumeration.
    return fk_m

# Example usage
m = 6
k = 3
fk_m = extremal_graphs_with_small_girth(m, k)
print(f'fk({m}) = {fk_m}')
