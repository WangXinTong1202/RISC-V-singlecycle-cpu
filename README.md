# Singlecycle-CPU
a single cycle CPU based on RISC-V instruction datasets

Table of Contents
=================

* [Directory Structure](#directory-structure)
* [CPU Design](#cpu-design)

# Directory Structure
<pre>
├── CPU(sc_computer.v)
│   ├── core(sc_cpu.v)
│   │   ├── alu.v
|   |   ├── branch_addr.v
|   |   ├── jal_addr.v
|   |   ├── jalr_addr.v
|   |   ├── imme.v
|   |   ├── dff32.v
|   |   ├── regfile.v
|   |   ├── pc4.v
|   |   ├── mux2x32.v
|   |   ├── mux4x32.v
|   |   ├── sc_cu.v
|   ├── data memory(sc_datamem.v)
|   ├── instruction memory(sc_instmem.v)
  </pre>
  
# CPU Design
![](Diagrams/cpu.jpg)
- 32-bit computing  
- The CPU utilizes the Harvard architecture
- Design is based on the RISC-V instruction set architecture (ISA)
- The CPU is a pipelined, single-core CPU that can execute the instructions in the base RV32I subset of the RISC-V ISA (except for those related to exceptions and interrupts).

  
