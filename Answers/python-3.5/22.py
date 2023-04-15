from ortools.sat.python import cp_model

def bus_driver_scheduling(tasks, shifts):
    model = cp_model.CpModel()

    # Variables for the selected shifts
    selected_shifts = [model.NewBoolVar(f"shift{i}") for i in range(len(shifts))]

    # Constraints for each task to be covered exactly once
    for task in tasks:
        model.Add(sum([selected_shifts[i] for i in range(len(shifts)) if task in shifts[i]]) == 1)

    # Minimize the number of selected shifts
    model.Minimize(sum(selected_shifts))

    # Solve the problem
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.OPTIMAL:
        # Output the solution
        print("Selected shifts:")
        for i in range(len(shifts)):
            if solver.Value(selected_shifts[i]):
                print(shifts[i])
    else:
        print("No solution found for the Bus Driver Scheduling problem.")
    
tasks = [1, 2, 3, 4, 5, 6, 7, 8]
shifts = [[1, 2, 3, 4], [5, 6, 7, 8], [1, 2, 5, 6], [3, 4, 7, 8], [1, 3, 5, 7], [2, 4, 6, 8]]
bus_driver_scheduling(tasks, shifts)
