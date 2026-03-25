This repository contains the simulation code and dataset used in the research paper:

**"Multi-Objective Sizing and Performance Optimization of Islanded Hybrid Renewable Microgrids: A Case Study in Yanbu, Saudi Arabia"**

Author: Ayat Ali Saleh and Gaber Magdy


##  Overview
Hybrid microgrid systems (HMS) integrating renewable energy sources (RESs) provide a sustainable solution for residential electrification in remote and arid regions. However, optimal sizing remains a complex challenge due to trade-offs between reliability, cost, and renewable energy penetration.

This work proposes a **multi-objective optimization framework** for the techno-economic design of a hybrid microgrid system consisting of:
- Solar Photovoltaic (PV)
- Wind Turbine (WT)
- Diesel Generator (DG)
- Battery Energy Storage System (BESS)

The system is designed for residential communities in **Yanbu, Saudi Arabia**, and evaluated under different load conditions.


## Objectives
The optimization framework aims to:
- Minimize:
  - Loss of Power Supply Probability (LPSP)
  - Cost of Energy (COE)
- Maximize:
  - Renewable Fraction (RF)


##  Optimization Algorithms
Two advanced metaheuristic algorithms are implemented and compared:
- Multi-Objective Salp Swarm Algorithm (MOSSA)
- Multi-Objective Whale Optimization Algorithm (MOWOA)


##  Energy Management Strategy
A **rule-based energy management system (EMS)** is integrated to ensure:
- Reliable operation  
- Efficient coordination between generation units and storage


## Load Scenarios
The system is evaluated under three residential scenarios:
- 5 houses (light load)
- 10 houses (medium load)
- 15 houses (heavy load)

How to Run
1. Open the main script (`main.m`)  
2. Select the load scenario (5, 10, or 15 houses)  
3. Run the simulation  
