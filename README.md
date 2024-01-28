# Singlecycle-CPU
a single cycle CPU based on RISC-V instruction datasets

Table of Contents
=================

* [Directory Structure](#directory-structure)
* [CPU Design](#cpu-design)
   * [Control Unit](#control-unit)

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
![](singlecycle.png)
- 32-bit computing  
- Design is based on the RISC-V instruction set architecture (ISA)
- Reference : Yamin Li. Computer Organization and Design. Lecture presented at Hosei University, Fall 2023. Retrieved from https://yamin.cis.k.hosei.ac.jp/lectures/cod/

## Control Unit
- The control unit is responsible for sending select signals to multiplexers as well as the ALU control signal.
- Signals:
	- Inputs:
		- **opcode**: The first 7 bits of the instruction \[6:0]	
		- **func3**: A 3 bit function code that is held in bits \[14:12] of the instruction 
		- **func7**: A 7 bit function code that is held in bits \[31:25] of the instruction
		- **z**: A 1 bit control signal, named 'zero flag', serves as the output of the ALU and is utilized to determine whether the rs1 and rs2 values are equal or not equal for the 'beq' and 'bne' instructions

	
	- Outputs:
		- **pcsrc\[1:0]**: Control signal for a 4-1 multiplexer
         - 00: Select PC+4
         - 01: Select branch target address
         - 10: Select register address
         - 11: Select jump target address

		 - **bimm**: Control signal for a 2-1 multiplexer
        - 1: Select extended immediate value
        - 0: Select data from the register file
          
		 - **alui\[1:0]**: Control signal for Immediate Value Operation Circuit(imme)
        - 00: Select immediate value for addi, xori, ori, andi, lw instructions
        - 01: Select shamt for slli, srli, srai instructions
        - 10: Select immediate value for sw instructions
        - 11: Select immediate value for lui instructions

		 - **wreg**: The write enbale signal for the register file
		 - **call**: Control signal for selecting what data to write into the register file
        - 1: Select PC+4
        - 0: Select data from the ALU or memory
		 - **m2reg**: Control signal for selecting what data to write back
       - 1: Select data read from memory
       - 0: Select ALU output
      - **wmem**: The write enable signal for the data memory

- Instructions and their respective signal values:
  
| Instruction    | z | pcsrc[1:0] | aluc[4:0] | bimm | alui[1:0] | wreg | call | m2reg | wmem |
| ------- | - | --------- | --------- | ---- | -------- | ---- | ---- | ----- | ---- |
| i_lui   | x | 00        | x0110     | 1    | 11       | 1    | 0    | 0     | 0    |
| i_jal   | x | 11        | xxxxx     | x    | xx       | 1    | 1    | x     | 0    |
| i_jalr  | x | 10        | xxxxx     | x    | xx       | 1    | 1    | x     | 0    |
| i_lw    | x | 00        | 00000     | 1    | 00       | 1    | 0    | 1     | 0    |
| i_sw    | x | 00        | 00000     | 1    | 10       | 0    | x    | x     | 1    |
| i_addi  | x | 00        | 00000     | 1    | 00       | 1    | 0    | 0     | 0    |
| i_xori  | x | 00        | x1011     | 1    | 00       | 1    | 0    | 0     | 0    |
| i_ori   | x | 00        | x0100     | 1    | 00       | 1    | 0    | 0     | 0    |
| i_andi  | x | 00        | x0101     | 1    | 00       | 1    | 0    | 0     | 0    |
| i_slli  | x | 00        | x0011     | 1    | 01       | 1    | 0    | 0     | 0    |
| i_srli  | x | 00        | x0111     | 1    | 01       | 1    | 0    | 0     | 0    |
| i_srai  | x | 00        | x1111     | 1    | 01       | 1    | 0    | 0     | 0    |
| i_add   | x | 00        | 00000     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_sub   | x | 00        | 00001     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_slt   | x | 00        | 00010     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_xor   | x | 00        | x1011     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_or    | x | 00        | x0100     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_and   | x | 00        | x0101     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_mul   | x | 00        | 01000     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_mulh  | x | 00        | 10000     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_mulhsu| x | 00        | 10001     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_mulhu | x | 00        | 10010     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_div   | x | 00        | x1100     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_divu  | x | 00        | 11000     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_rem   | x | 00        | 01101     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_remu  | x | 00        | 11101     | 0    | xx       | 1    | 0    | 0     | 0    |
| i_beq   | 0 | 01        | 01001     | 0    | xx       | 0    | x    | x     | 0    |
|         | 1 | 00        | 01001     | 0    | xx       | 0    | x    | x     | 0    |
| i_bne   | 0 | 01        | 01010     | 0    | xx       | 0    | x    | x     | 0    |
|         | 1 | 00        | 01010     | 0    | xx       | 0    | x    | x     | 0    |




  
