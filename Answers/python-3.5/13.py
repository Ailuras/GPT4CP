from ortools.sat.python import cp_model

def progressive_party():
    # Capacity of each boat
    capacity = [10, 10, 8, 8, 6, 5]

    # Crew size of each boat
    crew_size = [6, 5, 4, 4, 3, 2]

    # Number of time periods
    periods = 6

    model = cp_model.CpModel()

    # Variables for the host boats at each time period
    hosts = []
    for i in range(periods):
        host = model.NewIntVar(0, len(capacity)-1, f"host{i}")
        hosts.append(host)

    # Constraints for the guests of each host
    for i in range(len(capacity)):
        for j in range(i+1, len(capacity)):
            if capacity[i] + capacity[j] >= max(crew_size[i], crew_size[j]):
                for k in range(periods):
                    model.Add(hosts[k] != i).OnlyEnforceIf(hosts[k] == j)
                    model.Add(hosts[k] != j).OnlyEnforceIf(hosts[k] == i)

    # Constraints for the crew sizes
    for k in range(periods):
        guests = []
        for i in range(len(capacity)):
            if i != hosts[k]:
                guests.append(crew_size[i])
        for i in range(len(guests)):
            for j in range(i+1, len(guests)):
                model.Add(guests[i] + guests[j] <= capacity[hosts[k]])

    # Constraints for guests to only visit each host once
    for i in range(len(capacity)):
        for j in range(i+1, len(capacity)):
            if capacity[i] + capacity[j] >= max(crew_size[i], crew_size[j]):
                for k in range(periods-1):
                    for l in range(k+1, periods):
                        model.Add((hosts[k] != i) | (hosts[l] != j) | (hosts[k] != hosts[l]))
                        model.Add((hosts[k] != j) | (hosts[l] != i) | (hosts[k] != hosts[l]))

    # Minimize the number of host boats
    model.Minimize(sum([model.NewIntVar(0, 1, f"host_used{i}") for i in range(len(capacity))]))

    # Solve the problem
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.OPTIMAL:
        # Output the solution
        print("Number of host boats:", solver.ObjectiveValue())
        for i in range(periods):
            print(f"Time period {i+1}: Boat {solver.Value(hosts[i])+1} is the host.")
    else:
        print("No solution found for the Progressive Party Problem.")
    
progressive_party()
