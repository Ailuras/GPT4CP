
%Declare Variables
var 0..9: A1; var 0..9: A3; var 0..9: A4; var 0..9: A6; 
var 0..9: A7; var 0..9: A9; var 0..9: B2; var 0..9: B3;
var 0..9: B6; var 0..9: B7; var 0..9: B8; var 0..9: C2;
var 0..9: C3; var 0..9: C5; var 0..9: C6; var 0..9: C7;
var 0..9: C9; var 0..9: D1; var 0..9: D2; var 0..9: D6;
var 0..9: D7; var 0..9: D9; var 0..9: E1; var 0..9: E3;
var 0..9: E4; var 0..9: E5; var 0..9: E6; var 0..9: E7;
var 0..9: F1; var 0..9: F3; var 0..9: F4; var 0..9: F6;
var 0..9: F7; var 0..9: F9; var 0..9: G2; var 0..9: G3;
var 0..9: G5; var 0..9: G6; var 0..9: G7; var 0..9: G9;
var 0..9: H3; var 0..9: H4; var 0..9: H6; var 0..9: H7;
var 0..9: H8; var 0..9: I1; var 0..9: I3; var 0..9: I6;
var 0..9: I9;

%Define Constraints
constraint alldifferent([A1, A3, A4, A6, A7, A9]);
constraint alldifferent([B2, B3, B6, B7, B8]);
constraint alldifferent([C2, C3, C5, C6, C7, C9]);
constraint alldifferent([D1, D2, D6, D7, D9]);
constraint alldifferent([E1, E3, E4, E5, E6, E7]);
constraint alldifferent([F1, F3, F4, F6, F7, F9]);
constraint alldifferent([G2, G3, G5, G6, G7, G9]);
constraint alldifferent([H3, H4, H6, H7, H8]);
constraint alldifferent([I1, I3, I6, I9]);

constraint A1*1000 + B2*100 + C2*10 + D1 == A3*1000 + B3*100 + C3*10 + D2 +27;
constraint D2*1000 + C3*100 + B3*10 + A3 == D6*1000 + E6*100 + F6*10 + G6 + 71;
constraint F7*100 + O*10 + U == 48;
constraint G2*100000 + H3*10000 + G5*1000 + H6*100 + G7*10 + H8 == 500000;
constraint H3*1000 + H4*100 + H6*10 + H7 == 7584;

% Output
output ["A1 = \(A1)\n", "A3 = \(A3)\n", "A4 = \(A4)\n", "A6 = \(A6)\n", "A7 = \(A7)\n", "A9 = \(A9)\n",
        "B2 = \(B2)\n", "B3 = \(B3)\n", "B6 = \(B6)\n", "B7 = \(B7)\n", "B8 = \(B8)\n",
        "C2 = \(C2)\n", "C3 = \(C3)\n", "C5 = \(C5)\n", "C6 = \(C6)\n", "C7 = \(C7)\n", "C9 = \(C9)\n",
        "D1 = \(D1)\n", "D2 = \(D2)\n", "D6 = \(D6)\n", "D7 = \(D7)\n", "D9 = \(D9)\n",
        "E1 = \(E1)\n", "E3 = \(E3)\n", "E4 = \(E4)\n", "E5 = \(E5)\n", "E6 = \(E6)\n", "E7 = \(E7)\n", 
        "F1 = \(F1)\n", "F3 = \(F3)\n", "F4 = \(F4)\n", "F6 = \(F6)\n", "F7 = \(F7)\n", "F9 = \(F9)\n",
        "G2 = \(G2)\n", "G3 = \(G3)\n", "G5 = \(G5)\n", "G6 = \(G6)\n", "G7 = \(G7)\n", "G9 = \(G9)\n",
        "H3 = \(H3)\n", "H4 = \(H4)\n", "H6 = \(H6)\n", "H7 = \(H7)\n", "H8 = \(H8)\n",
        "I1 = \(I1)\n", "I3 = \(I3)\n", "I6 = \(I6)\n", "I9 = \(I9)\n"]
