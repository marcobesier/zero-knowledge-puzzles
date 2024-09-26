pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Be sure to solve IntSqrt before solving this 
// puzzle. Your goal is to compute the square root
// in the provided function, then constrain the answer
// to be true using your work from the previous puzzle.
// You can use the Bablyonian/Heron's or Newton's
// method to compute the integer square root. Remember,
// this is not the modular square root.


function intSqrtFloor(x) {
    // compute the floor of the
    // integer square root

    // Use binary search instead of Heron's or Newton's method
    if (x == 0) return 0;

    var r = x;
    var l = 0;

    // Continue until r and l are almost equal
    while (r - l > 1) {
        // Compute the midpoint
        var m = (r + l) \ 2;

        // If m^2 <= x, increase l to m
        if (m * m <= x) {
            l = m;
        // If m^2 > x, m is too large to be the floor of the square root.
        // Therefore, decrease r to m.
        } else {
            r = m;
        }
    }
    
    return l;
}

template IntSqrtOut(n) {
    signal input in;
    signal output out;

    out <-- intSqrtFloor(in);
    // constrain out using your
    // work from IntSqrt

    signal b_minus_1_squared;
    signal b_plus_1_squared;

    // Calculate (b - 1)^2
    b_minus_1_squared <== (out - 1) * (out - 1);

    // Calculate (b + 1)^2
    b_plus_1_squared <== (out + 1) * (out + 1);

    // Ensure (b - 1)^2 < a
    component lt1 = LessThan(n);
    lt1.in[0] <== b_minus_1_squared;
    lt1.in[1] <== in;
    lt1.out === 1;

    // Ensure (b + 1)^2 > a
    component gt = GreaterThan(n);
    gt.in[0] <== b_plus_1_squared;
    gt.in[1] <== in;
    gt.out === 1;

    // Ensure (b + 1)^2 (and, therefore, (b - 1)^2) are not overflowing the field
    component lt2 = LessThan(n);
    lt2.in[0] <== b_plus_1_squared;
    // In an n-bit field, the prime p is typically chosen such that 2^(n-1) < p < 2^n.
    // Therefore constraining (b + 1)^2 to be less than 2^(n-1) ensures that the result does not overflow the field.
    lt2.in[1] <== 2**(n-1);
    lt2.out === 1;
}

component main = IntSqrtOut(252);
