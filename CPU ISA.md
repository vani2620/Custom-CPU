General specs:
- 64-bit data width  
- 32-bit instruction width (+ possibly 16-bit compressed instructions)  
- Multiple issue   
- Dynamic scheduling  
- Speculation  
- 3 operands  
- Vector architecture (16 elements of 64-bit data per register)
- Strong memory model
- Dedicated pointer registers (stack, global, frame, and thread)
- Hardware stack (?)  
- LNS/FP dual-path architecture for noninteger comps
- Single multi-threaded core  

Things to consider:
- n-wide issue = 2n write ports (n for renaming, n for writeback) + 2n read ports (n per source operand) in worst case
	- can be less
		- memory operations usually require only 1-2 operands
		- same with branch instructions

Functional units
-   Load/store unit
-   ALU
-   Barrel shifters
-   AGU
-   FPU
-   FMA unit
-   Multiplier
-   Divider
-   Instruction dispatcher

Lane structure
- ALU
- Register bank
- 

Major opcode size: 7 bits (temp)

3 register integer instructions (15 bits for registers) (refer to [[ALU spec]]])

-   Add   
-   Subtract
-   Multiply
-   Divide
-   Shifts
	-   1 bit
	-   2 bits
	-   4 bits
	-   8 bits
	-   16 bits
-   Set less than
	- Signed
	- unsigned
-   Logical ops
	- AND
	- OR
	- XOR
	- NOR (use a0 as an operand for NOT)
	- XNOR
	- NAND
	- IMPLIES (+ reversed operands)
	- ONLY (+ reversed operands)
2 register integer instructions (10 bits for registers)
- JALR - return destination and pointer
- Store - pointer and source (byte, halfword, word, double word)
- Load - pointer and destination (see above) 
- Immediate variants of 3 register instructions
- Branch instructions – BLE{U}, BEQ, BGE{U}, BNE  

1 register integer instructions (5 bits for registers)
- Load upper immediate - 20 bit immediate
- Add upper immediate to PC - 20 bit immediate
- Jump and link - 20 bit immediate
Supported immediate sizes
- Lower 12 bits
- Upper 20 bits
  

3 register floating point instructions
- Add
- Subtract
- Multiply
- Fused multiply-add
- Fused multiply-subtract
- Fused negated multiply-add
- Fused negated multiply-subtract
- 
  

Floating point/LNS requirement
- Rounding modes  
	- Ties to even – round to nearest even number  
	- Ties to zero – round to nearest whole number, bias to zero (i.e. 11.5 -> 11.0, -11.5 -> -11.0) (basically just truncation)  
	- Ties to positive infinity – round up  
	- Ties to negative infinite – round down
	- Ties away from zero – round up if positive, round down if negative
- Operations
	- Multiply  
	- Add  
	- Subtract
	- Divide  
	- Remainder
	- Maximum/minimum  
	- Comparisons (review doc)
	- Total ordering (review doc)
-   Misc. features
	- Signed zero (for dealing with singularities)
	- Subnormals (range limitations)
	- NaN
	- Positive/negative infinity


Shared opcode spaces
- Integer
- Arithmetic and logical operations (shifts excluded)
	- Total number: 12 operations => 4 bits for function code  
- Shifts  
	- Total: 3 operations => 2 bit function code  
- Branches
	- Total: 6 operations => 3 bit function code
- Jump
	- 1 operation => no function code needed
- Loads
	- Total: 4 operations => 2 bit function code
- Stores
	- Total: 4 operations => 2 bit function code
- Floating point/Logarithmic
	- Arithmetic
		- Total: 3 operations => 
- Fused multiply-add unit
	- Total: 4 operations => 
- Vector
	- Set VL
	- Load
	- Store  
	- Gather 
	- Scatter

Data types
- sint{8, 16, 32, 64, 128} 
- uint{8, 16, 32, 64, 128}
- float{16, 32, 64, 128}

Pipeline stages
- Instruction fetch (IFe)  
- Instruction decode (IDe)
- Instruction dispatch (IDi)  
- Execute
- Commit

  

Vector stuff

ELEN = max supported element size in bits

VLEN = 

SEW = selected element width in bits (powers of 2 only)

  
  

Toy assembly program for Fibonacci  
Parameter: n  
Description: calculates first n terms of Fib sequence and stores each in memory

```
addi(r0, n)  → r1 //records # of terms to calculate

addi(r0, 1) → r2 //loads 1 into r2 – first element calculated

sw(r2) → mem[sp] //stores r2 onto stack

subi(r1, 1) → r1 //decrement n

beq(r1, r0) → pc[exit] // n == 0: exit | continue  
  

subi(sp, 4) → sp //decrement stack pointer by word address

sw(r2) → mem[sp] //stores r2 onto stack again – second element

subi(r1, 1) → r1 

beq(r1, r0) → pc[exit]  
  

subi(sp, 4) → sp

add(r2, r2) → r3 //adds r2 to itself, stores in r3  
sw(r3) → mem[sp]

subi(r1, 1) → r1

beq(r1, r0) → pc[exit]

  

subi(sp, 4) → sp

add(r2, r3) → r3  
sw(r3) → mem[sp]

subi(r1, 1) → r1

beq(r1, r0) → pc[exit]
```
  

Fibonacci sequence but parallel

Parameter: n

Description: see above

  
**


[[SPI controller]]


