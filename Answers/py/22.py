from ortools.sat.python import cp_model

def bus_driver_scheduling(shifts, tasks):
    model = cp_model.CpModel()
    
    # Decision variables
    shift_vars = [model.NewBoolVar(f'shift_{s}') for s in shifts]
    
    # Constraints
    for task in tasks:
        model.Add(sum(shift_vars[s] for s in shifts if task in s) == 1)
    
    # Objective
    model.Minimize(sum(shift_vars))
    
    # Solve
    solver = cp_model.CpSolver()
    status = solver.Solve(model)
    
    # Results
    if status == cp_model.OPTIMAL:
        selected_shifts = [shifts[s] for s in range(len(shifts)) if solver.Value(shift_vars[s])]
        return selected_shifts
    else:
        return Non