# SingleCycleRV32I
A single cycle datapath block diagram and Verilog description supporting all of the RV32I instructions except for EBREAK (preventing the program counter from being updated anymore), ECALL and FENCE instructions will interpreted as no-op instructions that do nothing. 2 separate memories must be used for instructions and memory.
