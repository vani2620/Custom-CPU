[[CPU ISA]]

Signals:
- $\text{SCLK}$ - serial clock signal
- $\text{MOSI}$ - master out, slave in
- $\text{MISO}$ - master in, slave out
- $\overline{\text{CS}}$ - chip select

Signalling scheme: differential $\rightarrow$ each signal above will need to be transmitted as regular and inverted

Data width: 64 bits

PISO shift register for master-side with SI
SIPO shift register for slave-side with SO
Example setup:
![[Pasted image 20230210150415.png]]



NRZI 64b/66b encoding: encodes logic values as clock transitions
- Logical 1: transition (i.e. low signal $\to$ rising edge; high signal $\to$ falling edge)
- Logical 0: no transition
![[Pasted image 20230210171107.png]]

