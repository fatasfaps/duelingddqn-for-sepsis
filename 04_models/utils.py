import numpy as np
import torch

def load_numpy_data(path):
    data = np.load(path, allow_pickle=True)
    return data

def get_batch(data, batch_size):
    idx = np.random.choice(len(data), batch_size)
    batch = data[idx]
    return [torch.tensor(x, dtype=torch.float32) for x in batch]
