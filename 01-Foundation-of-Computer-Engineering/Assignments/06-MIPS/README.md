# Foundation of Computer Engineering

## Lesson 05 - MIPS Instruction Set Architecture

---

### 1.a The following problems deal with translating from C code to MIPs code. Assume that variables x, y and z are given and implemented as 32-bit integers in a C program (y is an even number). Also assume the values of x, y and z are stored in register $s1, $s2 and $s3, respectively, and the value of result f is stored in register $s0.

* f = x*4 + y - z
* f = z + 24 - x + y/2

#### For each C statement above, what is the corresponding MIPS code?

**ANS** Below are the MIPS code for the above two C statements:

```c++
f = x*4 + y - z;
```

```mips
sll $s0, $s1, 2
add $s0, $s0, $s2
sub $s0, $s0, $s3
```

```c++
f = z + 24 - x + y/2;
```

```mips
srl $s0, $s2, 1
sub $s0, $s0, $s1
addi $s0, $s0, 24
add $s0, $s0, $s3
```

#### How many bits are needed to encode the above instructions for each C statement?

**ANS** Since each MIPS instruction is 32-bit wide, the number of instructions needed for each statement is as follows:

|     C++ Statement     | MIPS Instruction Size/bit |
|:---------------------:|:-------------------------:|
|    f = x*4  + y - z   |             96            |
| f = z + 24  - x + y/2 |            128            |

#### How many bits are needed in the register file to store the data for each C statement?

**ANS** 

---

### 1.b The following problems deal with translating from MIPS to C code. Assume that variables x, y and z are given and implemented as 32-bit integers in a C program (y is an even number). Also assume the values of x, y and z are stored in register $s1, $s2 and $s3, respectively, and the value of result f is stored in register $s0.

* addi $s0, $s1, -100
* sll $s0, $s0, 4

#### How can the two MIPS instructions above be represented using C code?

**ANS** Below are the corresponding C statement for the above two MIPS instructions:

```mips
addi $s0, $s1, -100
```

```c++
f = x - 100;
```

```mips
sll $s0, $s0, 4
```

```c++
f *= 16;
```

#### Why are constants in I-type instructions represented in 2’s complement format?

**ANS** I-type instructions are used for the following three types of instruction 

* an immediate operand

* a branch target offset (the signed difference between the address of the following instruction and the target label, with the two low order bits dropped)

* a memory operand displacement

Since 2's complement format is used, the following benefits can be attained:

* for arithmetic and logical operations, both positive and negative imm can be used in the instruction, which simplifies the instruction set architecture design: there is no need for subi since the subi can be implemented with addi using negative imm.

* for relative jump operations, the PC can branch to both positive and negative positions. This is crucial for typical C/C++ statements like while-loop and for-loop.

#### What is the largest value (in decimal) that can be represented in the immediate field of an I-type instruction?

**ANS** The range for imm field integer value in I-type instruction is:

| Type |   Value  |
|:----:|:--------:|
|  Min |  -2**15  |
|  Max | +2**15-1 |

---

### 2. In the following problem, the data table contains bits that represent the opcode of an instruction. You will be asked to translate the entries into assembly code and determine what format of MIPS instruction the bits represent.

* 0010 0001 0001 0111 0000 0000 0001 0000
* 0000 0001 0000 1001 1000 0000 0010 0000

#### For the binary entries above, what MIPS instructions do they represent?

**ANS** Below is the table for the binary representation and its corresponding assembly.

|                 Binary                |               Assembly              |
|:-------------------------------------:|:-----------------------------------:|
|  001000 01000 10111 0000000000010000  | addi $23, $8, 16 / add $s7, $t0, 16 |
| 000000 01000 01001 10000 00000 100000 | add $16, $8, $9 / add $s0, $t0, $t1 |

#### What type (I-type, R-type) instruction do the binary entries represent?

**ANS** Below is the table for the binary representation and its corresponding instruction type.

|                 Binary                |  Type  |
|:-------------------------------------:|:------:|
|  001000 01000 10111 0000000000010000  | I-type |
| 000000 01000 01001 10000 00000 100000 | R-type |

---

### 3. In the following problems, the data table contains MIPS instructions.

* sub $s0, $t1, $t2
* lw $s0, 8($t0)

#### For the instructions above, show the hexadecimal representations of the instructions.

**ANS**

|      Assembly     |                  Hex Representation                  |
|:-----------------:|:----------------------------------------------------:|
| sub $s0, $t1, $t2 | 0000 0001 0010 1010 1000 0000 0010 0010 / 0x012A8022 |
|   lw $s0, 8($t0)  | 1000 1101 0001 0000 0000 0000 0000 1000 / 0x8D100008 |

