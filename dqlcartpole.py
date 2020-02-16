import gym
from keras.models import Sequential
from collections import deque
from keras.layers import Dense
from keras.optimizers import Adam
import numpy as np
import random

class DQLAgent:
    def __init__(self,env):
        #hyperparameter and other parameter initiliazing
        self.state_size = env.observation_space.shape[0]
        self.action_size = env.action_space.n
        
        self.gamma = 0.95
        self.learning_rate = 0.001
        
        self.epsilon = 1 # at first, it will only explore
        self.epsilon_decay = 0.995
        self.epsilon_min = 0.01 # we keep a minimum epsilon value to secure 
                                #exploration chances
                                # in case it is really close to zero
        self.memory = deque(maxlen = 1000)
        self.model = self.build_model()
        
    def build_model(self):
        model = Sequential()
        model.add(Dense(48, input_dim = self.state_size, activation = "tanh"))
        model.add(Dense(self.action_size,activation = "linear"))
        model.compile(loss = "mse", optimizer = Adam(lr = self.learning_rate))
        return model
    
    def remember(self, state, action, reward, next_state, done):
        # storage
        self.memory.append((state, action, reward, next_state, done))
    
    def act(self,state):
        if (random.uniform(0,1) <= self.epsilon):
            return env.action_space.sample()
        else:
            act_values = self.model.predict(state)
            return np.argmax(act_values[0])
    
    def replay(self, batch_size):
        if(len(self.memory) < batch_size):
            return
        mini_batch = random.sample(self.memory,batch_size)
        for state, action, reward, next_state, done in mini_batch:
            if done:
                target = reward 
            else:
                target = reward + self.gamma*np.amax(self.model.predict(next_state)[0])
            train_target = self.model.predict(state)
            train_target[0][action] = target
            self.model.fit(state, train_target, verbose = 0)
            
    def adaptive_epsilon_greedy(self):
        if (self.epsilon > self.epsilon_min):
            self.epsilon *= self.epsilon_decay
    
if __name__ == "__main__":
    #initiliaze env and agent
    env = gym.make("CartPole-v0")
    agent = DQLAgent(env)
    episodes = 60
    batch_size = 16
    for episode in range(episodes):
        #initiliaze env
        state = env.reset()
        time = 0
        state = np.reshape(state, [1,4])
        while True:
            
            #act
            action = agent.act(state)
            
            #step
            next_state, reward, done, info = env.step(action)
            next_state = np.reshape(next_state, [1,4])
            
            #remember / storage
            agent.remember(state, action, reward, next_state, done)
            
            #update state
            state = next_state
            
            #replay
            agent.replay(batch_size)
            
            #epsilon adjusting
            agent.adaptive_epsilon_greedy()
            #done?
            
            time += 1
            if done:
                print("Episode: {}, Time: {}".format(episode, time))
                break
    
import time
trained_model = agent
state = env.reset()
state = np.reshape(state, [1,4])
time_t = 0
while True:
    env.render()
    action = trained_model.act(state)
    next_state, reward, done, info = env.step(action)
    next_state = np.reshape(next_state, [1,4])
    state = next_state
    time_t += 1
    print(time_t)
    time.sleep(0.4)
    if done:
        break

