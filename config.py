# =========================
# Environment / Data
# =========================
STATE_DIM = 49
NUM_ACTIONS = 25

# =========================
# RL Hyperparameters
# =========================
GAMMA = 0.99
LR = 1e-4
TAU = 0.005

TEMPERATURE = 0.5

# =========================
# Regularization
# =========================
LAMBDA1 = 0.1
LAMBDA2 = 0.05
BETA_KL = 0.001

# =========================
# Training
# =========================
EPOCHS = 100
BATCH_SIZE = 256
