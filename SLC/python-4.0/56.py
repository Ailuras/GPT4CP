from ortools.sat.python import cp_model

def synchronous_optical_networking(n, r, demand, capacity_nodes):
    model = cp_model.CpModel()

    # Variables
    ring_vars = {}
    adm_vars = {}
    for node in range(n):
        adm_vars[node] = model.NewBoolVar(f'adm_{node}')
        for ring in range(r):
            ring_vars[node, ring] = model.NewBoolVar(f'ring_{ring}_node_{node}')

    # Constraints
    # Each node in demand must be on at least one ring
    for node1, node2 in demand:
        model.Add(sum(ring_vars[node1, ring] for ring in range(r)) >= 1)
        model.Add(sum(ring_vars[node2, ring] for ring in range(r)) >= 1)

    # Each ring can have at most capacity_nodes
    for ring in range(r):
        model.Add(sum(ring_vars[node, ring] for node in range(n)) <= capacity_nodes[ring])

    # ADM constraint: if a node is on a ring, it has an ADM
    for node in range(n):
        for ring in range(r):
            model.Add(ring_vars[node, ring] <= adm_vars[node])

    # Objective: minimize the number of ADMs
    model.Minimize(sum(adm_vars.values()))

    # Solve the model
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Output the solution
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        solution = {node: [solver.Value(ring_vars[node, ring]) for ring in range(r)] for node in range(n)}
        total_adms = sum(solver.Value(adm_vars[node]) for node in range(n))
        return solution, total_adms
    else:
        return None

# Example usage
n = 6
r = 2
demand = [(0, 1), (2, 3), (4, 5)]
capacity_nodes = [3, 3]
solution, total_adms = synchronous_optical_networking(n, r, demand, capacity_nodes)
if solution is not None:
    print('Solution found:')
    for node, rings in solution.items():
        print(f'Node {node}:', rings)
    print('Total ADMs:', total_adms)
else:
    print('No solution found')
