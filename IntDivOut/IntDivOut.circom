pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Use the same constraints from IntDiv, but this
// time assign the quotient in `out`. You still need
// to apply the same constraints as IntDiv

template IntDivOut(n) {
    signal input numerator;
    signal input denominator;
    signal output out;

    signal remainder;
    signal quotient;

    quotient <-- numerator \ denominator;
    remainder <-- numerator % denominator;

    numerator === denominator * quotient + remainder;

    // Ensure remainder is less than denominator
    component lt = LessThan(n);
    lt.in[0] <== remainder;
    lt.in[1] <== denominator;
    lt.out === 1;

    out <== quotient;
}

component main = IntDivOut(252);
