[[CPU ISA]]

Transmission signals:
- SCLK - serial clock signal to peripheral
- COPI - controller out, peripheral in
- POCI - peripheral out, controller in
- $\overline{\text{CS}}$ - chip select

Data width: 64 bits

PISO shift register for master-side with SI
SIPO shift register for slave-side with SO
Example setup:
![[Pasted image 20230210150415.png]]

Control/status signals
- `start_txn`, `end_txn` - indicates start (resp. end) of transaction 
	- might replace with clock-based framing
- `spi_mode` - selects modes
	- `spi_mode[0]` - gives CPOL -> clock polarity
		- if 0, idle SCLK at 0
		- if 1, idle SCLK at 1
	- `spi_mode[1]` - CPHA -> clock phase
		- if 0, sample bit on leading edge, shift on trailing
		- if 1, shift on leading edge, sample on trailing

{Not currently needed}
NRZI 64b/66b encoding: encodes logic values as clock transitions
- Logical 1: transition (i.e. low signal $\to$ rising edge; high signal $\to$ falling edge)
- Logical 0: no transition
![[Pasted image 20230210171107.png]]

