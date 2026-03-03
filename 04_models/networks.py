import torch
import torch.nn as nn
import torch.nn.functional as F

class DuelingQNetwork(nn.Module):
    def __init__(self, state_dim, n_actions):
        super(DuelingQNetwork, self).__init__()

        self.feature_layer = nn.Sequential(
            nn.Linear(state_dim, 384),
            nn.ReLU(),
            nn.Linear(384, 256),
            nn.ReLU()
        )

        self.value_stream = nn.Sequential(
            nn.Linear(256, 128),
            nn.ReLU(),
            nn.Linear(128, 1)
        )

        self.advantage_stream = nn.Sequential(
            nn.Linear(256, 128),
            nn.ReLU(),
            nn.Linear(128, n_actions)
        )

    def forward(self, state):
        features = self.feature_layer(state)
        value = self.value_stream(features)
        advantage = self.advantage_stream(features)
        mean_advantage = advantage.mean(dim=1, keepdim=True)
        Q_values = value + advantage - mean_advantage
        return Q_values
