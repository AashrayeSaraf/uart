# 🧩 UART (Verilog + ZedBoard)

## 📘 Overview
A Verilog-based **Universal Asynchronous Receiver and Transmitter (UART)** implemented and tested on the **ZedBoard (Zynq-7000)**.  
Includes simulation and hardware results demonstrating serial communication between TX and RX modules.

---

## ⚙️ Features
- UART Transmitter & Receiver in Verilog  
- Baud rate generator  
- Testbench simulation (Vivado)  
- FPGA implementation on ZedBoard 
- Verified via serial terminal output  

---

## 📁 Structure
```

UART/  
├── src/        # Verilog source files  
├── sim/        # Testbench & simulation results  
├── zedboard/   # Bitstream & terminal outputs  
├── docs/       # Images & diagrams  
└── README.md  

````

---

## 🧩 Working
- **TX** sends 8-bit data serially  
- **RX** receives and reconstructs data  
- Frame: `Start bit | 8 Data bits | Stop bit`  
- Baud Rate Example: **115200 bps**

---

📸 *Example:*
[Simulation Result](d[ocs/simulation_result.png](https://drive.google.com/file/d/1IuUURbPu7UZskYqP_-DoMlwvmX3PHMPN/view?usp=sharing))

---

## 💻 ZedBoard Test

1. Program FPGA with bitstream
2. Connect USB-UART & open terminal (115200 8N1)
3. Observe transmitted data on serial monitor


## 🧰 Tools

* Verilog HDL
* Xilinx Vivado / Xilinx Vitis
* ZedBoard (Zynq-7000)
* Serial Terminal (TeraTerm)

---

## 👤 Author

**Aashraye Saraf**
[GitHub](https://github.com/AashrayeSaraf)  

**Aishani Sinha**
[GitHub](https://github.com/AISHANI817) 

---

