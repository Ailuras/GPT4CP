from ortools.constraint_solver import pywrapcp


def main():
    solver = pywrapcp.Solver("Traffic Lights")

    colors = ["r", "ry", "g", "y"]

    V = [solver.IntVar(0, 3, f"V_{i}") for i in range(1, 5)]
    P = [solver.IntVar(0, 1, f"P_{i}") for i in range(1, 5)]

    for i in range(4):
        j = (1 + i) % 4
        solver.Add(solver.AllDifferent([V[i], P[i], V[j], P[j]]))
        solver.Add(solver.AllowedAssignments([V[i], P[i], V[j], P[j]], [[0, 0, 2, 2], [1, 0, 3, 1], [2, 2, 0, 0], [3, 0, 1, 0]]))

    db = solver.Phase(V + P, solver.CHOOSE_FIRST_UNBOUND, solver.ASSIGN_MIN_VALUE)

    solver.NewSearch(db)

    if solver.NextSolution():
        print(f"V1={colors[V[0].Value()]}, V2={colors[V[1].Value()]}, V3={colors[V[2].Value()]}, V4={colors[V[3].Value()]}, "
              f"P1={colors[P[0].Value()]}, P2={colors[P[1].Value()]}, P3={colors[P[2].Value()]}, P4={colors[P[3].Value()]}")

    solver.EndSearch()


if __name__ == "__main__":
    main()