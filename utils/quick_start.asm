ld x6, 0(x0)
ld x7, 1(x0)

and x5, x6, x7
sd x5, 2(x0)

or x5, x6, x7
sd x5, 3(x0)

add x5, x6, x7
sd x5, 4(x0)

sub x5, x6, x7
sd x5, 5(x0)

beq x6, x7, Label_1
sd x6, 6(x0)
Label_1:

beq x6, x6, Label_2
sd x7, 7(x0) //skipped
Label_2:
sd x7, 8(x0)

blt x6, x7, Label_3
sd x6, 9(x0)
Label_3:

blt x7, x6, Label_4
sd x7, 10(x0) //skipped
Label_4:
sd x7, 11(x0)