#### Indicate the type of each instruction

**ANS**

|      Assembly     | Instruction Type |
|:-----------------:|:----------------:|
| sub $s0, $t1, $t2 |      R-type      |
|   lw $s0, 8($t0)  |      I-type      |

#### Show the hexadecimal value of each field of each instruction

**ANS** Firs the binary pattern for each assembly is summarized as follows:

|      Assembly     |              Binary Pattern             |
|:-----------------:|:---------------------------------------:|
| sub $s0, $t1, $t2 | 0000 00ss ssst tttt dddd d000 0010 0010 |
|   lw $s0, 8($t0)  | 1000 11ss ssst tttt iiii iiii iiii iiii |

```mips
sub $s0, $t1, $t2
```

* op:  000000
* rs:   01001
* rt:   01010
* rd:   10000
* sa:   00000
* fn:  100010

```mips
lw $s0, 8($t0)
```

* op:  100011
* rs:   01000
* rt:   10000
* imm: 0000 0000 0000 1000

---

### 4. What is the purpose of the sign extend block in the MIPS datapath? Describe how it is used for one MIPS instruction which requires it.

**ANS**

The sign extend block in ID is used to create 32-bit signed immediate from the 16-bit imm field of 32-bit I-type instruction. Here sign extension is used thus conditional branch instructions such as beq and bne can branch both forward and backward. In the I-type instruction the imm field is only of 16 bits because for memory access and conditional branch data/code locality holds.

The sign extend block is used in the following MIPS instructions:

* LW --LW, rt, offset(rs)
    * Here sign extension is used to generate the data memory address
* BEQ -- BEQ rs, rt, offset
    * Here sign extension is used to generate target PC address

---

### 5. Note the pipelined MIPS datapath shown on slide 9 of lecture 17. 

#### Redraw the figure to include hardware to support a j instruction (hint: examine slide 19 of lecture 12). 

**ANS** Cannot access the datapath on slide 9 of lecture 17...

#### For the following instructions, indicate which hardware blocks are used for each instructions (e.g. sign extend, shift, ALU, etc). Please include ALL hardware (including control) which is used for the instructions *add, lw, bne, and j* in a list.

**ANS**: Below are hardware block usage for each of the four instructions:

1. ADD (R-Type Instruction)
    * Datapath Blocks
        * IF
            * PC
            * Adder with one constant operand 4
            * Instruction Memory
        * ID
            * Register File
        * EX
            * ALU
        * MEM
            * None
        * WB
            * All
    * Control
        * IF
            * None
        * ID
            * RegDst = 1 to use *d* as write-back register
            * Jump = 0
            * Branch = 0
            * MemRead = 0
            * MemToReg = 0 to use the output of ALU as write data to register file
            * ALUOp = 0x00
            * MemWrite = 0
            * ALUSrc = 0 to use *t* as the second operand to ALU
            * RegWrite = 1 to write the output of ALU back to register file
        * EX
            * ALU Controller
        * MEM
            * None
        * WB
            * All

2. LW (I-Type Instruction)
    * Datapath Blocks
        * IF
            * PC
            * Adder with one constant operand 4
            * Instruction Memory
        * ID
            * Register File
            * Sign Extender
        * EX
            * ALU
        * MEM
            * Data Memory
        * WB
            * All
    * Control
        * IF
            * None
        * ID
            * RegDst = 0 to use *t* as write-back register
            * Jump = 0
            * Branch = 0
            * MemRead = 1
            * MemToReg = 1 to use the output of ReadData port of data memory as write data to register file
            * ALUOp = 0x23
            * MemWrite = 0
            * ALUSrc = 1 to use the output of sign extender as the second operand to ALU
            * RegWrite = 1 to write the output of ALU back to register file
        * EX
            * ALU Controller
        * MEM
            * All
        * WB
            * All

3. BNE (I-Type Instruction)
    * Datapath Blocks
        * IF
            * PC
            * Adder with one constant operand 4
            * Instruction Memory
        * ID
            * Register File
            * Sign Extender
        * EX
            * ALU
            * Shift-Left 2, Adder for BNE target PC calculation
        * MEM
            * None
        * WB
            * None
    * Control
        * IF
            * None
        * ID
            * RegDst = X
            * Jump = 0
            * Branch = 1
            * MemRead = 0
            * MemToReg = X
            * ALUOp = 0x05
            * MemWrite = 0
            * ALUSrc = 0 to use *t* as the second operand to ALU
            * RegWrite = X
        * EX
            * ALU Controller
            * Zero
        * MEM
            * None
        * WB
            * None

