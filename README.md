# Offline Reinforcement Learning for Sepsis Management: A Dueling Double Deep Q-Network Approach

[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)

This repository contains the implementation of my bachelor’s thesis defense project. It develops a clinical decision support system using **MIMIC-III v1.4** to optimize IV fluid and vasopressor administration for septic patients through a **Dueling Double Deep Q-Network (DDQN)** framework.

## Project Overview

Sepsis treatment requires precise, dynamic interventions. This project models the clinical decision-making process as a Markov Decision Process (MDP) and applies **Offline Reinforcement Learning** to learn optimal policies from historical ICU data. Unlike traditional RL, this approach does not require a simulator, learning instead from fixed clinician trajectories.

---

## Repository Structure

The project is organized into modular stages, following the end-to-end pipeline of clinical AI research:

* **`00_docs/`**: High-level documentation and [pipeline_overview.md](00_docs/pipeline_overview.md).
* **`01_extraction/`**: SQL queries and notebooks for [MIMIC-III v1.4 extraction](01_extraction/full_extraction_reference.ipynb).
* **`02_cohort/`**: Definition of the [Sepsis-3 cohort](02_cohort/sepsis3.md) and data cleaning.
* **`03_mdp/`**: MDP construction including [State, Action, and Reward design](03_mdp/mdp.md).
* **`04_models/`**: Core RL module containing the [Dueling DDQN agent](04_models/README.md), behavior modeling, and OPE logic.
* **`05_results/`**: Training logs and [summary of findings](05_results/summary.md).

---

## Technical Highlights

### 1. Offline RL Framework
The system is designed to handle the constraints of clinical data:
* **Double Q-Learning:** Used to mitigate overestimation bias in value functions.
* **Dueling Architecture:** Decouples state value $V(s)$ and advantage $A(s, a)$ to better assess state importance in sparse-reward environments.
* **Behavior Regularization:** Optional KL-divergence term to constrain the learned policy $\pi$ near the clinician's behavior policy $\pi_b$.

### 2. Off-Policy Evaluation (OPE)
Since live interaction is impossible, we utilize statistical estimators to validate the policy:
* Importance Sampling (IS) and Doubly Robust (DR) estimation.
* Benchmarking AI-recommended policies against the clinicians' historical performance.

---

## Getting Started

1. **Extraction:** Use the SQL scripts in `01_extraction` to pull data from a PostgreSQL instance of MIMIC-III.
2. **Cohort & MDP:** Run the notebooks in `02_cohort` and `03_mdp` sequentially to generate the transition matrix.
3. **Training:**
   ```bash
   cd 04_models
   python train.py

---

## Acknowledgments & Credits

This project builds upon the foundational work of Dr Matthieu Komorowski, Imperial College London (2019) regarding the "AI Clinician." Specifically, the data extraction logic in `01_extraction/` and cohort definition in `02_cohort/` are modified versions of the original [AI Clinician repository](https://github.com/matthieukomorowski/AI_Clinician).


---
## Disclaimer 
> [!IMPORTANT]
> **Research Use Only:** This project is intended for retrospective research and sensitivity analysis in clinical AI. It is **not** a diagnostic tool and is not intended for real-time clinical deployment.
> 
> This code is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.
