import matplotlib.pyplot as plt
import gym
import pandas as pd
import numpy as np
import random

env = gym.make("FrozenLake-v0").env

#Eger deterministic ogrenme istenirse, alttaki kodlar yorum satırına alınmalıdır.
'''
from gym.envs.registration import register
register(id ='FrozenLakeNotSlippery-v0',
         entry_point = 'gym.envs.toy_text:FrozenLakeEnv',
         kwargs={'map_name': '4x4', 'is_slippery': False},
         max_episode_steps = 100,
         reward_threshold = 0.78)

q_table = np.zeros((env.observation_space.n, env.action_space.n))
'''

#Hyper Parameter
alpha = 0.3
gamma = 0.95
epsilon = 0.3

#Gorsellestirme
reward_list = []
dropout_list = []


episode_number = 20000

for i in range(1, episode_number):
    #initiliaze environment
    state = env.reset()
    
    reward_count = 0
    
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
        
        if done:        
            break
        reward_count += reward
        
    if(i % 10 == 0):
        reward_list.append(reward_count)
        print("Episode: {}, Reward: {}".format(i, reward_count))
        
#görsellestirme
plt.plot(reward_list)
