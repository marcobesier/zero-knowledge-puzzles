pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template Equality() {
   signal input a[3];
   signal output c;
   // Use intermediary signal assignment, since == and && are not linear or quadratic operations.
   // They are higher-level logical operations that cannot be directly represented as quadratic constraints.
   // Therefore, when trying to directly constrain via c <== a[0]==a[1] && a[1]==a[2], Circom's compiler will complain
   // that non-quadratic constraints are not allowed.  
   signal isEqual <-- a[0]==a[1] && a[1]==a[2];

   c <== isEqual;
}

component main = Equality();