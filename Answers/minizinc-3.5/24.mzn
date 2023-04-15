minizinc
int: n;
array[1..n] of var 1..n: seq_1;
array[1..n] of var 1..n: seq_2;

constraint alldifferent(seq_1 ++ seq_2);
constraint forall(i in 1..n where i <= n-i+1)(
    let{
        var int: pos1 = index(seq_1, i);
        var int: pos2 = index(seq_2, i);
        var int: diff;
    } in
        if pos1 > 0 /\ pos2 > 0 then
            diff = abs(pos1 - pos2) - 1;
        else if pos1 > 0 then
            diff = abs(n - pos1 - i) - 1;
        else if pos2 > 0 then
            diff = abs(n - pos2 - i) - 1;
        else % i does not occur in seq_1 and seq_2
            diff = n-i;
        endif

        where
            diff >= 0,
            pos1 > 0 -> seq_1[pos1 + diff + 1] = i,
            pos2 > 0 -> seq_2[pos2 + diff + 1] = i
    )
)
