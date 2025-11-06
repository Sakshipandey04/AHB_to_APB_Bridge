# AHB_to_APB_Bridge

## **Overview: AHB to APB Bridge**

The **AHB-to-APB Bridge** is an essential component in the **AMBA (Advanced Microcontroller Bus Architecture)** system.
It connects:

* **AHB (Advanced High-performance Bus)** — used for **high-speed** communication (e.g., CPU, DMA, memory)
* **APB (Advanced Peripheral Bus)** — used for **low-power, low-speed peripherals** (e.g., UART, GPIO, timers)

Because AHB and APB have **different protocols and timing requirements**, the bridge performs **protocol conversion**.

---

## **Functional Goal**

To transfer read/write transactions from the AHB bus to APB-compatible signals while maintaining correct timing and handshaking.

---

## **Top-Level Architecture**

The bridge consists of :
<img width="649" height="272" alt="image" src="https://github.com/user-attachments/assets/e76c6c94-4fb8-4a88-b948-6277920fe7d4" />


Let’s now go deeper into each block �

---

## 1️ **AHB Interface Block**

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

### **Sub-blocks inside AHB Interface**

1. **Address Latch** — Captures `HADDR` when a valid transfer starts (`HTRANS[1]` = 1).
2. **Write Data Register** — Stores data from `HWDATA` for APB write phase.
3. **Control Decoder** — Decodes `HWRITE` and `HTRANS` to decide read/write cycle.

---

## **Control Logic Block (Bridge Core FSM)**

### **Purpose**

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

### **FSM States**

| State      | Description                    | Outputs                                                             |
| ---------- | ------------------------------ | ------------------------------------------------------------------- |
| **IDLE**   | Waiting for valid AHB transfer | `PSEL = 0`, `PENABLE = 0`, `HREADYOUT = 1`                          |
| **SETUP**  | Assert peripheral select       | `PSEL = 1`, `PENABLE = 0`                                           |
| **ENABLE** | Activate enable signal for APB | `PSEL = 1`, `PENABLE = 1`, `HREADYOUT = 0` until transfer completes |

---

##  **APB Interface Block**

### **Purpose**

* Drive signals to APB slave devices.
* Convert control and data into APB-compatible signals.

### **APB Signals Generated**

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

## ⚙️ **Data Flow Summary**

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
