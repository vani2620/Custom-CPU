[[Branch prediction]]
[[Register renaming scheme]]

Stages:
1. F - Fetch
	1. Load MAR with value of PC
	2. Access memory, load instruction into MDR
	3. Load instruction in MDR into IR
2. D - Decode
	1. Decode opcode
	2. Decode function code (if applicable)
	3. Pass arguments to locations as needed
3. R - Rename
4. I - Issue
5. X - Execute
6. W - Writeback
7. C - Commit

Pipes:
- Add/subtract/compare/bitwise pipe
- Floating point pipe
- Multiply pipe
- Divide pipe
- Branch pipe
- Memory pipe