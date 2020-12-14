// Load n-1 into x28 and x29 will be the counter i.
ld x28, 12(x0)
ld x5, 1(x0)
sub x28, x28, x5

OuterLoop:
// Load n-i-1 into x30 and x31 will be the counter j.
ld x30, 12(x0)
sub x30, x30, x29
ld x5, 1(x0)
sub x30, x30, x5
add x31, x0, x0

InnerLoop:
// Compare and swap arr[j] and arr[j+1].
ld x5, 13(x31)
ld x6, 14(x31)
blt x5, x6, SwapSkipped
add x7, x5, x0
add x5, x6, x0
add x6, x7, x0
sd x5, 13(x31)
sd x6, 14(x31)
SwapSkipped:

// Compute j++.
ld x5, 1(x0)
add x31, x31, x5
blt x31, x30, InnerLoop

// Compute i++.
ld x5, 1(x0)
add x29, x29, x5
blt x29, x28, OuterLoop
