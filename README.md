# RISC-V Processor in SystemVerilog

A simple RISC-V processor for learning, written in SystemVerilog.

## Overview

The main structure of `risc-v-processor-sv` follows the Chapter 4 in [Computer Organization and Design](https://www.amazon.com/Computer-Organization-Design-RISC-V-Architecture/dp/0128122757) by David A. Patterson and John L. Hennessy as the figure below shows. Notice we add an extra set of pipeline registers WB in the writeback stage to avoid using special (positive and negtive edge triggering) register file (more on the last section of this document).

![Pipelined Control Overview](pipelined_control_overview.jpg)

`risc-v-processor-sv` currently supports 9 instructions as the table below shows. The instruction memory can contain at most 32 instructions. The register file consists of 32 one-byte-long general-purpose registers named from x0 to x31. The data memory has 32 one-byte-long cells whose contents are loaded from `utils/data.mem` at initialization time.

| Instruction | Example | Meaning |
| --- | --- | --- |
| `nop` | nop | No action |
| `ld` | ld x5, 40(x6) | x5 = Memory[x6 + 40] |
| `sd` | sd x5, 40(x6) | Memory[x6 + 40] = x5 |
| `and` | and x5, x6, x7 | x5 = x6 & x7 |
| `or` | or x5, x6, x7 | x5 = x6 \| x7 |
| `add` | add x5, x6, x7 | x5 = x6 + x7 |
| `sub` | sub x5, x6, x7 | x5 = x6 - x7 |
| `beq` | beq x5, x6, 100 | if (x5 == x6) go to PC+100 |
| `blt` | blt x5, x6, 100 | if (x5 < x6) go to PC+100 |

## Setup

`risc-v-processor-sv` is developed with ModelSim (INTEL FPGA STARTER EDITION 2020.1). The assembler included in the repository is pre-compiled for Windows. If you are using other platforms, please go to its own [repository](https://github.com/pastchick3/risc-v-assembler) and compile the source code with a standard Rust toolchain.

## Quick Start

First, let's check out `utils/data.mem`, whose contents are shown below. Because `risc-v-processor-sv` does not support any instructions that involve immediate operands, we manually initialize the first and the second memory cell to be 3 and 1 respectively. After `data.mem` is loaded into the data memory of the processor, we can use `ld` instructions to load them into registers and do other computations.

``` MEM
00000011 00000001 00000000 00000000
<truncated>
```

The example program we will run is shown below and stored in `utils/quick_start.asm`. As the program says, we first load 3 and 1 into register x6 and x7 respectively. Then we perform `and`, `or`, `add`, and `sub` on these two registers and save results back to memory cell 2 to cell 5. Finally, we test the two branch instructions by conditionally writing x6 back to cell 6/9 and x7 back to memory cell 8/11.

``` ASM
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
```

The next step is to compile the assembly file into an object file that can be loaded into the instruction memory of the processor. Here we will use `risc-v-assembler` shipped with the processor. The command below will compile `quick_start.asm` into a 32-instruction-long `program.obj` with empty slots padded by `nop` to avoid unintialized memory.

``` PowerShell
> .\utils\risc-v-assembler.exe .\utils\quick_start.asm -o .\utils\program.obj --padding 32
```

Finally, we can compile all the source files and run the simulation on `driver.sv`. You should get the following memory data (exported by ModelSim).

``` MEM
// memory data file (do not edit the following line - required for mem load use)
// instance=/Driver/processor/data_mem/mem
// format=bin addressradix=h dataradix=b version=1.0 wordsperline=4
 @0 00000011 00000001 00000001 00000011
 @4 00000100 00000010 00000011 00000000
 @8 00000001 00000011 00000000 00000001
 <truncated>
```

## The Bubble Sort and Stall Cycles

Now let's test a more complex example and try to compute the number of stall cycles. Still start with the memory file, the memory cell 12 contains the length of the array that we are going to sort and cell 13-19 contains the elements of the array as below.

``` Mem
00000011 00000001 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000111 00000111 00000101 00000001
00000011 00000010 00000110 00000100
<truncated>
```

The assembly file is named `utils/bubble_sort.asm` as below. Notice all instructions that will cause stall cycles have been marked.

``` ASM
// The C version of the bubble sort is given as below:
// 
// void bubbleSort(int arr[], size_t n) {
//     for (size_t i = 0; i < n - 1; i++) {
//         for (size_t j = 0; j < n - i - 1; j++) {
//             if (arr[j] > arr[j+1]) {
//                 swap(&arr[j], &arr[j+1]);
//             }
//         }
//     }
// }
// 
// void swap(int *a, int *b) {
//     int temp = *a;
//     *a = *b;
//     *b = temp;
// }

// Load n-1 into x28. x29 will be the counter i.
ld x28, 12(x0)
ld x5, 1(x0)
sub x28, x28, x5 // stall

OuterLoop:
// Load n-i-1 into x30. x31 will be the counter j.
ld x30, 12(x0)
sub x30, x30, x29 // stall
ld x5, 1(x0)
sub x30, x30, x5 // stall
add x31, x0, x0

InnerLoop:
// Compare and swap arr[j] and arr[j+1].
ld x5, 13(x31)
ld x6, 14(x31)
blt x5, x6, SwapSkipped // stall
add x7, x5, x0
add x5, x6, x0
add x6, x7, x0
sd x5, 13(x31)
sd x6, 14(x31)
SwapSkipped:

// Compute j++.
ld x5, 1(x0)
add x31, x31, x5 // stall
blt x31, x30, InnerLoop

// Compute i++.
ld x5, 1(x0)
add x29, x29, x5 // stall
blt x29, x28, OuterLoop
```

The memory data after the simulation should as follows. Notice the memory cells 13-19 have been sorted in the ascending order.

``` MEM
// memory data file (do not edit the following line - required for mem load use)
// instance=/Driver/processor/data_mem/mem
// format=bin addressradix=h dataradix=b version=1.0 wordsperline=4
 @0 00000011 00000001 00000000 00000000
 @4 00000000 00000000 00000000 00000000
 @8 00000000 00000000 00000000 00000000
 @c 00000111 00000001 00000010 00000011
@10 00000100 00000101 00000110 00000111
```

From the waveform monitor, we know the whole program needs 385 clock cycles to finish. Theoretically, the inner loop runs `(1+6)*6/2=21` times, and each loop runs 11 instructions, so in total it casts `11*21=231` cycles. The outer loop runs 6 times with 8 instructions (excluding the inner loop part), accumulating to `6*8=48` cycles. Plus 3 initialization instructions, in theory this program needs `3+231+48=282` cycles.

Then let's compute the stall cycles. From the above assembly code, it seems that each inner loop will stall 2 cycles and each outer loop will stall 3 cycles. However, because our processor decides whether to stall the pipeline in the IF stage, the following instruction sequence will cause an extra stall cycle in each inner loop. To be specific, When the `blt` instruction knows whether it needs to branch in the EX stage, the `add` instructions is fetched and the pipeline is stalled for an unnecessary cycle. Therefore, in total there will be `3*21+3*6=81` stall cycles. Combining these two numbers, we have a rough estimation of the number of clock cycles that this program needs as `282+81=363` cycles, which is fairly close to the actual simulation result.

``` ASM
blt x31, x30, InnerLoop  // EX stage

// Compute i++.
ld x5, 1(x0) // ID stage
add x29, x29, x5 // Extra stall, IF stage
```

## Modified Forwarding Schema

The original forwarding schema from the book uses two stages of pipeline registers (EX/MEM and MEM/WB), so it can forward data that just come out of the ALU and the data memory to the input ports of the ALU. Also, it requires the register file can be written in the first half clock cycle and read in the later half, which demands a special (positive and negtive edge triggering) hardware. To clearly demonstrate the problem, consider the execution of the first three instructions in our example program as the code block and the table below shows. At the clock cycle 6, the content of the x7 register is forwarded to the instruction 3 from the MEM/WB pipeline register, but the the instruction 3 cannot obtain the content of the x6 register from any pipeline registers because it has been written back to the register file and lost in the pipeline. Therefore, the instruction must secure the value at cycle 5, where the value is just written back to the register file. To avoiding such special hardware, an extra sets of pipeline registers WB with appropriate forwarding control logic is added in the writeback stage, so the content of x6 will be properly forwarded to instruction 3 at the clock cycle 6.

``` ASM
ld x6, 0(x0) // inst 1
ld x7, 1(x0) // inst 2
and x5, x6, x7 // inst 3
```

| Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 | Cycle 5 | Cycle 6 |
| --- | --- | --- | --- | --- | --- |
| inst 1 IF | inst 1 ID | inst 1 EX | inst 1 MEM | inst 1 WB | ? |
| | inst 2 IF | inst 2 ID | inst 2 EX | inst 2 MEM | inst 2 WB |
| | | inst 3 IF | inst 3 Stall | inst 3 ID | inst 3 EX |
