# AHB_to_APB_Bridge

## **Overview: AHB to APB Bridge**

The **AHB-to-APB Bridge** is an essential component in the **AMBA (Advanced Microcontroller Bus Architecture)** system.
It connects:

* **AHB (Advanced High-performance Bus)** — used for **high-speed** communication (e.g., CPU, DMA, memory)
* **APB (Advanced Peripheral Bus)** — used for **low-power, low-speed peripherals** (e.g., UART, GPIO, timers)

Because AHB and APB have **different protocols and timing requirements**, the bridge performs **protocol conversion**.
** 1.1 Architecture of AHB to APB Bridge**

<img width="649" height="272" alt="image" src="https://github.com/user-attachments/assets/76da7a20-afcd-4550-b922-4f96713027c6" />


The Architecture of AHB to APB is given on the Figure 2. As shown in figure 2 architecture has three modules. In this Architecture data will transfer from APB master to AHB slave Bridge. FSM is used for interface between low bandwidth APB and high bandwidth AHB. Pipelining structure is use in FSM to transfer data from APB to AHB.A wait state is use transfer data to or from APB ,because APB has low bandwidth so its transfer speed is slow, so AHB need to wait until APB complete the read or write . In AMBA based AHB master will initialize the operation by sending address and control signal to AHB Slave. After that AHB Slave will send read and write data to AHB master as per the address and control given by AHB slave. Then AHB master will send Hready signal to AHB slave, which indicate that transfer has done.


Figure 2: Architecture of AHB to APB Bridge

---
## 2. AHB to APB Bridge
The AHBtoAPB Bridge is an AHB slave, providing an interface between the high-speed AHB and the low-power APB. Read and write transfers on the AHB are converted into equivalent transfers on the APB. As the APB is not pipelined, then wait states are added during transfers to and from the APB when the AHB is required to wait for the APB.
The main sections of this module are:
• AHB slave bus interface
• APB transfer state machine, which is independent of the device memory map
• APB output signal generation.

<img width="616" height="436" alt="image" src="https://github.com/user-attachments/assets/3cc08267-759a-4a44-a9fd-71a7b3fcd7fc" />

Figure 3: Block Diagram of AHB to APB Bridge

The bridge unit converts system bus transfers into APB transfers and performs the following functions:
 Latches the address and holds it valid throughout the transfer.
 Decodes the address and generates a peripheral select, PSELx. Only one select signal can be active during a transfer.
 Drives the data onto the APB for a write transfer.
 Drives the APB data onto the system bus for a read transfer.
 Generates a timing strobe, PENABLE, for the transfer

<img width="535" height="380" alt="image" src="https://github.com/user-attachments/assets/7ecfde4c-05c0-42ad-9b36-08aaa5b13c7f" />

Figure 4: Interfacing AHBtoAPB Read Transfer

<img width="576" height="336" alt="image" src="https://github.com/user-attachments/assets/3d2f44a7-c7b2-4af4-b553-50b6b22b6d12" />

Figure 5: Interfacing AHBtoAPB Write Transfer

**3. AHB (AMBA High-performance Bus)**
AMBA AHB is a bus interface suitable for high-performance synthesizable designs. It defines the interface between components, such as masters, interconnects, and slaves.
AMBA AHB implements the features required for high-performance, high clock frequency systems including:
• Burst transfers.
• Single clock-edge operation.
• Non-tristate implementation.
• Wide data bus configurations, 64, 128, 256, 512, and 1024 bits.
The most common AHB slaves are internal memory devices, external memory interfaces, and high-bandwidth peripherals. Although low-bandwidth peripherals can be included as AHB slaves, for system performance reasons, they typically reside on the AMBA Advanced Peripheral Bus (APB). Bridging between the higher performance AHB and APB is done using an AHB slave, known as an APB bridge.

<img width="725" height="405" alt="image" src="https://github.com/user-attachments/assets/6a2a4916-39d0-4965-a580-dc1fae394e7d" />

Figure 6: AHB Block Diagram

Above Figure shows a single master AHB system design with the AHB master and three AHB slaves. The bus interconnect logic consists of one address decoder and a slave-to-master multiplexor. The decoder monitors the address from the master so that the appropriate slave is selected and the multiplexor routes the corresponding slave output data back to the master. AHB also supports multimaster designs by the use of an interconnect component that provides arbitration and routing signals from different masters to the appropriate slaves.

**3.1 AHB Master Inteface :**
A master provides address and control information to initiate read and write operations. Figure 4 shows a master interface.

