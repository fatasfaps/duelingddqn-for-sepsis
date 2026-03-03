import torch
import torch.nn as nn
import torch.nn.functional as F


class DuelingQNetwork(nn.Module):
    def __init__(self, state_dim, num_actions, hidden_dim=256):
        super(DuelingQNetwork, self).__init__()

        self.feature = nn.Sequential(
            nn.Linear(state_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, hidden_dim),
            nn.ReLU(),
        )

        # Value stream
        self.value_stream = nn.Sequential(
            nn.Linear(hidden_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, 1),
        )

        # Advantage stream
        self.advantage_stream = nn.Sequential(
            nn.Linear(hidden_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, num_actions),
        )

    def forward(self, x):
        features = self.feature(x)

        value = self.value_stream(features)
        advantage = self.advantage_stream(features)

        q_values = value + advantage - advantage.mean(dim=1, keepdim=True)
        return q_values
