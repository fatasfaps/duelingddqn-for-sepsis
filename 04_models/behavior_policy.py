import torch
import torch.nn as nn
import torch.nn.functional as F

class MlpBehaviorPolicy(nn.Module):
    def __init__(self, state_dim, action_dim, hidden_dim=128):
        super().__init__()

        self.model = nn.Sequential(
            nn.Linear(state_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, action_dim)
        )

    def forward(self, x):
        logits = self.model(x)
        return F.softmax(logits, dim=-1)

def behavior_prob(policy, states, actions):
    probs = policy(states)
    return probs.gather(1, actions.unsqueeze(1)).squeeze(1)
