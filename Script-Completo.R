# IMPORTAÇÃO DA BASE
getwd()
base = read.csv2("SeoulBikeDataV1.csv", header = TRUE, sep =",", stringsAsFactors = FALSE)
View(base)

# AJUSTE DOS TIPOS DAS VARIÁVEIS
str(base)
base$DATA = as.Date(base$DATA, format = "%d-%m-%Y")
base$TEMPERATURA = as.numeric(base$TEMPERATURA)
base$VELOC_VENTO = as.numeric(base$VELOC_VENTO)
base$TEMP_ORVALHO = as.numeric(base$TEMP_ORVALHO)
base$RAD_SOLAR = as.numeric(base$RAD_SOLAR)
base$CHUVA = as.numeric(base$CHUVA)
base$NEVE = as.numeric(base$NEVE)

# ESTATÍSTICA DESCRITIVA DA BASE I - MINÍMO, MÁXIMO, QUARTIS, MÉDIA E MEDIANA
summary(base$BIC_ALUGADAS)
summary(base$TEMPERATURA)
summary(base$UMIDADE)
summary(base$VELOC_VENTO)
summary(base$VISIBILIDADE)
summary(base$TEMP_ORVALHO)
summary(base$RAD_SOLAR)
summary(base$NEVE)
summary(base$CHUVA)
summary(base$HORA)
sum(base$BIC_ALUGADAS)

# ESTATÍSTICA DESCRITIVA DA BASE II - VARIÂNCIA E DESVIOPADRÃO
var(base$BIC_ALUGADAS)
sd(base$BIC_ALUGADAS)
var(base$TEMPERATURA)
sd(base$TEMPERATURA)
var(base$UMIDADE)
sd(base$UMIDADE)
var(base$VELOC_VENTO)
sd(base$VELOC_VENTO)
var(base$VISIBILIDADE)
sd(base$VISIBILIDADE)
var(base$TEMP_ORVALHO)
sd(base$TEMP_ORVALHO)
var(base$RAD_SOLAR)
sd(base$RAD_SOLAR)
var(base$CHUVA)
sd(base$CHUVA)
var(base$NEVE)
sd(base$NEVE)
var(base$HORA)
sd(base$HORA)

# GRÁFICOS DE ALGUMAS VARIÁVEIS
hist(base$BIC_ALUGADAS, labels = T, col = "green", breaks = 8, main="Histograma de Bicicletas Alugadas", xlab = "Bicicletas Alugadas", ylab="Frequência Absoluta")
boxplot(base$TEMPERATURA, labels = T, main = "Boxplot da temperatura em ºC")
boxplot(base$UMIDADE, labels = T, main = "Boxplot da Umidade em %")
plot(base$DATA, base$NEVE, col = "blue", main = "Neve ao longo do ano em (cm)", xlab = "Meses", ylab = "Índice de neve")
plot(base$DATA, base$CHUVA, col = "blue", main = "Chuvas ao longo do ano em (mm)", xlab = "Meses", ylab = "Índice de chuvas")

# AJUSTE DA BASE PARA CORRELAÇÃO DAS VARIÁVEIS NUMÉRICAS
baseNum = base[,-(1),drop=FALSE]
baseNum = baseNum[,-(12),drop=FALSE]
baseNum = baseNum[,-(11),drop=FALSE]
View(baseNum)

# CORRELAÇÃO DA BASE
corbase = cor(baseNum)
library(corrplot)
corrplot(corbase)
corbase

# GRÁFICO BOXPLOT DAS DEMAIS VARIÁVEIS NUMÉRICAS
boxplot(baseNum$BIC_ALUGADAS, labels = T, main = "Qtd de bicicletas alugadas por hora")
boxplot(baseNum$VELOC_VENTO, labels = T, main = "Velocidade do vento em m/s")
boxplot(baseNum$VISIBILIDADE, labels = T, main = "Visibilidade (10m)")
boxplot(baseNum$TEMP_ORVALHO, labels = T, main = "Temperatura de ponto de orvalho em ºC")
boxplot(baseNum$RAD_SOLAR, labels = T, main = "Radiação Solar em MJ/m²")
boxplot(baseNum$CHUVA, labels = T, main = "Chuva em mm")
boxplot(baseNum$NEVE, labels = T, main = "Neve em mm")
boxplot(baseNum$HORA, labels = T, main = "Horas disponíveis na base de dados")

