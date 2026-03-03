import torch
from tqdm import tqdm

def train_agent(agent, dataloader, epochs):

    losses = []

    for _ in tqdm(range(epochs)):
        for batch in dataloader:
            batch = [b for b in batch]
            loss = agent.update(batch)
            losses.append(loss)

    return losses
