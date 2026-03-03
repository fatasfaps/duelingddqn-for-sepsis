## 04_models

Reinforcement Learning module for offline policy learning and evaluation on the constructed ICU Markov Decision Process (MDP).

This module implements a Dueling Double Deep Q-Network (DDQN) framework for retrospective clinical decision modeling in a fully offline reinforcement learning setting.

Overview

The goal of this module is to learn an optimal treatment policy from historical ICU trajectories without interacting with an environment. The implementation enforces modular separation between:

- Network architecture
- Agent optimization logic
- Behavior policy modeling
- Off-policy evaluation (OPE)
- Training orchestration

This structure improves reproducibility, interpretability, and extensibility for future methodological extensions.

Directory Structure
04_models/
├── networks.py
├── agent.py
├── behavior_policy.py
├── ope.py
├── trainer.py
└── train.py
