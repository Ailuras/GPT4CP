
include "globals.mzn";

% Variables
array[1..19] of var 1..19: nums;

% Constraints
constraint all_different(nums);
constraint nums[1] + nums[2] + nums[3] == 38;
constraint nums[1] + nums[4] + nums[8] == 38;
constraint nums[2] + nums[5] + nums[9] + nums[14] == 38;
constraint nums[3] + nums[6] + nums[10] + nums[15] + nums[19] == 38;
constraint nums[7] + nums[11] + nums[16] + nums[17] == 38;
constraint nums[12] + nums[13] + nums[18] == 38;

% Solve
solve satisfy;

% Output
output [show(nums)];
