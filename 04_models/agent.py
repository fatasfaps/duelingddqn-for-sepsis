import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
import copy
from .networks import DuelingQNetwork

class DuelingDDQN:
    def __init__(self, state_dim, action_dim, lr=1e-3, gamma=0.99, tau=0.005):

        self.q_net = DuelingQNetwork(state_dim, action_dim)
        self.target_net = copy.deepcopy(self.q_net)

        self.optimizer = optim.Adam(self.q_net.parameters(), lr=lr)

        self.gamma = gamma
        self.tau = tau
        self.action_dim = action_dim

    def get_action(self, state):
        with torch.no_grad():
            q_values = self.q_net(state)
        return q_values.argmax(dim=1)

    def compute_loss(self, batch):

        states, actions, rewards, next_states, dones = batch

        q_values = self.q_net(states)
        q_value = q_values.gather(1, actions.unsqueeze(1)).squeeze(1)

        with torch.no_grad():
            next_actions = self.q_net(next_states).argmax(dim=1)
            next_q = self.target_net(next_states)
            next_q_value = next_q.gather(1, next_actions.unsqueeze(1)).squeeze(1)

            target = rewards + self.gamma * (1 - dones) * next_q_value

        loss = F.mse_loss(q_value, target)
        return loss

    def update(self, batch):
        loss = self.compute_loss(batch)

        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()

        self.polyak_target_update()

        return loss.item()

    def polyak_target_update(self):
        for param, target_param in zip(self.q_net.parameters(),
                                       self.target_net.parameters()):
            target_param.data.copy_(
                self.tau * param.data + (1 - self.tau) * target_param.data
            )