# MODELO 1 - QUANTIDADE DE BICICLETAS ALUGADAS POR HORA, CONSIDERANDO A VARIÁVEL TEMPERATURA
ModeloAjustado1 = c(0)
ErroAbsoluto1 = c(0)
ErroMedioQuadratico1 = c(0)
library(caret)
n = dim(baseNum)[1]
MC= 30
MA=NULL
MAE=NULL
RMSE=NULL
#inicio do LOOP de MONTE CARLO
for (a in 1:MC){
  folds = createFolds(baseNum$BIC_ALUGADAS, k = 10, list = T, returnTrain =F)
  for (i in 1:10){
    #Obtencao do Vetor Aleatorio para escolha
    if (i == 1){
      vetor = folds$Fold01
    }else if (i == 2){
      vetor = folds$Fold02
    }else if (i == 3){
      vetor = folds$Fold03
    }else if (i == 4){
      vetor = folds$Fold04
    }else if (i == 4){
      vetor = folds$Fold04
    }else if (i == 5){
      vetor = folds$Fold05
    }else if (i == 6){
      vetor = folds$Fold06
    }else if (i == 7){
      vetor = folds$Fold07
    }else if (i == 8){
      vetor = folds$Fold08
    }else if (i == 9){
      vetor = folds$Fold09
    }else{
      vetor = folds$Fold10
    }
    #Dividindo em Treino e Teste
    test.data = baseNum[vetor,]
    train.data = baseNum[-vetor,]
    # Construção do Modelo de Regressão
    modelo1 =lm(BIC_ALUGADAS ~ TEMPERATURA, data = train.data)
    # Calculo do Valor predito
    ValoresPreditos1 = predict(modelo1,newdata=data.frame(test.data))
    #Métricas para Avaliar o modelo
    ModeloAjustado1 [i] = R2

(ValoresPreditos1, test.data$BIC_ALUGADAS)
    ErroAbsoluto1 [i] = MAE(ValoresPreditos1, test.data$BIC_ALUGADAS)
    ErroMedioQuadratico1 [i] = RMSE(ValoresPreditos1, test.data$BIC_ALUGADAS)
  }
  MA [a] = mean(ModeloAjustado1)
  MAE [a] = mean(ErroAbsoluto1)
  RMSE [a] = mean(ErroMedioQuadratico1)
}
#Média final dos erros após o MC
mean(MA)
mean(MAE)
mean(RMSE)

# MODELO 2 - QUANTIDADE DE BICICLETAS ALUGADAS POR HORA, CONSIDERANDO AS VARIÁVEIS TEMPERATURA E HORA DO DIA
ModeloAjustado2 = c(0)
ErroAbsoluto2 = c(0)
ErroMedioQuadratico2 = c(0)

n = dim(baseNum)[1]
MC= 30
MA2=NULL
MAE2=NULL
RMSE2=NULL
#inicio do LOOP de MONTE CARLO
for (a in 1:MC){
  folds = createFolds(baseNum$BIC_ALUGADAS, k = 10, list = T, returnTrain =F)
  for (i in 1:10){
    #Obtencao do Vetor Aleatorio para escolha
    if (i == 1){
      vetor = folds$Fold01
    }else if (i == 2){
      vetor = folds$Fold02
    }else if (i == 3){
      vetor = folds$Fold03
    }else if (i == 4){
      vetor = folds$Fold04
    }else if (i == 4){
      vetor = folds$Fold04
    }else if (i == 5){
      vetor = folds$Fold05
    }else if (i == 6){
      vetor = folds$Fold06
    }else if (i == 7){
      vetor = folds$Fold07
    }else if (i == 8){
      vetor = folds$Fold08
    }else if (i == 9){
      vetor = folds$Fold09
    }else{
      vetor = folds$Fold10
    }
    #Dividindo em Treino e Teste
    test.data = baseNum[vetor,]
    train.data = baseNum[-vetor,]
    # Construção do Modelo de Regressão
    modelo2 =lm(BIC_ALUGADAS ~ TEMPERATURA+HORA, data = train.data)
    # Calculo do Valor predito
    ValoresPreditos2 = predict(modelo2,newdata=data.frame(test.data))
    #Métricas para Avaliar o modelo
    ModeloAjustado2 [i] = R2(ValoresPreditos2, test.data$BIC_ALUGADAS)
    ErroAbsoluto2 [i] = MAE(ValoresPreditos2, test.data$BIC_ALUGADAS)
    ErroMedioQuadratico2 [i] = RMSE(ValoresPreditos2, test.data$BIC_ALUGADAS)
  }
  MA2 [a] = mean(ModeloAjustado2)
  MAE2 [a] = mean(ErroAbsoluto2)
  RMSE2 [a] = mean(ErroMedioQuadratico2)
}
#Média final dos erros após o MC
mean(MA2)
mean(MAE2)
mean(RMSE2)

