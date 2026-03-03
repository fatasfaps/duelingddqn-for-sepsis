import torch

def ope_wis(rewards, weights):
    weights = weights / (weights.sum() + 1e-8)
    return (weights * rewards).sum().item()

def ope_wdr(rewards, weights, q_values, v_values):
    weights = weights / (weights.sum() + 1e-8)
    correction = q_values - v_values
    return (weights * (rewards + correction)).sum().item()

def ope_fqe(q_net, dataset, gamma=0.99):
    total = 0
    with torch.no_grad():
        for states, _, rewards, _, _ in dataset:
            q = q_net(states)
            v = q.max(dim=1)[0]
            total += rewards + gamma * v
    return total.mean().item()
