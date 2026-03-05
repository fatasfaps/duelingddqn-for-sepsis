# 04_models: Offline Reinforcement Learning Module

This directory contains the core Reinforcement Learning (RL) implementation for offline policy learning and evaluation, specifically optimized for the constructed ICU Markov Decision Process (MDP) in sepsis management.

The module implements a **Dueling Double Deep Q-Network (DDQN)** framework designed for retrospective clinical decision modeling in a strictly offline RL setting.

## Overview

The primary goal of this module is to derive an optimal treatment policy from historical ICU trajectories without the need for a live environment or simulators. To ensure reproducibility and maintainability, the implementation follows a modular design:

* **Network Architecture:** Defines the Dueling Q-network structures.
* **Agent Logic:** Implements the optimization logic and DDQN update rules.
* **Behavior Policy Modeling:** Estimates the clinician's original policy ($\pi_b$) to guide the offline agent.
* **Off-Policy Evaluation (OPE):** Robust statistical validation of the learned policy using historical data.
* **Training Orchestration:** Handlers for the training loops and hyperparameter scheduling.

---

## Architecture

The learning agent utilizes a **Dueling Double DQN** architecture to mitigate common challenges in clinical RL:

1.  **Double Q-learning:** Reduces the inherent overestimation bias of Q-values in high-dimensional state spaces.
2.  **Dueling Architecture:** Decouples the **State Value** $V(s)$ and **Action Advantage** $A(s, a)$ streams. This allows the model to learn which states are fundamentally valuable without necessarily needing to learn the effect of every individual action at every step.
3.  **Fully Offline Training:** All learning is constrained to a fixed replay buffer, preventing distributional shift issues common in online-to-offline transitions.

---

## KL Regularization (Experimental)

Inside `agent.py`, an optional **Kullback–Leibler (KL) Regularization** term is implemented to stabilize learning. The total loss function is defined as:

$$L_{total} = L_{TD} + \beta_{KL} \cdot KL(\pi(\cdot|s) \| \pi_b(\cdot|s))$$

This term was introduced to:
* **Encourage Policy Stability:** Keeping the learned policy $\pi$ within a reasonable "trust region" of the clinician's behavior policy $\pi_b$.
* **Reduce Extrapolation Error:** Constraining the agent from taking actions that are poorly represented in the training data.

> **Note:** This regularizer is optional. By setting $\beta_{KL} = 0$, the system recovers standard DDQN behavior. It is primarily used for sensitivity analysis and does not fundamentally alter the learning objective.

---

## Offline Learning Setup

* **No Environment Interaction:** Training is strictly retrospective.
* **Policy Constraints:** The agent learns exclusively from the historical ICU transition matrix.
* **Independent Evaluation:** Policy performance is validated via the OPE module using methods such as Importance Sampling and Doubly Robust estimators.

## Intended Use & Limitations

* **Research Focus:** This module is intended for retrospective treatment policy modeling and sensitivity analysis.
* **Clinical Constraints:** Designed to handle the high-stakes, sparse-reward nature of ICU data.
* **Deployment:** This is an experimental research tool and is **not intended for real-time clinical deployment** without extensive external validation and clinical oversight.