<img width="734" height="272" alt="image" src="https://github.com/user-attachments/assets/f7c5cb36-9544-4027-8b6d-05bc55364c29" />

Figure 7: AHB Master Interface

**3.2 AHB Slave Interface:**
A slave responds to transfers initiated by masters in the system. The slave uses the HSELx select signal from the decoder to control when it responds to a bus transfer.
The slave signals back to the master:
• The completion or extension of the bus transfer.
• The success or failure of the bus transfer.

<img width="782" height="413" alt="image" src="https://github.com/user-attachments/assets/b2d1ccfe-69ea-4d6a-a4c4-7bf18e6b5900" />

Figure 8: AHB Slave Interface

**4. APB (Advanced Peripheral Bus)**
The Advanced Peripheral Bus (APB) is part of the Advanced Microcontroller Bus Architecture (AMBA) protocol family. It defines a low-cost interface that is optimized for minimal power consumption and reduced interface complexity. The APB protocol is not pipelined, use it to connect to low-bandwidth peripherals that do not require the high performance of the AXI protocol. The APB protocol relates a signal transition to the rising edge of the clock, to simplify the integration of APB peripherals into any design flow. Every transfer takes at least two cycles.
The APB can interface with:
• AMBA Advanced High-performance Bus (AHB)
• AMBA Advanced High-performance Bus Lite (AHB-Lite)
• AMBA Advanced Extensible Interface (AXI)
• AMBA Advanced Extensible Interface Lite (AXI4-Lite)
You can use it to access the programmable control registers of peripheral devices.

<img width="754" height="315" alt="image" src="https://github.com/user-attachments/assets/0dcd4a7b-df59-40dd-b317-d1ad781e6d75" />


---

## Functional Goal

To transfer read/write transactions from the AHB bus to APB-compatible signals while maintaining correct timing and handshaking.

---
## 1️. AHB Interface Block

### **Purpose**

* To receive and decode AHB signals.
* To capture address, data, and control signals from AHB master.
* To signal readiness (HREADYOUT) and error status (HRESP).

### **Main Inputs from AHB Master**

| Signal         | Direction | Description                             |
| -------------- | --------- | --------------------------------------- |
| `HCLK`         | Input     | AHB clock                               |
| `HRESETn`      | Input     | Active-low reset                        |
| `HADDR[31:0]`  | Input     | Address bus                             |
| `HTRANS[1:0]`  | Input     | Transfer type (IDLE, BUSY, NONSEQ, SEQ) |
| `HWRITE`       | Input     | Write control (1 = write, 0 = read)     |
| `HWDATA[31:0]` | Input     | Write data from master                  |
| `HREADY`       | Input     | Indicates previous transfer done        |
| `HSEL`         | Input     | Bridge selected by decoder              |

### **Outputs**

| Signal         | Direction | Description                              |
| -------------- | --------- | ---------------------------------------- |
| `HRDATA[31:0]` | Output    | Data to AHB master during read           |
| `HREADYOUT`    | Output    | Indicates bridge ready for next transfer |
| `HRESP`        | Output    | Response signal (OKAY or ERROR)          |

### Sub-blocks inside AHB Interface

1. **Address Latch** — Captures `HADDR` when a valid transfer starts (`HTRANS[1]` = 1).
2. **Write Data Register** — Stores data from `HWDATA` for APB write phase.
3. **Control Decoder** — Decodes `HWRITE` and `HTRANS` to decide read/write cycle.

---

## Control Logic Block (Bridge Core FSM)

### Purpose

* Controls the sequence of APB operations (SETUP → ENABLE → IDLE).
* Manages AHB handshaking (HREADYOUT).
* Generates `PENABLE`, `PSEL`, `PWRITE`, etc.

### **FSM (Finite State Machine)**

```
       +--------+
       |  IDLE  |
       +--------+
           |
   Valid AHB Transfer
           |
           v
     +-----------+
     |  SETUP    |
     +-----------+
           |
      Next Clock
           |
           v
     +-----------+
     |  ENABLE   |
     +-----------+
           |
     Transfer Done
           |
           v
       +--------+
       |  IDLE  |
       +--------+
```

### FSM States

| State      | Description                    | Outputs                                                             |
| ---------- | ------------------------------ | ------------------------------------------------------------------- |
| **IDLE**   | Waiting for valid AHB transfer | `PSEL = 0`, `PENABLE = 0`, `HREADYOUT = 1`                          |
| **SETUP**  | Assert peripheral select       | `PSEL = 1`, `PENABLE = 0`                                           |
| **ENABLE** | Activate enable signal for APB | `PSEL = 1`, `PENABLE = 1`, `HREADYOUT = 0` until transfer completes |

