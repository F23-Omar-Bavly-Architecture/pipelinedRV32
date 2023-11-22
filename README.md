# pipelinedRV32
A 5 stage pipelined, single memory implementation of a RV32 CPU.
The CPU will support all RV32I base instructions (except for ecall). 
Stretch goals include: 
- [ ] Stall on a memory access to avoid structural hazard.
- [ ] Support M extension.
- [ ] Support C extension.
- [ ] Move branch outcome & target address computation to the ID stage.
- [ ] Implement 2-bit dynamic branch prediction.
