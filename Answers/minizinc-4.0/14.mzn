
% Solitaire Battleships Problem

int: ROWS = 10;
int: COLS = 10;

% Ship Sizes
int: BATTLESHIP_SIZE = 4;
int: CRUISER_SIZE = 3;
int: DESTROYER_SIZE = 2;
int: SUBMARINE_SIZE = 1;

% Number of each ship type
int: NUM_BATTLESHIPS = 1;
int: NUM_CRUISERS = 2;
int: NUM_DESTROYERS = 3;
int: NUM_SUBMARINES = 4;

%----------Decision Variables-------------------

% Ship coordinates
% (i,j) represents the top/left-most point of the ship
% If the ship is horizontal, it occupies coordinates (i, j+j') for 
% j' in 0..size-1
% If the ship is vertical, it occupies coordinates (i+i', j) for 
% i' in 0..size-1
% If the grid is not occupied by any ship, the coordinates are (-1, -1)
array[1..NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+NUM_SUBMARINES,
      1..2] of var -1..ROWS: ship_coords;

% Grids occupied by each ship
array[1..NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+NUM_SUBMARINES,
      1..BATTLESHIP_SIZE+CRUISER_SIZE+DESTROYER_SIZE+SUBMARINE_SIZE]
      of var 0..1: ship_grids; 

%-------------Model------------------------

%No two ships can be adjacent, even diagonally.
constraint forall (i,j in 1..NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS,
                    k,l in 1..NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+NUM_SUBMARINES
                    where i != k) (
               not((abs(ship_coords[i,1] - ship_coords[k,1]) <= 1 /\
                abs(ship_coords[i,2] - ship_coords[k,2]) <= 1) /\
            ship_grids[i,1] + ship_grids[k,1] >= 1));

% Each ship must occupy the correct number of grids
constraint forall (i in 1..NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+NUM_SUBMARINES) (
                (sum(ship_grids[i,1..BATTLESHIP_SIZE]) = BATTLESHIP_SIZE /\
                 sum(ship_grids[i,BATTLESHIP_SIZE+1..BATTLESHIP_SIZE+CRUISER_SIZE]) = CRUISER_SIZE*2 /\
                 sum(ship_grids[i,BATTLESHIP_SIZE+CRUISER_SIZE+1..
                                  BATTLESHIP_SIZE+CRUISER_SIZE+DESTROYER_SIZE]) = DESTROYER_SIZE*3 /\
                 sum(ship_grids[i,BATTLESHIP_SIZE+CRUISER_SIZE+DESTROYER_SIZE+1..
                                  BATTLESHIP_SIZE+CRUISER_SIZE+DESTROYER_SIZE+SUBMARINE_SIZE]) = SUBMARINE_SIZE*4) /\
                forall (j in 1..BATTLESHIP_SIZE+CRUISER_SIZE+DESTROYER_SIZE+SUBMARINE_SIZE) 
                    (ship_grids[i,j] = (ship_coords[i,1] ~= -1 /\
                                        ship_coords[i,2] ~= -1 /\
                                        (if j <= BATTLESHIP_SIZE then 
                                            (ship_coords[i,1], ship_coords[i,2]+j-1)
                                          else if j <= BATTLESHIP_SIZE+CRUISER_SIZE then
                                            (ship_coords[i,1]+j-BATTLESHIP_SIZE-1, ship_coords[i,2])
                                          else if j <= BATTLESHIP_SIZE+CRUISER_SIZE+DESTROYER_SIZE then
                                            (ship_coords[i,1]+j-BATTLESHIP_SIZE-CRUISER_SIZE-1, ship_coords[i,2])
                                          else
                                            (ship_coords[i,1], ship_coords[i,2]))) ));

% Prohibited locations
% If a grid is prohibited, it cannot be occupied by any ship
constraint forall (i in 1..ROWS,j in 1..COLS where prohibited(i,j)>0) (
            forall (k in 1..NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+NUM_SUBMARINES) (
                    not(ship_coords[k,1] = i /\ 
                        ship_coords[k,2] = j /\
                        sum(ship_grids[k,:]) > 0)));

% Each row and column must contain the specified number of grids
constraint forall (i in 1..ROWS) (row_occupied(i) = row_counts[i]);
constraint forall (j in 1..COLS) (col_occupied(j) = col_counts[j]);

% Submarines must occupy the specified grids
constraint forall ((i,j) in SUBMARINES) (ship_coords[NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+i,1] = i /\
                                        ship_coords[NUM_BATTLESHIPS+NUM_CRUISERS+NUM_DESTROYERS+i,2] = j);

% Battleship head and tail coordinates are specified
constraint ship_coords[1,1] = BATTLESHIP_ROW1 /\
           ship_coords[1,2] = BATTLESHIP_COL1 /\
           ship_coords[1,1]+BATTLESHIP_SIZE-1 = BATTLESHIP_ROW2 /\
           ship_coords[1,2] = BATTLESHIP_COL2

% The optimization function
% minimize some metric (e.g. number of occupied grids)