---

## APB Interface Block

### Purpose

* Drive signals to APB slave devices.
* Convert control and data into APB-compatible signals.

### APB Signals Generated

| Signal         | Direction | Description                           |
| -------------- | --------- | ------------------------------------- |
| `PADDR[31:0]`  | Output    | Address for APB slave                 |
| `PWDATA[31:0]` | Output    | Write data to APB slave               |
| `PWRITE`       | Output    | Write/read control                    |
| `PSEL`         | Output    | Select line for the target peripheral |
| `PENABLE`      | Output    | Enable signal for transfer            |
| `PRDATA[31:0]` | Input     | Read data from APB slave              |
| `PREADY`       | Input     | Indicates APB slave ready             |
| `PSLVERR`      | Input     | Error indicator from APB slave        |

---

##  **Data Flow Summary**

| Step | Operation            | AHB Signals           | APB Signals          | FSM State |
| ---- | -------------------- | --------------------- | -------------------- | --------- |
| 1    | Bridge idle, waiting | HREADY=1              | PSEL=0               | IDLE      |
| 2    | AHB transfer starts  | HSEL=1, HTRANS=NONSEQ | PSEL=1               | SETUP     |
| 3    | APB setup phase      | HADDR, HWRITE latched | PADDR, PWRITE driven | SETUP     |
| 4    | APB enable phase     | -                     | PENABLE=1            | ENABLE    |
| 5    | Transfer done        | HREADYOUT=1           | PSEL=0               | IDLE      |

---

## **Timing Insight**

AHB is **pipelined**, while APB is **non-pipelined**.
So, the bridge must:

* Stall AHB (`HREADYOUT=0`) during APB transfer.
* Resume (`HREADYOUT=1`) once `PREADY=1`.

This ensures proper synchronization and data integrity.

---
## **Synthesis**
Tools Used: Quartus Prime (for synthesis & RTL Viewer), ModelSim (for simulation & waveform analysis).

<img width="1253" height="545" alt="image" src="https://github.com/user-attachments/assets/121c3876-0fbc-4ac8-adf1-0d9b3fd15a96" />

Figure 9 : RTL View of AHB to APB Bridge Design

The RTL architecture of the AHB to APB bridge is composed of three key blocks: the AHB slave interface, the bridge control logic and the APB controller. The AHB slave interface receives high-performance bus signals such as HADDR, HWDATA, HWRITE, and HTRANS, and translates them into intermediate control signals (valid, tempaddr, tempdata, tempwrite) via the bridge logic. This logic ensures proper handshake and timing alignment between the asynchronous AHB and APB domains. The APB controller then drives peripheral-level transactions using signals like PADDR, PWDATA, PWRITE, and PENABLE, while maintaining response integrity through HREADYOUT and HRESP. This modular RTL structure facilitates clean separation of protocol responsibilities and simplifies verification and synthesis.

<img width="1380" height="724" alt="image" src="https://github.com/user-attachments/assets/499e0ec0-5e75-42f9-affd-ff9649491504" />

Single Read Operation

<img width="1380" height="724" alt="image" src="https://github.com/user-attachments/assets/dc769236-0434-419d-895f-d380fa043bc5" />

Single Write Operation

---
## **Verification**

* Testbench applies AHB read/write cycles.
* Monitor APB signals to verify timing (SETUP → ENABLE).
* Check read/write data correctness with waveform (using ModelSim, Vivado, or GTKWave).

---

## **Summary of Blocks**

| Block         | Sub-Block                          | Function                         |
| ------------- | ---------------------------------- | -------------------------------- |
| AHB Interface | Address latch, Data latch, Decoder | Capture and decode AHB inputs    |
| Control Logic | FSM controller                     | Manage transfer phases           |
| APB Interface | Signal generator, Data driver      | Drive APB bus and capture PRDATA |

---
## **Conclusion**
The AHB to APB Bridge project successfully implements a protocol conversion interface using Verilog, enabling seamless communication between high-speed AHB and low-power APB buses. Through modular design and simulation in ModelSim, both read and write cycles were verified with correct signal transitions and FSM control. The project demonstrates practical understanding of AMBA protocols, RTL design, and waveform-based verification, forming a solid foundation for advanced SoC integration and IP-level communication.
