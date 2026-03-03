import torch
from tqdm import tqdm


def train_agent(
    agent,
    train_data,
    epochs,
    batch_size,
    device,
    get_behavior_prob,
    model,
    scaler,
    get_batch,
):

    states, actions, rewards, next_states, dones = train_data
    N_trans = len(states)
    steps_per_epoch = N_trans // batch_size

    total_loss_history = []
    mean_q_history = []
    kl_loss_history = []

    print("\n--- Training Dueling DDQN ---")
    print(f"Epochs: {epochs} | Steps/Epoch: {steps_per_epoch}")

    for epoch in range(1, epochs + 1):
        epoch_total_loss = 0.0
        epoch_td_loss = 0.0
        epoch_mean_Q = 0.0
        epoch_kl_loss = 0.0

        pbar = tqdm(range(steps_per_epoch), leave=False)

        for _ in pbar:
            batch = get_batch(
                states,
                actions,
                rewards,
                next_states,
                dones,
                batch_size,
                device,
            )

            (
                total_loss,
                td_loss,
                penalty_q_thresh,
                penalty_vasopressor,
                kl_loss,
                mean_Q,
                mean_Y,
            ) = agent.compute_loss(
                batch,
                get_behavior_prob,
                model,
                scaler,
            )

            agent.optimizer.zero_grad()
            total_loss.backward()
            agent.optimizer.step()

            agent.polyak_target_update()

            epoch_total_loss += total_loss.item()
            epoch_td_loss += td_loss.item()
            epoch_mean_Q += mean_Q.item()
            epoch_kl_loss += kl_loss

        avg_total_loss = epoch_total_loss / steps_per_epoch
        avg_td_loss = epoch_td_loss / steps_per_epoch
        avg_mean_Q = epoch_mean_Q / steps_per_epoch
        avg_kl_loss = epoch_kl_loss / steps_per_epoch

        total_loss_history.append(avg_total_loss)
        mean_q_history.append(avg_mean_Q)
        kl_loss_history.append(avg_kl_loss)

        print(
            f"[Epoch {epoch}] "
            f"Total: {avg_total_loss:.6f} | "
            f"TD: {avg_td_loss:.6f} | "
            f"KL: {avg_kl_loss:.6f} | "
            f"Mean Q: {avg_mean_Q:.4f}"
        )

    print("Training Complete.")

    return agent, total_loss_history, mean_q_history, kl_loss_history