4. J (J-Type Instruction)
    * Datapath Blocks
        * IF
            * PC
            * Adder with one constant operand 4
            * Instruction Memory
        * ID
            * Shift-Left 2 for target PC lower 28 bit generation
        * EX
            * None
        * MEM
            * None
        * WB
            * None
    * Control
        * IF
            * None
        * ID
            * RegDst = X
            * Jump = 1
            * Branch = 0
            * MemRead = 0
            * MemToReg = X
            * ALUOp = 0x02
            * MemWrite = 0
            * ALUSrc = X
            * RegWrite = X
        * EX
            * None
        * MEM
            * None
        * WB
            * None
---

### 6. For this exercise we will examine the affect of pipelining on datapath latency and throughput. Consider the following latencies of the datapath on slide 3 of lecture 16.

* (a) IF =200ps, ID=250ps, EX=400ps, MEM =450ps, WB=150ps
* (b) IF =300ps, ID=150ps, EX=450ps, MEM =650ps, WB=200ps

#### What is the minimum clock cycle time for pipelined and unpipelined versions of these datapaths (one answer for each circuit)?

**ANS** For *pipelined* version, the minimum clock cycle is determined by the slowest operation in the datapath, while for the unpipelined / single-cycle version, the minimum clock cycle is determined by the slowest instruction. Following this principle, the required minimum clock cycles can be determined as follows:

| Datapath | Unpipelined | Pipelined |
|:--------:|:-----------:|:---------:|
|     A    |     1450    |    450    |
|     B    |     1750    |    650    |

#### What is the latency of an sub instruction in pipelined and unpipelined versions of the datapath? What is the throughput of a series of these instructions if they are executed consecutively.

**ANS** Since in the MIPS ISA only for operations, IF, ID, EX and WB are used for sub instruction, the latency of the sub instruction using the two datapath implementations are as follows:

| Datapath | Unpipelined | Pipelined |
|:--------:|:-----------:|:---------:|
|     A    |     1000    |    1000   |
|     B    |     1100    |    1100   |

The throughputs are only determined by the clock cycles of the datapaths and are summarized as follows:

| Datapath | Unpipelined |   Pipelined  |
|:--------:|:-----------:|:------------:|
|     A    | 689.66 MIPS | 2222.22 MIPS |
|     B    | 571.43 MIPS | 1538.46 MIPS |

#### What is the latency of an sw instruction in pipelined and unpipelined versions of the datapath? What is the throughput of a series of these instructions if they are executed consecutively.

**ANS** Since in the MIPS ISA only for operations, IF, ID, EX and MEM are used for sub instruction, the latency of the sw instruction using the two datapath implementations are as follows:

| Datapath | Unpipelined |   Pipelined  |
|:--------:|:-----------:|:------------:|
|     A    | 689.66 MIPS | 2222.22 MIPS |
|     B    | 571.43 MIPS | 1538.46 MIPS |

---

### 7. On the datapath shown on slide 3 of lecture 16, add circuitry to allow for data forwarding from the data memory. Please redraw the figure, including the necessary new hardware and wires needed for the forwarding. Only include hardware for memory data forwarding.

**ANS** Cannot find the datapath on slide 3 of lecture 16...

---

### 8. Consider the instruction lw $s1, −8($t1). Use the datapath shown on slide 3 of lecture 16 for your answer:

#### What is this instruction in Hex format?

**ANS** Since the syntax and encoding for the instuction is as follows:

|       Syntax      |                 Encoding                |
|:-----------------:|:---------------------------------------:|
| lw $t, offset($s) | 1000 11ss ssst tttt iiii iiii iiii iiii |

Its representation in Hex format is:

* binary: 1000 1101 0011 0001 1111 1111 1111 1111 1000
* hex: 0x8D31FFF8

#### What is the output of the sign extend unit for this instruction as it is exits the ID stage

**ANS** Its output should be 0xFFFFFFF8.

#### What is the input value of ”Read Addr 1” in the ID stage? How big is the input?

**ANS** The input value of "Read Addr 1" is 01001 of 5-bit as decimal value 9.

#### Assuming the instruction is located at address 0x3250, what is the value of the PC after the IF stage?

**ANS** After the IF stage the PC should be PC + 4 which is 0x3254.

#### If the longest stage of the pipeline requires 300ps, what is the latency of the instruction? What is the throughput of the pipeline?

**ANS** Since 5 stages are used, the **latency** is 300ps * 5 = 1.5ns. The throughput of the pipeline under full load should be 3333.33 MIPS(Millions of Instructions Per Second).