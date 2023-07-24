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

Shared opcode spaces
- Integer
	- Arithmetic
	- Comparisons
	- Bitwise
	- Shifting
- Control flow
	- Branches
	- Jump
	- Predicated instructions
	- Conditional moves
- Memory
	- Loads
	- Stores
- Floating point/Logarithmic (reserved)
	- Arithmetic
	- Rounding
	- Comparison
- Fused multiply-add unit (reserved)
	- Total: 4 operations => 
- Vector (reserved)
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


Opcode composition
`opcode[1:0]` - instruction width
	`00` => 16b
	`01` => 32b (default)
	`10` => 48b
	`11` => 64b

32b instructions
Fixed-point arithmetic instructions (non-immediate)
- source register 1
- source register 2
- destination register
- function code
Fixed-point arithmetic instructions (immediate)
- source register
- destination register
- function code
- immediate
Compare and branch 
- source register 1
- source register 2
- branch target offset 
Unconditional direct jump
- destination register
- jump target address 
Unconditional indirect jump 
- destination register
- source register
- jump target offset 
Predicated instructions 
- source register 1
- source register 2
- destination register
- condition code 
Conditional selects 
- source register
- destination register 1
- destination register 2
- condition code
Indirect loads
- destination register
- source register (address base)
- address offset
Indirect stores
- source register 1 (data)
- source register 2 (address base)
- address offset

`opcode[7:2]` specifies type
	`'d0` => arithmetic 3op (integer)
	`'d1` => arithmetic 2op (integer)
	`'d2` => 
  

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


