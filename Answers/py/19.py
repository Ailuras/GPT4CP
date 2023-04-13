python
from ortools.sat.python import cp_model

def magic_square(n):
    model = cp_model.CpModel()
    numbers = [model.NewIntVar(1, n**2, f"x_{i}") for i in range(n**2)]
    sum_value = n*(n**2 + 1) // 2
    rows = [numbers[i:i+n] for i in range(0, n**2, n)]
    cols = [[numbers[j*n+i] for j in range(n)] for i in range(n)]
    diag1 = [numbers[i*(n+1)] for i in range(n)]
    diag2 = [numbers[(i+1)*(n-1)] for i in range(n-1,-1,-1)]
    
    # AllDifferent
    model.AddAllDifferent(numbers)
    
    # Sum of rows
    for row in rows:
        model.Add(sum(row) == sum_value)
    
    # Sum of cols
    for col in cols:
        model.Add(sum(col) == sum_value)
    
    # Sum of main diagonal
    model.Add(sum(diag1) == sum_value)
    
    # Sum of secondary diagonal
    model.Add(sum(diag2) == sum_value)
    
    return model, numbers
