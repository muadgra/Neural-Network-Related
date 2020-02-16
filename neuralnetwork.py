# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 23:07:34 2020

@author: mertc
"""

import pandas as pd
import numpy as np

giris_satir_sayisi = int(input("Giris matrisinin satir sayisini giriniz: "))
giris_sutun_sayisi = int(input("Giris matrisinin sutun sayisini giriniz: "))

#Bir sefer eğitim olacağı için learning rate'e gerek yoktur.
#learning_rate = float(input("Learning rate'i giriniz: "))

lambda_degeri = float(input("Lambda değerini giriniz: "))

def f_act(matris):
    return matris * 0.1
y_gercek = np.zeros(shape = (giris_satir_sayisi, giris_sutun_sayisi), dtype = np.float16)

giris_matrisi = np.zeros(shape = (giris_satir_sayisi, giris_sutun_sayisi), dtype = np.float16)

def eleman_ata(matris):
    for i in range(matris.shape[0]):
        for j in range(matris.shape[1]):
            giris_matrisi[i,j] = float(input("Matrisin [" + str(i + 1) + "][" + str(j + 1) + "] elemanını giriniz: "))
        
    return giris_matrisi
print("\nGiris matrisinizi giriniz: ")
giris_matrisi = eleman_ata(giris_matrisi)

print("\nCikis matrisinizi giriniz: ")
y_gercek = eleman_ata(y_gercek)

hidden_layer_sayisi = int(input("Kac hidden layer olsun? "))

weight_dict = dict()
for i in range(hidden_layer_sayisi):
    weight = "w" + str(i + 1)
    weight_satir_sayisi = int(input("Weight " + str(i + 1) + " matrisinin satir sayisini giriniz: "))
    weight_sutun_sayisi = int(input("Weight " + str(i + 1) + " matrisinin sutun sayisini giriniz: "))
    
    weight_int = np.random.rand(weight_satir_sayisi, weight_sutun_sayisi)
    weight_dict[weight] = weight_int

temp = giris_matrisi
cikti_listesi = []
for i in range(hidden_layer_sayisi):
    temp = np.dot(temp, weight_dict["w" + str(i + 1)])
    temp = f_act(temp)
    cikti = temp
    cikti_listesi.append(cikti)

#Geri hesaplama
#önce son layerdaki öğrenme özel olarak hesaplanır.

f_list = []
for i in range(cikti_listesi[-1].shape[0]):    
    k = np.zeros((cikti_listesi[-1].shape[0], cikti_listesi[-1].shape[1]), dtype = np.float16)
    for j in range(cikti_listesi[-1].shape[1]):
        k[i, j] = cikti_listesi[-1][i, j] * (1 - cikti_listesi[-1][i, j]) * (y_gercek[i, j] - cikti_listesi[-1][i, j])
    
f_list.append(k)

son = cikti_listesi[-1]
for i in range(weight_dict["w" + str(len(weight_dict))].shape[0]):
    for j in range(weight_dict["w" + str(len(weight_dict))].shape[1]):
        degisim = lambda_degeri * k[0, j] * son[0, j]
        weight_dict["w" + str(len(weight_dict))][i, j] += degisim

#son katmandan geri dönerken, her bir katmandaki weightler, son katmandan
#elde edilenlere göre güncellenir
if(hidden_layer_sayisi > 1):
    baslangic = len(weight_dict) - 2
    for a in range(baslangic, -1, -1):
        for i in range(cikti_listesi[a].shape[0]):
            m = np.zeros((cikti_listesi[a].shape[0], cikti_listesi[a].shape[1]), dtype = np.float16)
            f = f_list.pop()
            for j in range(cikti_listesi[a].shape[1]):
                toplam = 0
                for k in range(f.shape[1]):
                    toplam += f[0, k] * weight_dict["w" + str(a + 1)][i, j] 
            m[i, j] = cikti_listesi[a][i, j] * (1 - cikti_listesi[a][i, j]) * toplam
            degisim = lambda_degeri * m[0, j] * cikti_listesi[a][0, j]
            weight_dict["w" + str(a + 1)][i, j] += degisim
        f_list.append(m)