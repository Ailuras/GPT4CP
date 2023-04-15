from ortools.sat.python import cp_model

def magic_hexagon():
    model = cp_model.CpModel()

    # Variables for the numbers in the hexagon
    numbers = {}
    for i in range(5):
        for j in range(i+1):
            numbers[(i,j)] = model.NewIntVar(1, 19, f"({i},{j})")

    # Constraints for the diagonals
    model.Add(numbers[(0,0)] + numbers[(0,1)] + numbers[(0,2)] == 38)
    model.Add(numbers[(0,0)] + numbers[(1,0)] + numbers[(2,0)] + numbers[(3,0)] == 38)
    model.Add(numbers[(0,2)] + numbers[(1,3)] + numbers[(2,4)] + numbers[(3,3)] == 38)
    model.Add(numbers[(3,0)] + numbers[(3,1)] + numbers[(3,2)] + numbers[(3,3)] == 38)
    model.Add(numbers[(0,2)] + numbers[(1,2)] + numbers[(2,2)] + numbers[(3,2)] == 38)
    model.Add(numbers[(1,0)] + numbers[(1,1)] + numbers[(1,2)] + numbers[(1,3)] + numbers[(0,2)] == 38)
    model.Add(numbers[(2,0)] + numbers[(2,1)] + numbers[(2,2)] + numbers[(2,3)] + numbers[(1,3)] == 38)
    model.Add(numbers[(3,0)] + numbers[(2,1)] + numbers[(1,2)] + numbers[(0,2)] == 38)
    model.Add(numbers[(3,1)] + numbers[(2,2)] + numbers[(1,3)] + numbers[(0,2)] == 38)
    model.Add(numbers[(3,3)] + numbers[(2,3)] + numbers[(1,3)] + numbers[(0,2)] == 38)
    model.Add(numbers[(3,0)] + numbers[(2,0)] + numbers[(1,0)] + numbers[(0,0)] == 38)
    model.Add(numbers[(3,3)] + numbers[(2,4)] + numbers[(1,2)] + numbers[(0,1)] == 38)
    model.Add(numbers[(2,0)] + numbers[(2,1)] + numbers[(1,2)] + numbers[(0,3)] == 38)
    model.Add(numbers[(1,0)] + numbers[(2,1)] + numbers[(3,2)] + numbers[(4,2)] == 38)
    model.Add(numbers[(0,0)] + numbers[(1,1)] + numbers[(2,2)] + numbers[(3,3)] + numbers[(4,4)] == 38)
    model.Add(numbers[(0,1)] + numbers[(1,1)] + numbers[(2,1)] + numbers[(3,1)] + numbers[(4,1)] == 38)
    model.Add(numbers[(0,2)] + numbers[(1,3)] + numbers[(2,4)] + numbers[(3,3)] + numbers[(4,2)] == 38)
    model.Add(numbers[(1,0)] + numbers[(2,0)] + numbers[(3,0)] + numbers[(4,0)] == 38)
    model.Add(numbers[(0,3)] + numbers[(1,3)] + numbers[(2,3)] + numbers[(3,3)] + numbers[(4,3)]== 38)
    model.Add(numbers[(0,2)] + numbers[(1,2)] + numbers[(2,2)] + numbers[(3,2)] + numbers[(4,2)] == 38)
    model.Add(numbers[(1,1)] + numbers[(2,2)] + numbers[(3,3)] + numbers[(4,4)] == 38)
    model.Add(numbers[(3,3)] + numbers[(2,2)] + numbers[(1,1)] + numbers[(0,0)] == 38)
    model.Add(numbers[(1,0)] + numbers[(2,1)] + numbers[(3,2)] + numbers[(2,3)] + numbers[(1,4)] == 38)
    model.Add(numbers[(3,0)] + numbers[(3,1)] + numbers[(3,2)] + numbers[(3,3)] + numbers[(3,4)] == 38)
    model.Add(numbers[(4,0)] + numbers[(3,1)] + numbers[(2,2)] + numbers[(1,3)] + numbers[(0,4)] == 38)
    model.Add(numbers[(4,1)] + numbers[(3,2)] + numbers[(2,3)] + numbers[(1,4)] == 38)
    model.Add(numbers[(0,1)] + numbers[(1,2)] + numbers[(2,3)] + numbers[(3,4)] == 38)
    model.Add(numbers[(0,0)] + numbers[(1,0)] + numbers[(2,0)] + numbers[(3,0)] + numbers[(4,0)] == 38)
    model.Add(numbers[(0,1)] + numbers[(1,2)] + numbers[(2,2)] + numbers[(3,2)] + numbers[(4,1)] == 38)
    model.Add(numbers[(0,2)] + numbers[(1,3)] + numbers[(2,3)] + numbers[(3,3)] + numbers[(4,2)] == 38)
    model.Add(numbers[(0,3)] + numbers[(1,3)] + numbers[(2,3)] + numbers[(3,3)] + numbers[(4,3)] == 38)
    model.Add(numbers[(0,4)] + numbers[(1,4)] + numbers[(2,3)] + numbers[(3,2)] + numbers[(4,1)] == 38)
    model.Add(numbers[(4,4)] + numbers[(3,3)] + numbers[(2,2)] + numbers[(1,1)] + numbers[(0,0)] == 38)
    model.Add(numbers[(4,3)] + numbers[(3,3)] + numbers[(2,3)] + numbers[(1,3)] + numbers[(0,3)] == 38)
    model.Add(numbers[(4,2)] + numbers[(3,3)] + numbers[(2,4)] + numbers[(1,3)] + numbers[(0,2)] == 38)
    model.Add(numbers[(4,1)] + numbers[(3,2)] + numbers[(2,2)] + numbers[(1,2)] + numbers[(0,1)] == 38)
    model.Add(numbers[(4,0)] + numbers[(3,1)] + numbers[(2,1)] + numbers[(1,1)] + numbers[(0,1)] == 38)
    model.Add(numbers[(4,0)] + numbers[(3,1)] + numbers[(2,2)] + numbers[(1,3)] + numbers[(0,4)] == 38)
    # Constraints for the numbers to be distinct
    for i, j in numbers:
        for k, l in numbers:
            if i < k or (i == k and j < l):
                model.Add(numbers[(i,j)] != numbers[(k,l)])

    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.OPTIMAL:
        hexagon = [[0]*3 for _ in range(5)]
        for i in range(5):
            for j in range(i+1):
                hexagon[i][j] = solver.Value(numbers[(i,j)])
        return hexagon

print(magic_hexagon())