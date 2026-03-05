# Project Pipeline Overview

This document explains the repository's modular structure and the data flow between the extraction, processing, and modeling phases.

---

## Repository Workflow

The repository is organized into five sequential stages. Each folder represents a critical step in the Offline Reinforcement Learning pipeline.

### 1. Data Extraction (`01_extraction`)
* **Purpose**: Bridges the gap between the Google BigQuery cloud environment and this local repository.
* **Function**: Contains the SQL logic required to pull raw clinical data from the MIMIC-III database. It ensures that the raw features for vitals, labs, and treatments are extracted consistently.
* **Key Input**: Access to `physionet-data.mimiciii_clinical`.

### 2. Cohort Definition (`02_cohort`)
* **Purpose**: Clinical validation and filtering.
* **Function**: Processes the raw extraction into a standardized **Sepsis-3 cohort**. This stage handles the complex medical logic of identifying sepsis onset based on SOFA score progression and infection suspicion.
* **Output**: A cleaned list of patient stays that qualify for the RL study.

### 3. MDP Construction (`03_mdp`)
* **Purpose**: Translates clinical history into a Machine Learning-ready format.
* **Function**: Constructs the **Markov Decision Process (MDP)** tuples:
    * **State ($S$):** Aggregates 49 features into a unified vector.
    * **Action ($A$):** Maps IV Fluids and Vasopressors into a 25-bin discrete grid.
    * **Reward ($R$):** Calculates the feedback signal based on patient survival and physiological improvement.
* **Output**: Compressed NumPy files (`.npy`) used by the training scripts.

### 4. Model Architecture & Training (`04_models`)
* **Purpose**: The core engineering module.
* **Function**: Contains the deep learning architectures and the training logic:
    * **Behavior Policy**: Models how clinicians currently treat patients.
    * **D3QN Agent**: Implements the Dueling Double DQN logic with KL-Regularization to find the optimal treatment policy.
    * **Utils**: Provides data loading and batching utilities for the training loop.
* **Integration**: Uses `config.py` from the root directory for hyperparameter control.

### 5. Results & Evaluation (`05_results`)
* **Purpose**: Performance analysis and persistence.
* **Function**: This is the output destination for the pipeline. It stores trained model checkpoints, loss curves, and **Off-Policy Evaluation (OPE)** results to visualize the predicted improvement over standard clinical care.

---

## Inter-Module Dependencies

1. All modules in `04_models` and `05_results` import the central `config.py` to synchronize hyperparameters (e.g., `BETA_KL`, `GAMMA`) and architecture dimensions (`STATE_DIM`, `NUM_ACTIONS`).
2. The NumPy arrays produced in `03_mdp` are loaded directly via `utils.load_numpy_data()`. Instead of using heavy DataLoaders, the training loop utilizes `utils.get_batch()` to sample transitions and convert them to PyTorch tensors on-the-fly, significantly minimizing memory overhead.
3. The `DuelingDDQNAgent` requires a pre-trained `MlpBehaviorPolicy` (from `04_models`) to calculate the KL-divergence penalty during the reinforcement learning phase, ensuring clinical safety.

---

## Usage Instructions

To replicate the project, navigate through the folders in numeric order (`01` through `05`). Ensure your environment matches the `requirements.txt` in the root folder before starting the modeling phase.
