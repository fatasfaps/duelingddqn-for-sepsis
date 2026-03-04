import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import copy

from .networks import DuelingQNetwork


class DuelingDDQNAgent:
    def __init__(
        self,
        state_dim,
        num_actions,
        device,
        gamma=0.99,
        lr=1e-4,
        tau=0.005,
        temperature=1.0,
        lambda1=0.0,
        lambda2=0.0,
        beta_kl=0.0,
    ):
        self.device = device
        self.gamma = gamma
        self.tau = tau
        self.temperature = temperature

        self.lambda1 = lambda1
        self.lambda2 = lambda2
        self.beta_kl = beta_kl

        self.num_actions = num_actions

        # Q Networks
        self.q_net = DuelingQNetwork(state_dim, num_actions).to(device)
        self.target_q_net = copy.deepcopy(self.q_net).to(device)

        self.optimizer = optim.Adam(self.q_net.parameters(), lr=lr)

    # -------------------------------------------------
    # Polyak Target Update
    # -------------------------------------------------
    def polyak_target_update(self):
        for target_param, param in zip(
            self.target_q_net.parameters(), self.q_net.parameters()
        ):
            target_param.data.copy_(
                self.tau * param.data + (1 - self.tau) * target_param.data
            )

    # -------------------------------------------------
    # Clinical Penalties (Placeholder — pakai punyamu)
    # -------------------------------------------------
    def compute_q_threshold_penalty(self, Q_eval):
        return torch.tensor(0.0, device=self.device)

    def compute_vasopressor_penalty(self, Q_eval):
        return torch.tensor(0.0, device=self.device)

    # -------------------------------------------------
    # Compute Loss
    # -------------------------------------------------
    def compute_loss(self, batch, get_behavior_prob, model, scaler):
        state, action, reward, next_state, done = batch

        # =========================
        # 1. TD LOSS (Double DQN)
        # =========================
        Q_eval = self.q_net(state)
        Q_predicted = Q_eval.gather(1, action.long())

        with torch.no_grad():
            next_Q_eval = self.q_net(next_state)
            next_actions = torch.argmax(next_Q_eval, dim=1, keepdim=True)

            next_Q_target = self.target_q_net(next_state)
            Q_next = next_Q_target.gather(1, next_actions)

            TD_target = reward + (1 - done) * self.gamma * Q_next

        td_loss = F.mse_loss(Q_predicted, TD_target)

        # =========================
        # 2. Clinical Penalties
        # =========================
        penalty_q_thresh = self.compute_q_threshold_penalty(Q_eval)
        penalty_vasopressor = self.compute_vasopressor_penalty(Q_eval)

        # =========================
        # 3. KL Regularization
        # =========================
        # --- Target Policy π(a|s)
        log_pi = F.log_softmax(Q_eval / self.temperature, dim=1)
        pi = torch.exp(log_pi)
    
        # --- Behavior Policy b(a|s)
        state_np = state.detach().cpu().numpy()
        b_prob_np = get_behavior_prob(state_np, self.num_actions, model, scaler)
    
        b_prob = torch.tensor(
            b_prob_np, dtype=torch.float32, device=state.device
        )
    
        b_prob = torch.clamp(b_prob, min=1e-8)
        log_b = torch.log(b_prob)
    
        # --- KL(π || b)
        KL_loss = torch.sum(pi * (log_pi - log_b), dim=1).mean()

        # =========================
        # 4. Total Loss
        # =========================
        total_loss = (
            td_loss
            + self.lambda1 * penalty_q_thresh
            + self.lambda2 * penalty_vasopressor
            + self.beta_kl * KL_loss
        )

        return (
            total_loss,
            td_loss,
            penalty_q_thresh,
            penalty_vasopressor,
            KL_loss.item(),
            Q_predicted.mean(),
            TD_target.mean(),
        )
