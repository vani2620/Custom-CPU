32 bit instruction word
3 operand
Load-store
4 bit major opcode
4 bit minor opcode



### Branch conditions
1. GE (equiv. to LT when operands reversed)
2. GT (equiv. to LE when operands reversed)
3. EQ
4. NE
5. Other possibilities reserved...
## Major opcode 0x01 - 3op type 0
-> Minor opcode 0x00 = ADD
-> Minor opcode 0x01 = SUB
-> Minor opcode 0x02 = MULT
-> Minor opcode 0x03 = MULTU
-> Minor opcode 0x04 = OR
-> Minor opcode 0x06 = AND
-> Minor opcode 0x07 = XOR
-> Minor opcode 0x08 = LLOG
-> Minor opcode 0x09 = RLOG
-> Minor opcode 0x0A = LROT
-> Minor opcode 0x0B = RROT
-> Minor opcode 0x0C = RAR
-> Minor opcode 0x0D-0x0F = Reserved

## Major opcode 0x02 - Branch to Immediate

## Major opcode 0x03 - Indirect Jump

## Major opcode 0x04 