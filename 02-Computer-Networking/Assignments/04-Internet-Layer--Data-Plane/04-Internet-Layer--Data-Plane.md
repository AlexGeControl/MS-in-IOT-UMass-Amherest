# Computer Networks

## Lesson 04 - Internet Layer -- Data Plane

---

### P5. Consider a datagram network using 32-bit host addresses. Suppose a router has four links, numbered 0 through 3, and packets are to be forwarded to the link interfaces as follows:

|                             Destination Address Range                             | Link Interface |
|:---------------------------------------------------------------------------------:|:--------------:|
|   11100000 00000000 00000000 00000000 through 11100000 00111111 11111111 11111111 |        0       |
|   11100000 01000000 00000000 00000000 through 11100000 01000000 11111111 11111111 |        1       |
|   11100000 01000001 00000000 00000000 through 11100001 01111111 11111111 11111111 |        2       |
|                                     otherwise                                     |        3       |

#### a. Provide a forwarding table that has five entries, uses longest prefix matching, and forwards packets to the correct link interfaces.

**Ans** Below is the derived forward table:

|    Prefix Match   | Interface |
|:-----------------:|:---------:|
|    11100000 00    |     0     |
| 11100000 01000000 |     1     |
|     11100001 0    |     2     |
|     11100001 1    |     3     |
|     otherwise     |     3     |

#### b. Describe how your forwarding table determines the appropriate link interface for datagrams with destination addresses

**Ans** Below is the result of longest prefix matching and forwarded destination link interface:

|         Destination Address         | Longest Prefix Matched | Link Interface Forwarded |
|:-----------------------------------:|:----------------------:|:------------------------:|
| 11001000 10010001 01010001 01010101 |        otherwise       |             3            |
| 11100001 01000000 11000011 00111100 |       11100001 0       |             2            |
| 11100001 10000000 00010001 01110111 |       11100001 1       |             3            |

---

### P6. Consider a datagram network using 8-bit host addresses. Suppose a router uses longest prefix matching and has the following forwarding table:

| Prefix Match | Interface |
|:------------:|:---------:|
|      00      |     0     |
|      010     |     1     |
|      011     |     2     |
|      10      |     2     |
|      11      |     3     |

For each of the four interfaces, give the associated range of destination host addresses and the number of addresses in the range.

**Ans** Below is the result of destination address association for each link interface

| Link Interface |   Destination Address Range  | Num. of Addresses |
|:--------------:|:----------------------------:|:-----------------:|
|        0       |  0000 0000 through 0011 1111 |         64        |
|        1       |  0100 0000 through 0101 1111 |         32        |
|        2       |  0110 0000 through 1011 1111 |         96        |
|        3       |  1100 0000 through 1111 1111 |         64        |

---

### P8. Consider a router that interconnects three subnets: Subnet 1, Subnet 2, and Subnet 3. Suppose all of the interfaces in each of these three subnets are required to have the prefix 223.1.17/24. Also suppose that Subnet 1 is required to support at least 60 interfaces, Subnet 2 is to support at least 90 interfaces, and Subnet 3 is to support at least 12 interfaces. Provide three network addresses (of the form a.b.c.d/x) that satisfy these constraints.

**Ans** Below is the result of network address allocation.

First, round up the minimum number of required interface addresses to the minimum sum of 2's exponentials. The result is as follows:


| Subnet | Min. Num. of Interfaces | Min. Sum of 2's Exponential |
|:------:|:-----------------------:|:---------------------------:|
|    1   |            60           |             64              | 
|    2   |            90           |             96              | 
|    3   |            12           |             16              | 

Next, partition the available address space according to the above 2's exponentials. Since address 223.1.17.0 & 223.1.17.225 cannot be used, here the address allocation will start from 223.1.17.16. Below is the final result:

| Subnet |           Address Range           |         Network Address         |
|:------:|:---------------------------------:|:-------------------------------:|
|    1   | 223.1.17.128 through 223.1.17.191 |         223.1.17.128/26         |
|    2   |  223.1.17.32 through 223.1.17.127 | 223.1.17.32/27 & 223.1.17.64/26 |
|    3   |  223.1.17.16 through 223.1.17.31  |          223.1.17.16/28         |

---

### P12. Consider the topology shown in Figure 4.20 . Denote the three subnets with hosts (starting clockwise at 12:00) as Networks A, B, and C. Denote the subnets without hosts as Networks D, E, and F.

#### a. Assign network addresses to each of these six subnets, with the following constraints: All addresses must be allocated from 214.97.254/23; Subnet A should have enough addresses to support 250 interfaces; Subnet B should have enough addresses to support 120 interfaces; and Subnet C should have enough addresses to support 120 interfaces. Of course, subnets D, E and F should each be able to support two interfaces. For each subnet, the assignment should take the form a.b.c.d/x or a.b.c.d/x – e.f.g.h/y.

**Ans** Below is the result of network address attained using the same approach in P8:

| Subnet | Min. Num. of Interfaces | Min. Sum of 2's Exponential |             Address Range             |            Network Address            |
|:------:|:-----------------------:|:---------------------------:|:-------------------------------------:|:-------------------------------------:|
|    A   |           250           |             256             |  214.97.254.0 through 214.97.254.251  |  214.97.254.0/24 - 214.97.254.252/30  |
|    B   |           120           |             128             |  214.97.255.0 through 214.97.255.127  |  214.97.255.0/25 - 214.97.255.124/30  |
|    C   |           120           |             128             | 214.97.255.128 through 214.97.255.255 | 214.97.255.128/25 - 214.97.255.252/30 |
|    D   |            2            |              2              | 214.97.254.252 through 214.97.254.255 |           214.97.254.252/30           |
|    E   |            2            |              2              | 214.97.255.124 through 214.97.255.127 |           214.97.255.124/30           |
|    F   |            2            |              2              | 214.97.255.252 through 214.97.255.255 |           214.97.255.252/30           |

#### b. Using your answer to part (a), provide the forwarding tables (using longest prefix matching) for each of the three routers.

**Ans** Denote the three interfaces of each router (staring clockwise at 12:00) as 0, 1, and 2. The forward tables for the three routers are as follows.

First is the forward table for R1

|    Prefix Match   | Interface |
|:-----------------:|:---------:|
|  214.97.254.0/24  |     0     |
|  214.97.255.0/25  |     1     |
| 214.97.255.128/25 |     2     |

Then is the forward table for R2

|    Prefix Match   | Interface |
|:-----------------:|:---------:|
|  214.97.254.0/24  |     0     |
|  214.97.255.0/25  |     1     |
| 214.97.255.128/25 |     2     |

Finally is the forward table for R3

|    Prefix Match   | Interface |
|:-----------------:|:---------:|
|  214.97.254.0/24  |     0     |
|  214.97.255.0/25  |     1     |
| 214.97.255.128/25 |     2     |

Due to the network topology, the three forward tables are in fact the same.

