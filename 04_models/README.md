##04_models

Reinforcement Learning module for offline policy learning and evaluation on the constructed ICU Markov Decision Process (MDP).

This module implements a Dueling Double Deep Q-Network (DDQN) framework for retrospective clinical decision modeling in a fully offline reinforcement learning setting.

<b>Overview</b>

The goal of this module is to learn an optimal treatment policy from historical ICU trajectories without interacting with an environment. The implementation enforces modular separation between:

- Network architecture
- Agent optimization logic
- Behavior policy modeling
- Off-policy evaluation (OPE)
- Training orchestration




