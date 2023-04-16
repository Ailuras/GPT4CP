from ortools.sat.python import cp_model

def graceful_graph(edges, q):
    model = cp_model.CpModel()

    # Variables
    node_labels = [model.NewIntVar(0, q, f'node_{i}') for i in range(len(edges) + 1)]
    edge_labels = [model.NewIntVar(1, q, f'edge_{i}') for i in range(q)]

    # Constraints
    # Node labels must be unique
    model.AddAllDifferent(node_labels)

    # Edge labels must be unique
    model.AddAllDifferent(edge_labels)

    # Edge labels must be the absolute difference of their node labels
    for i, (u, v) in enumerate(edges):
        model.AddAbsEquality(edge_labels[i], cp_model.LinearExpr.Minus(node_labels[u], node_labels[v]))

    # Solve the model
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Output the solution
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        node_labels_solution = [solver.Value(node_labels[i]) for i in range(len(edges) + 1)]
        edge_labels_solution = [solver.Value(edge_labels[i]) for i in range(q)]
        return node_labels_solution, edge_labels_solution
    else:
        return None

# Example usage
edges = [(0, 1), (1, 2), (2, 3), (0, 3), (0, 4)]
q = len(edges)
result = graceful_graph(edges, q)
if result is not None:
    node_labels_solution, edge_labels_solution = result
    print('Node labels:', node_labels_solution)
    print('Edge labels:', edge_labels_solution)
else:
    print('No graceful labeling found')
