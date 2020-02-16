import matplotlib.pyplot as plt
import gym
import pandas as pd
import numpy as np
import random

env = gym.make("Taxi-v3").env

#Q Table
q_table = np.zeros((env.observation_space.n, env.action_space.n))

#Hyper Parameter
alpha = 0.1
gamma = 0.9
epsilon = 0.1

#Gorsellestirme
reward_list = []
dropout_list = []


episode_number = 10000

for i in range(1, episode_number):
    #initiliaze environment
    state = env.reset()
    reward_count = 0
    dropouts = 0
    
    while True:
        #exploit vs explore to find action
        if(random.uniform(0,1) < epsilon):
            action = env.action_space.sample()
        else:
            action = np.argmax(q_table[state])
        
        #action and get reward
        next_state, reward, done, info = env.step(action)
        
        #Old value
        old_value = q_table[state, action]
        
        #Next max
        next_max = np.max(q_table[next_state])
        
        #Q learning function
        next_value = (1-alpha) * old_value + alpha * (reward + gamma * next_max)
        
        #Q learning update
        q_table[state, action] = next_value
        
        #Update state
        state = next_state
        
        #find wrong dropouts
        if reward == -10:
            dropouts += 1
        
        if done:        
            break
        
        reward_count += reward
    if(i % 10 == 0):
        #env.render()
        dropout_list.append(dropouts)
        reward_list.append(reward_count)
        print("Episode: {}, Reward: {}, Dropout: {}".format(i, reward_count, dropouts))
        
#görsellestirme
fig, axs = plt.subplots(1, 2)        
axs[0].plot(reward_list)
axs[0].set_xlabel("episode")
axs[0].set_ylabel("reward")
axs[0].grid(True)


axs[1].plot(dropout_list)
axs[1].set_xlabel("episode")
axs[1].set_ylabel("dropouts")
axs[1].grid(True)

plt.show()