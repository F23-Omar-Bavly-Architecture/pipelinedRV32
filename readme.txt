Stuent Names:
Omar Elfouly 900211195
Bavly Remon  900213052

Issues:
- refactoring may be necessary
- readmemh can be used later

Assumptions:
No assumptions other than those included in the handout (i.e. 2 memories) and that the given instruction is valid

What Works:
- All forty user-level instructions (listed in page 130 of the RISC-V Instruction Set Manual – Volume I: Unprivileged ISA and explained in Chapter2 of the same manual)
- except ECALL, EBREAK, and FENCE instructions
	- EBREAK instruction as a halting instruction that ends the execution of any program (by preventing the program counter from being updated anymore).
	- ECALL and FENCE instructions interpreted as no-op instructions that do nothing.

What does not work:
- No known problems exist
