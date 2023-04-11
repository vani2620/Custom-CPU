[[CPU ISA]]
[[Naive assembly program list]]
[[40.877952.pdf]]

Physical register file mapped to virtual register file mapped to architectural register file

Basic components
- PRF
- General map table
- Physical map table
- Renamer
- Commit queue
- Common Data Bus


Basic idea
1) Physical register file larger than size specified by ISA--architecturally visible registers are simply names
2) Have state field to indicate register state (4 total states)
	1) available - not allocated, cannot be read from or written to
	2) rename buffer - allocated
		1) not valid - waiting on write
		2) valid - written to, can be read from
	3) architectural register - allocated


Register file details
- Fields	
	- Value (64 bits)
	- State (4 bits)
		- 1 bit per each state
			- 0001 = free
			- 0010 = allocated as rename buffer, invalid
			- 0100 = allocated as rename buffer, valid
			- 1000 = allocated as architectural register
- Ports must support 2 instructions
	- 4 write ports
		- 2 ports for state
		- 2 ports for rename & writeback
			- Write conflicts? Don't give a shit, handled by RAT and assoc. mech.
	- 8 read ports
		- 4 ports for state
		- 4 ports for operand access
General map table
- 31 entries
	- Correspond to arch reg IDs
- Physical register address
- Virtual-physical register address
- Valid bit
	- Virtual register mapped to physical?
- Outputs to scoreboard, instruction queues, and commit queue
Physical map table
- CAM implementation
- number of entries equal to number of virtual-physical registers
- virtual-physical register address
- physical register address

Register ports (for n-wide issue)
- 2n write ports
	- n writes
	- n writeback writes
- 2n read ports
	- n reads per source operand

Renamer
- will manage RAT
- Checks for WAR and WAW deps

Common Data Bus
- Data bus
- Tag bus

Tag generation
- Similar scheme to [[rd.364.0713.pdf]]--each instruction is given a designated IID

[[Delaying_physical_register_allocation_through_virt.pdf]]
[[Dynamic_Register_Renaming_Through_Virtual-Physical.pdf]]
[[hpca.1998.650557.pdf]]
1. Fetch
	- Upon initialization, first 31 registers have state set to `1000`, and remaining are `0001`.
2. Decode
	- Source operands looked up in GMT--if `V` bit of corresponding entries are set, rename to corresponding physical registers. Otherwise, rename to virtual registers at `gmt[archregID]`.
	- When instruction names destination register, generate tag via counter for instruction and write tags to reorder buffer in program order. Update GMT so that `gmt[archregID] = tag`.
	- Add instructions to issue queues
3. Issue
	- Instructions issue when entry sources marked ready
4. Execute
	- Sources accessed and sent to FUs for consumption
5. Writeback
	- Broadcast tags at completion, allocate physical registers to tags, update PMT to reflect mapping