# MODELO 3 - QUANTIDADE DE BICICLETAS ALUGADAS POR HORA, CONSIDERANDO TODAS AS VARIÁVEIS
ModeloAjustado3 = c(0)
ErroAbsoluto3 = c(0)
ErroMedioQuadratico3 = c(0)
n = dim(baseNum)[1]
MC= 30
MA3=NULL
MAE3=NULL
RMSE3=NULL
#inicio do LOOP de MONTE CARLO
for (a in 1:MC){
  folds = createFolds(baseNum$BIC_ALUGADAS, k = 10, list = T, returnTrain =F)
  for (i in 1:10){
    #Obtencao do Vetor Aleatorio para escolha
    if (i == 1){
      vetor = folds$Fold01
    }else if (i == 2){
      vetor = folds$Fold02
    }else if (i == 3){
      vetor = folds$Fold03
    }else if (i == 4){
      vetor = folds$Fold04
    }else if (i == 4){
      vetor = folds$Fold04
    }else if (i == 5){
      vetor = folds$Fold05
    }else if (i == 6){
      vetor = folds$Fold06
    }else if (i == 7){
      vetor = folds$Fold07
    }else if (i == 8){
      vetor = folds$Fold08
    }else if (i == 9){
      vetor = folds$Fold09
    }else{
      vetor = folds$Fold10
    }
    #Dividindo em Treino e Teste
    test.data = baseNum[vetor,]
    train.data = baseNum[-vetor,]
    # Construção do Modelo de Regressão
    modelo3 =lm(BIC_ALUGADAS ~ TEMPERATURA+HORA+TEMP_ORVALHO+UMIDADE+VELOC_VENTO+VISIBILIDADE+RAD_SOLAR+CHUVA+NEVE, data = train.data)
    # Calculo do Valor predito
    ValoresPreditos3 = predict(modelo3,newdata=data.frame(test.data))
    #Métricas para Avaliar o modelo
    ModeloAjustado3 [i] = R2(ValoresPreditos3, test.data$BIC_ALUGADAS)
    ErroAbsoluto3 [i] = MAE(ValoresPreditos3, test.data$BIC_ALUGADAS)
    ErroMedioQuadratico3 [i] = RMSE(ValoresPreditos3, test.data$BIC_ALUGADAS)
  }
  MA3 [a] = mean(ModeloAjustado3)
  MAE3 [a] = mean(ErroAbsoluto3)
  RMSE3 [a] = mean(ErroMedioQuadratico3)
}
#Média final dos erros após o MC
mean(MA3)
mean(MAE3)
mean(RMSE3)

# PREDIÇÃO DE BICICLETAS ALUGADAS A PARTIR DA VARIAÇÃO DE TEMPERATURA
modelo1
a = 348.28
b = 29.87
x = 31.7
Y = a + (b * x)
Y

# VERIFICAÇÃO DE POSSÍVEL NORMALIDADE POR MEIO DOS GRÁFICOS
hist(ErroAbsoluto1)
hist(ErroAbsoluto2)
hist(ErroAbsoluto3)

# VERIFICAÇÃO DA NORMALIDADE DOS ERROS A PARTIR DO TESTE DE SHAPIRO
shapiro.test(ErroAbsoluto1)
shapiro.test(ErroAbsoluto2)
shapiro.test(ErroAbsoluto3)

# TESTE-T
t.test(ErroAbsoluto1, ErroAbsoluto2, alternative = c("less"))
t.test(ErroAbsoluto2, ErroAbsoluto3, alternative = c("less"))
t.test(ErroAbsoluto3, ErroAbsoluto2, alternative = c("less"))
t.test(ErroAbsoluto3, ErroAbsoluto1, alternative = c("less"))

# ANOVA
baseANOVA = read.csv2("SeoulBikeData.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
View(baseANOVA)
dados_anova = aov(baseANOVA$Rented.Bike.Count ~ baseANOVA$Seasons + baseANOVA$Holiday)
dados_anova
summary(dados_anova)