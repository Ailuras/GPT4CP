
include "globals.mzn";

int: n;
set of int: Balls = 1..n;
set of int: Boxes = 1..3;

array[Balls] of var Boxes: box;

constraint forall(x,y,z in Balls where x+y=z)(
    box[x] != box[y] \/ box[x] != box[z] \/ box[y] != box[z]
);

solve satisfy;
