import numpy as np
import skimage as skimage
import warnings
warnings.filterwarnings("ignore")
import matplotlib.pyplot as plt
from . import DCQL_Pong_Game
from . import DCQL_Agent

TOTAL_TRAIN_TIME = 100000
IMG_HEIGHT = 40
IMG_WIDTH = 40
IMG_HISTORY = 4

def processGameImage(RawImage):
    grey_image = skimage.color.rgb2gray(RawImage)
    cropped_image = grey_image[0:400, 0:400]
    reduced_image = skimage.transform.resize(cropped_image, (IMG_HEIGHT, IMG_WIDTH))
    reduced_image = skimage.exposure.rescale_intensity(reduced_image, out_range = (0, 255))
    reduced_image = reduced_image / 128
    
    return reduced_image
    
def trainExperiment():
    TrainHistory = []
    
    TheGame = DCQL_Pong_Game.PongGame()
    TheGame.initialDisplay()
    TheAgent = DCQL_Agent.Agent()
    BestAction = 0
    
    [initialScore, initialScreenImage]= TheGame.playNextMove(BestAction)
    initialGameImage = processGameImage(initialScreenImage)
    
    gameState = np.stack((initialGameImage, initialGameImage, initialGameImage, initialGameImage), axis = 2)
    gameState = gameState.reshape(1, gameState.shape[0], gameState.shape[1], gameState.shape[2])
    
    for i in range(TOTAL_TRAIN_TIME):
        best_action = TheAgent.findBestAction(gameState)
        [return_score, new_screen_image] = TheGame.playNextMove(best_action)
        
        new_game_image = processGameImage(new_screen_image)
        new_game_image = new_game_image.reshape(1, new_game_image.shape[0], new_game_image.shape[1], 1)
        next_state = np.append(new_game_image, gameState[:,:,:,:3], axis = 3)
        TheAgent.captureSample((gameState, best_action, return_score, next_state))
        TheAgent.process()
        gameState = next_state
        
        if i % 250 == 0:
            print("Train time: ", i, "Game Score: ", TheGame.GScore)
            TrainHistory.append(TheGame.GScore)

trainExperiment()
    
    
    