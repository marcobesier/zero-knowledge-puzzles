pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that is satisfied if
// in[0] is the floor of the integer
// sqrt of in[1]. For example:
// 
// int[2, 5] accept
// int[2, 5] accept
// int[2, 9] reject
// int[3, 9] accept
//
// If b is the integer square root of a, then
// the following must be true:
//
// (b - 1)(b - 1) < a
// (b + 1)(b + 1) > a
// 
// be careful when verifying that you 
// handle the corner case of overflowing the 
// finite field. You should validate integer
// square roots, not modular square roots

template IntSqrt(n) {
    signal input in[2];
    signal b_minus_1_squared;
    signal b_plus_1_squared;

    // Calculate (b - 1)^2
    b_minus_1_squared <== (in[0] - 1) * (in[0] - 1);

    // Calculate (b + 1)^2
    b_plus_1_squared <== (in[0] + 1) * (in[0] + 1);

    // Ensure (b - 1)^2 < a
    component lt1 = LessThan(n);
    lt1.in[0] <== b_minus_1_squared;
    lt1.in[1] <== in[1];
    lt1.out === 1;

    // Ensure (b + 1)^2 > a
    component gt = GreaterThan(n);
    gt.in[0] <== b_plus_1_squared;
    gt.in[1] <== in[1];
    gt.out === 1;

    // Ensure (b + 1)^2 (and, therefore, (b - 1)^2) are not overflowing the field
    component lt2 = LessThan(n);
    lt2.in[0] <== b_plus_1_squared;
    // In an n-bit field, the prime p is typically chosen such that 2^(n-1) < p < 2^n.
    // Therefore constraining (b + 1)^2 to be less than 2^(n-1) ensures that the result does not overflow the field.
    lt2.in[1] <== 2**(n-1);
    lt2.out === 1;
}

component main = IntSqrt(252);
