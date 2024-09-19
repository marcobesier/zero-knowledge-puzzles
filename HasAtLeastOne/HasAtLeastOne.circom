pragma circom 2.1.8;

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.

template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;

    signal product[n+1];
    signal isZero;

    // Here, we use that at least one element of a list of integers, say, [x, y, z], is equal to k if the
    // product (x-k) * (y-k) * (z-k) is equal to zero. 
    product[0] <== 1;
    for (var i = 0; i < n; i++) {
        product[i+1] <== product[i] * (in[i] - k);
    }

    // Boolean expressions are not considered quadratic, which is why we need to use the intermediate signal isZero
    isZero <-- product[n] == 0;
    out <== isZero;
}

component main = HasAtLeastOne(4);
