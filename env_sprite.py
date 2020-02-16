import pygame
import random
from keras.models import Sequential
from collections import deque
from keras.layers import Dense
from keras.optimizers import Adam
import numpy as np

width = 360
height = 360
fps = 30

#colours
white = (255, 255, 255)
black = (0, 0, 0)
red = (255, 0, 0)
green = (0, 255, 0)
blue = (0, 0, 255)
background_colour = (148, 0, 211)

class DQLAgent:
    def __init__(self):
        #hyperparameter and other parameter initiliazing
        self.state_size = 4 #distances between px-ex1, py-ey1, px-ex2, py-ey2
        self.action_size = 3 #right, left, stay put
        
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
        model.add(Dense(48, input_dim = self.state_size, activation = "relu"))
        model.add(Dense(self.action_size,activation = "linear"))
        model.compile(loss = "mse", optimizer = Adam(lr = self.learning_rate))
        return model
    
    def remember(self, state, action, reward, next_state, done):
        # storage
        self.memory.append((state, action, reward, next_state, done))
    
    def act(self,state):
        state = np.array(state)
        if (np.random.rand() <= self.epsilon):
            return random.randrange(self.action_size)
        act_values = self.model.predict(state)
        return np.argmax(act_values[0])
    
    def replay(self, batch_size):
        if(len(self.memory) < batch_size):
            return
        mini_batch = random.sample(self.memory,batch_size)
        for state, action, reward, next_state, done in mini_batch:
            state = np.array(state)
            next_state = np.array(next_state)
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
    

class Player(pygame.sprite.Sprite):
    
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((20,20))
        self.image.fill(black)
        self.rect = self.image.get_rect()
        self.radius = 10
        pygame.draw.circle(self.image, red, self.rect.center, self.radius)
        self.rect.centerx = width/2
        self.rect.bottom = height - 1
        self.x_speed = 5
    
    def update(self, action):
        self.x_speed = 0
        key_state = pygame.key.get_pressed()
        
        if(key_state[pygame.K_LEFT] or action == 0):
            self.x_speed = -4
        elif(key_state[pygame.K_RIGHT] or action == 1):
            self.x_speed = 4
        else:
            self.x_speed = 0
        self.rect.x += self.x_speed
        if(self.rect.right > width):
            self.rect.right = width
        if(self.rect.left < 0):
            self.rect.left = 0
    def getCoordinates(self):
        return (self.rect.x, self.rect.y)
    
class Enemy(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((10,10))
        self.image.fill(blue)
        self.rect = self.image.get_rect()
        self.radius = 5
        pygame.draw.circle(self.image, red, self.rect.center, self.radius)
        self.rect.x = random.randrange(0, width - self.rect.width)
        self.rect.y = random.randrange(0, 10)
        self.x_speed = 0
        self.y_speed = 2
    
    def update(self):
        self.rect.x += self.x_speed
        self.rect.y += self.y_speed
        
        if(self.rect.y > height + self.rect.height):
            self.rect.x = random.randrange(0, width - self.rect.width)
            self.rect.y = random.randrange(0, 10)
            
    def getCoordinates(self):
        return (self.rect.x, self.rect.y)
        
    
class Environment(pygame.sprite.Sprite):
    
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.all_sprite = pygame.sprite.Group()
        self.player = Player()
        self.enemy = pygame.sprite.Group()
        self.enemy1 = Enemy()
        self.enemy2 = Enemy()
        self.all_sprite.add(self.player, self.enemy1, self.enemy2)
        self.enemy.add(self.enemy1, self.enemy2)
        
        self.reward = 0
        self.done = False
        self.total_reward = 0
        self.agent = DQLAgent()
        
    def findDistance(self, a, b):
        distance = a - b
        return distance
    def step(self, action):
        state_list = []
        
        #update
        self.player.update(action)
        self.enemy.update()
        
        #get coordinates
        next_player_state = self.player.getCoordinates()
        next_enemy1_state = self.enemy1.getCoordinates()
        next_enemy2_state = self.enemy2.getCoordinates()
        
        #find distance
        state_list.append(self.findDistance(next_player_state[0], next_enemy1_state[0]))
        state_list.append(self.findDistance(next_player_state[1], next_enemy1_state[1]))
        state_list.append(self.findDistance(next_player_state[0], next_enemy2_state[0]))
        state_list.append(self.findDistance(next_player_state[1], next_enemy2_state[1]))
        
        return [state_list]

    #whenever an episode ends, we reset the environment
    def initialStates(self):
        self.all_sprite = pygame.sprite.Group()
        self.player = Player()
        self.enemy = pygame.sprite.Group()
        self.enemy1 = Enemy()
        self.enemy2 = Enemy()
        self.all_sprite.add(self.player, self.enemy1, self.enemy2)
        self.enemy.add(self.enemy1, self.enemy2)
        
        self.reward = 0
        self.done = False
        self.total_reward = 0
        
        state_list = []
        player_state = self.player.getCoordinates()
        enemy1_state = self.enemy1.getCoordinates()
        enemy2_state = self.enemy2.getCoordinates()
        
        state_list.append(self.findDistance(player_state[0], enemy1_state[0]))
        state_list.append(self.findDistance(player_state[1], enemy1_state[1]))
        state_list.append(self.findDistance(player_state[0], enemy2_state[0]))
        state_list.append(self.findDistance(player_state[1], enemy2_state[1]))
        
    def run(self):
        running = True
        state = self.initialStates()
        batch_size = 24
        while running:
            
            #keeping a constant loop 
            clock.tick(fps)
            
            #process input
            for event in pygame.event.get():
                if(event.type == pygame.QUIT):
                    running = False
                    
            #update
            action = self.agent.act(state)
            next_state = self.step(action)
            self.total_reward += self.reward 
            
            
            hits = pygame.sprite.spritecollide(self.player, self.enemy, False, pygame.sprite.collide_circle)
            if(hits):
                self.reward -= 150
                self.total_reward += self.reward
                done = True
                running = False
                print("Total Reward: ", self.total_reward)
            
            #storage
            self.agent.remember(state, action, self.reward, next_state, self.done)
            
            #update state
            state = next_state
            self.agent.replay(batch_size)
            
            #epsilon greedy
            self.agent.adaptive_epsilon_greedy()
            
            screen.fill(background_colour)
            self.all_sprite.draw(screen)
            self.enemy.draw(screen)
            pygame.display.flip()
        
        pygame.quit()
        
if (__name__ == "__main__"):
    env = Environment()
    liste = []
    t = 0
    while True:
        t += 1
        print("Episode: ", t)
        liste.append(env.total_reward)
        
        #initiliaze pygame 
        pygame.init()
        
        #create window
        screen = pygame.display.set_mode((width, height))
        pygame.display.set_caption("Oyun")
        clock = pygame.time.Clock()
        
        env.run()

print("hh")