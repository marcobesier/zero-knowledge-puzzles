pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that constrains the 4 input signals to be
// sorted. Sorted means the values are non decreasing starting
// at index 0. The circuit should not have an output.

template IsSorted() {
    signal input in[4];
    
    // Create three LessEqThan components
    component le[3];
    for (var i = 0; i < 3; i++) {
        // Set bit length to 252 (which is typically used for field elements in circom)
        le[i] = LessEqThan(252);
    }

    // Compare adjacent pairs
    for (var i = 0; i < 3; i++) {
        le[i].in[0] <== in[i];
        le[i].in[1] <== in[i+1];
        // Constrain output to be 1 (i.e., true)
        le[i].out === 1;
    }
}

component main = IsSorted();
