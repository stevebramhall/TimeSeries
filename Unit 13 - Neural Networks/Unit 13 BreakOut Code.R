#Sunspot Melenoma 

library(nnfor)
library(forecast)

### SUNSPOT DATA

#VAR
SM = read.csv(file.choose(),header = TRUE)

SMsmall = SM[1:29,]

VAR_SM = VAR(cbind(SMsmall$Melanoma,SMsmall$Sunspot),lag.max = 5, type = "const")

pred = predict(VAR_SM,n.ahead = 8)

plot(SM$Melanoma, type = "l")
lines(seq(30,37,1),pred$fcst$y1[,1],col = "red")

ASE = mean((SM$Melanoma[30:37] - pred$fcst$y1[1:8])^2)

ASE


#MLP
SMsmallDF = data.frame(Sunspot = ts(SMsmall$Sunspot))
fit.mlp = mlp(ts(SMsmall$Melanoma),reps = 50,comb = "mean",xreg = SMsmallDF)
fit.mlp
plot(fit.mlp)
SMDF = data.frame(Sunspot = ts(SM$Sunspot))
fore.mlp = forecast(fit.mlp, h = 8, xreg = SMDF)
plot(fore.mlp)

plot(SM$Melanoma, type = "l")
lines(seq(30,37,1),fore.mlp$mean,col = "blue")

ASE = mean((SM$Melanoma[30:37] - fore.mlp$mean)^2)
ASE


#ensemble

ensemble = (fore.mlp$mean + pred$fcst$y1[,1])/2

plot(SM$Melanoma, type = "l")
lines(seq(30,37,1),ensemble,col = "green")

ASE = mean((SM$Melanoma[30:37] - ensemble)^2)
ASE







##### CARDIAC MORTALITY DATA    30 week forecast
library(tidyverse)
library(GGally)
library(astsa)
CM = read.csv(file.choose(),header = TRUE)

head(CM)
ggpairs(CM[2:4]) #matrix of scatter plots



#VAR Model 3 seasonal with Lag 1 Temp
CM$temp_1 = dplyr::lag(CM$temp,1)
ggpairs(CM)

VARselect(cbind(CM$cmort[2:508], CM$part[2:508], CM$temp_1[2:508]),lag.max = 10, season = 52, type = "both")

#VAR with p = 2
CMortVAR = VAR(cbind(CM$cmort[2:508], CM$part[2:508], CM$temp_1[2:508]),season = 52, type = "both",p = 2)
preds=predict(CMortVAR,n.ahead=30)

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,528), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(509,538,1), preds$fcst$y1[,1], type = "l", col = "red")


#Find ASE using last 30
CMsmall = CM[1:478,]

#Start and 2 since the lagged variable is NA at first index
VARselect(cbind(CMsmall$cmort[2:478], CMsmall$part[2:478], CMsmall$temp_1[2:478]),lag.max = 10, season = 52, type = "both")

CMortVAR = VAR(cbind(CMsmall$cmort[2:478], CMsmall$part[2:478], CMsmall$temp_1[2:478]),season = 52, type = "both",p = 2)
preds=predict(CMortVAR,n.ahead=30)

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,508), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(479,508,1), preds$fcst$y1[,1], type = "l", col = "red")


ASE = mean((CM$cmort[479:508] - preds$fcst$y1[,1])^2)
ASE




##### MLP MODEL FOR CARDIAC MORTALITY DATA
CMsmall = CMsmall[2:478,]
CMsmallDF = data.frame(Week = ts(CMsmall$Week),temp = ts(CMsmall$temp), part = ts(CMsmall$part), temp_1 = ts(CMsmall$temp_1))
fit.mlp = mlp(ts(CMsmall$cmort),reps = 50,comb = "mean",xreg = CMsmallDF)
fit.mlp
plot(fit.mlp)
CMDF = data.frame(Week = ts(CM$Week),temp = ts(CM$temp), part = ts(CM$part), temp_1 = ts(CM$temp_1))
fore.mlp = forecast(fit.mlp, h = 30, xreg = CMDF)
plot(fore.mlp)
ASE = mean((CM$cmort[479:508] - fore.mlp$mean)^2)
ASE

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,508), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(479,508,1), fore.mlp$mean, type = "l", col = "red")



#Ensemble 

ensemble  = (preds$fcst$y1[,1] + fore.mlp$mean)/2

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,508), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(479,508,1), ensemble, type = "l", col = "green")

ASE = mean((CM$cmort[479:508] - ensemble)^2)
ASE








##### CARDIAC MORTALITY DATA    52 week forecast
library(tidyverse)
library(GGally)
library(astsa)
CM = read.csv(file.choose(),header = TRUE)

head(CM)
ggpairs(CM[2:4]) #matrix of scatter plots



#VAR Model 3 seasonal with Lag 1 Temp
CM$temp_1 = dplyr::lag(CM$temp,1)
ggpairs(CM)

VARselect(cbind(CM$cmort[2:508], CM$part[2:508], CM$temp_1[2:508]),lag.max = 10, season = 52, type = "both")

#VAR with p = 2
CMortVAR = VAR(cbind(CM$cmort[2:508], CM$part[2:508], CM$temp_1[2:508]),season = 52, type = "both",p = 2)
preds=predict(CMortVAR,n.ahead=52)

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,565), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(509,560,1), preds$fcst$y1[,1], type = "l", col = "red")



#Find ASE using last 52
CMsmall = CM[1:456,]

#Start and 2 since the lagged variable is NA at first index
VARselect(cbind(CMsmall$cmort[2:456], CMsmall$part[2:456], CMsmall$temp_1[2:456]),lag.max = 10, season = 52, type = "both")

CMortVAR = VAR(cbind(CMsmall$cmort[2:456], CMsmall$part[2:456], CMsmall$temp_1[2:456]),season = 52, type = "both",p = 2)
preds=predict(CMortVAR,n.ahead=52)

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,510), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(457,508,1), preds$fcst$y1[,1], type = "l", col = "red")


ASE = mean((CM$cmort[457:508] - preds$fcst$y1[,1])^2)
ASE




##### MLP MODEL FOR CARDIAC MORTALITY DATA
CMsmall = CMsmall[2:456,]
CMsmallDF = data.frame(Week = ts(CMsmall$Week),temp = ts(CMsmall$temp), part = ts(CMsmall$part), temp_1 = ts(CMsmall$temp_1))
fit.mlp = mlp(ts(CMsmall$cmort),reps = 50,comb = "mean",xreg = CMsmallDF)
fit.mlp
plot(fit.mlp)
CMDF = data.frame(Week = ts(CM$Week),temp = ts(CM$temp), part = ts(CM$part), temp_1 = ts(CM$temp_1))
fore.mlp = forecast(fit.mlp, h = 52, xreg = CMDF)
plot(fore.mlp)
ASE = mean((CM$cmort[457:508] - fore.mlp$mean)^2)
ASE

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,510), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(457,508,1), fore.mlp$mean, type = "l", col = "red")



#Ensemble 

ensemble  = (preds$fcst$y1[,1] + fore.mlp$mean)/2

#Plot
plot(seq(1,508,1), CM$cmort, type = "l",xlim = c(0,508), ylab = "Cardiac Mortality", main = "20 Week Cardiac Mortality Forecast")
lines(seq(457,508,1), ensemble, type = "l", col = "green")

ASE = mean((CM$cmort[457:508] - ensemble)^2)
ASE





###  Link to Ensemble Study on tourist data

ForecastXGB R package: 
  #http://freerangestats.info/blog/2016/11/06/forecastxgb
  #http://freerangestats.info/blog/2016/10/19/Tcomp
  
  
  