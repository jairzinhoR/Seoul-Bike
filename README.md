# Projeto Seoul-Bike
Projeto do Curso de Estatística Computacional (Poli-UPE). Através da investigação da base de dados “Seoul Bike Sharing Data Set” - Machine Learning UCI, buscamos identificar correlações e fazer previsões que permitam melhor conhecimento deste negócio e, assim, o seu melhor aproveitamento. 

# 1. Introdução
Mobilidade urbana é um dos temas centrais do desenvolvimento das cidades. O ciclismo se apresenta como interessante alternativa para a mobilidade em razão dos diversos benefícios coletivos e individuais à saúde e ao meio ambiente. Cidades mais limpas, menos barulhentas e com mais espaços livres trazem maior qualidade de vida aos cidadãos que ali residem e/ou trabalham.

Uma das alternativas, além do estímulo ao uso de bicicletas particulares, é a oferta de serviços de aluguel. A gestão deste serviço envolve um complexo de fatores que, quando bem administrado, pode trazer maior aproveitamento pelo público beneficiário, além da redução dos custos para manutenção do serviço.

Através da investigação da base de dados “Seoul Bike Sharing Data Set”, disponível no repositório da Machine Learning UCI, buscaremos identificar correlações e fazer previsões que permitam melhor conhecimento deste negócio e, assim, o seu melhor aproveitamento.

# 2. Objetivo
Investigar eventuais correlações e realizar predições sobre a influência de fatores meteorológicos e hora do dia (variáveis independentes) na quantidade de bicicletas alugadas na cidade de Seul (variável alvo, dependente).

# 3. Base de dados
O conjunto de dados apresenta a quantidade de bicicletas alugadas por hora no Sistema Público de Compartilhamento de Bicicletas da cidade de Seul, na Coreia do Sul, juntamente com dados meteorológicos, hora do dia e informações sobre o funcionamento da cidade (se dia útil ou feriado).

Para fins desta pesquisa, vamos nos ater a dois grupos de informações da base de dados:

1) Variável alvo, dependente: quantidade de bicicletas alugadas por hora;
2) Variáveis independentes (dados meteorológicos e hora do dia):   
    a) Temperatura (ºC)  
    b) Umidade (%)  
    c) Velocidade do vento (m/s)  
    d) Visibilidade (10m)  
    e) Temperatura de ponto de orvalho (ºC)  
    f) Radiação solar  
    g) Precipitação de chuva (mm)  
    h) Queda de neve (cm)  
    i) Season (Estação, variável categórica considerada para o teste de ANOVA)  
    j) Holiday (Feriado, variável categórica para o teste de ANOVA)  

Link da base: https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand

# 4. Pré-processamento dos dados
A base de dados apresentava originalmente 8.760 ocorrências. Em um pré-processamento dos dados, realizamos três tarefas. A primeira foi a exclusão de todas as 295 ocorrências relativas aos intervalos de horas em que o sistema de compartilhamento de bicicletas esteve inoperante. Essa informação sobre o funcionamento ou não do sistema de aluguel pode ser verificada na variável “Functional Day”. Os dados sobre bicicletas alugadas apresentavam valores 0 (zero). No entanto, excluímos estes dados por considerá-los como valores ausentes. Após a operação, a base de dados apresentou 8.465 ocorrências.

Uma segunda tarefa foi o ajuste do formato das datas registradas na variável “Date”, de “yyyy/mm/dd” para “yyyy-mm-dd”. Por último, como terceira tarefa, realizamos a tradução da primeira linha da base para o português, que continha os títulos de cada variável.

## 4.1 Importação da base e ajuste para correta leitura das variáveis
Para importação da base foram realizados os comandos abaixo:

```
# IMPORTAÇÃO DA BASE
getwd()
base = read.csv2("SeoulBikeDataV1.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
View(base)
```

A partir da função str( ), pudemos verificar as variáveis que necessitariam ser configuradas para a leitura correta.

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/ffd15d9e-052f-4998-8769-153f6137b878" width="700">.   
   
Assim, realizamos os comandos abaixo:

```
# AJUSTE DOS TIPOS DAS VARIÁVEIS
base$DATA = as.Date(base$DATA, format = "%d-%m-%Y")
base$TEMPERATURA = as.numeric(base$TEMPERATURA)
base$VELOC_VENTO = as.numeric(base$VELOC_VENTO)
base$TEMP_ORVALHO = as.numeric(base$TEMP_ORVALHO)
base$RAD_SOLAR = as.numeric(base$RAD_SOLAR)
base$CHUVA = as.numeric(base$CHUVA)
base$NEVE = as.numeric(base$NEVE)
```

# 5. Estatística descritiva
Para a realização da estatística descritiva, verificamos a amplitude (valores mínimo e máximo), quartis, média e mediana. Utilizamos os seguintes comandos:


```
# ESTATÍSTICA DESCRITIVA DA BASE I - MÍNIMO, MÁXIMO, QUARTIS, MÉDIA E MEDIANA
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
```

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/fb4abeea-e9d2-4e65-8fa4-ed468558cbea" width="450">.   
   
Já é possível tirarmos algumas impressões de nossa base. O primeiro dado que pode ser destacado diz respeito a constante utilização do serviço de aluguel de bicicletas. A variável BIC_ALUGADAS apresenta 2 (dois) como valor mínimo. Isso quer dizer que não houve uma única hora, em 365 dias no ano, nem mesmo durante as madrugadas, onde pelo menos 2 (duas) bicicletas não foram alugadas. Outros dados que corroboram com estas impressões são o de mediana e média, que apresentam altos valores e correspondem, respectivamente, a 542 e 729 bicicletas alugas por hora. Para visualizarmos mais um dado sobre essa alta rotatividade de bicicletas alugadas, lançamos a função sum( ) e obtivemos o resultado de 6 milhões 172 mil 314 bicicletas alugadas no ano.   
   
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/412b521a-306b-4fa2-985e-c9bf4822c8b7" width="220">.
   
É possível tirarmos muitas outras impressões a partir das estatísticas descritivas de cada uma das variáveis. Por exemplo, há significativa amplitude nos dados da variável TEMPERATURA. O valor mínimo encontrado foi de - 17,8ºC, enquanto que o máximo foi de 39.4ºC. Apesar desta grande amplitude, a média e a mediana revelam que se trata de uma cidade fria a maior parte do ano. Mediana (13,5ºC) e Média (12,77ºC). Ou seja, Seul pode ser uma cidade bem quente, alcançando temperaturas semelhantes das cidades mais quentes do Brasil, mas em geral possui um clima frio. Destaco também as estatísticas das variáveis CHUVA e NEVE. Apesar de apresentarem valores máximos de precipitação e queda de 35mm e 8,8cm, respectivamente, suas médias são bastante baixas, 0,15mm e 0,078cm. Além disso, as medianas de ambas as variáveis resultaram em (0) zero. Isso significa dizer que em mais da metade do ano faz sol (não chove, nem neva).

Para aprofundarmos o conhecimento da análise descritiva de nossa base, vamos também verificar a variância e o desvio padrão de cada uma das variáveis.

```
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
```

Obtivemos o resultado conforme print do console a seguir:

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/60e48346-6b81-4cd1-904c-717fb8898c19" width="600">

De fato, observamos valores altos de variância e desvio padrão para algumas das variáveis que apresentavam grande amplitude (valores mínimo e máximo), tal como nas variáveis BIC_ALUGADAS e TEMPERATURA. Por outro lado, variáveis como CHUVA E NEVE apresentaram baixa flutuação. A seguir, apresentaremos alguns gráficos e, assim, a dispersão dos dados ficará ainda mais evidente.

# 6. Gráficos de algumas variáveis

```
# GRÁFICOS DE ALGUMAS VARIÁVEIS
hist(base$BIC_ALUGADAS, labels = T, col = "green", breaks = 8, main =
"Histograma de Bicicletas Alugadas", xlab = "Bicicletas Alugadas", ylab =
"Frequência Absoluta")
```
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/e38ed93e-fadf-4060-aa36-bacdad9581a5" width="600">

Temos aqui um histograma do tipo despenhadeiro. Como temos 8.465 ocorrências ao todo e cada ocorrência representa a quantidade de bicicletas alugadas em uma hora, podemos supor que em quase metade das horas registradas o quantitativo de bicicletas
alugadas variou entre 0 e 500 (primeira barra da esquerda). O gráfico ilustra bem as estatísticas descritivas que obtivemos acerca desta variável (BIC_ALUGADAS), que apresenta valores de média e mediana mais próximas do valor mínimo, apesar da grande amplitude.

```
boxplot(base$TEMPERATURA, labels = T, main = "Boxplot da temperatura emºC")
```

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/fd439e9b-10df-4314-b078-9bc810d4677b" width="600">

O boxplot da TEMPERATURA mostra a amplitude da variação (-17,8ºCe 39,4ºC) e a sua mediana 13,5ºC.

```
boxplot(base$UMIDADE, labels = T, main = "Boxplot da Umidade em%")
```
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/baad9b01-76f0-497d-a24d-4f81b7615884" width="600">

O boxplot da UMIDADE apresenta aspecto semelhante ao da TEMPERATURA. É perceptível, no entanto, que há uma distância maior entre o ponto mínimo e o final do primeiro quartil. Isso indica que há maior ocorrência concentrada em valores mais
altos. Por isso, a mediana apresenta o índice de 57%.

```
plot(base$DATA, base$NEVE, col = "blue", main = "Neve ao longo do ano em(cm)", xlab = "Meses", ylab = "Índice de neve")
```
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/e750a215-e1d9-4276-98ba-87d8943fb3d9" width="600">

Os índices de queda de neve concentrados nos meses de dezembro até final de fevereiro nos conduzem a perceber que as estações do ano são bem definidas. Algo natural, considerando que Seul está localizado no hemisfério norte, em latitude próxima de países como Portugal e Estados Unidos.
```
plot(base$DATA, base$CHUVA, col = "blue", main = "Chuvas ao longo do ano em(mm)", xlab = "Meses", ylab = "Índice de chuvas")
```

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/0547fd02-3c6b-4dd6-98d3-2e4b0e5c7076" width="600">

As chuvas, por outro lado, estão presentes em praticamente todo o ano, mas em quantidade menor nos meses de dezembro até final de fevereiro. O que é esperado, considerando que estes são os meses das mais baixas temperaturas e queda de neve.

# 7. Correlação de todas as variáveis numéricas

Para realizarmos a correlação da base inteira precisamos excluir as colunas contendo variáveis nominais. Fizemos isso através dos comandos abaixo e salvamos a base em outra variável, com o fim de podermos acessar as variáveis nominais novamente na última etapa da pesquisa, para o teste de ANOVA.

```
# AJUSTE DA BASE PARA CORRELAÇÃO DAS VARIÁVEIS NUMÉRICASbaseNum = base[,-(1),drop=FALSE]
baseNum = baseNum[,-(12),drop=FALSE]
baseNum = baseNum[,-(11),drop=FALSE]
View(baseNum)
# CORRELAÇÃO DA BASE
corbase = cor(baseNum)
library(corrplot)
corrplot(corbase)
corbase
```

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/f4a4c574-4ebf-42eb-b8dc-f8ef533fc25a" width="600">
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/38fb5801-6605-49e9-a61a-1cf8ac5eff78" width="999">

Tanto o gráfico de correlação como a tabela nos trazem informações que podemos dizer que seriam previsíveis, mas em intensidade inferior ao esperado. CHUVA, NEVE e UMIDADE são as únicas variáveis que apresentam correlação negativa ao número de bicicletas alugadas, mas em valores considerados desprezíveis (inferior a0.3). Por outro lado, a temperatura foi a variável que apresentou a correlação de maior intensidade em relação ao número de bicicletas alugadas 0.56, que pode ser considerada uma correlação moderada. Para um país de temperaturas baixas é natural que o número de bicicletas alugadas aumente na medida que a temperatura também aumente.

A HORA é a segunda variável de correlação mais intensa, mas ainda assim considerada fraca (0.42). De fato, o número de bicicletas alugadas durante as madrugadas de cada dia é muito baixo. Na medida que as horas vão avançando o número de bicicletas vai aumentando. Ajustando a visualização da base por quantidade de bicicletas alugadas em ordem decrescente pudemos constatar isso. Nas dez primeiras ocorrências encontramos os maiores registros de demanda por bicicletas às 18 horas. E os cem maiores registros estão localizados entre às 17h e 21h.

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/7948afc5-0d10-47a1-aa1c-833d41d2fd58" width="999">

Nestes dez dias onde houve a maior demanda de bicicletas também percebemos temperaturas que variaram entre 24,1ºC e 27,8ºC, índices bem acima da média e mediana da cidade. Estas informações corroboram com o fato da variável TEMPERATURA apresentar a correlação mais forte e, por isso, será a mais importante para a construção do nosso modelo.

# 8. Gráficos boxplot das demais variáveis numéricas

Como já apresentamos gráficos boxplot da temperatura e umidade do ar no item 6 deste relatório, vamos aqui verificar como se dispõe os gráficos boxplot das demais variáveis numéricas de nossa base.

```
# GRÁFICO BOXPLOT DAS DEMAIS VARIÁVEIS NUMÉRICA
boxplot(baseNum$BIC_ALUGADAS, labels = T, main = "Qtd de bicicletas
alugadas por hora")
boxplot(baseNum$VELOC_VENTO, labels = T, main = "Velocidade do vento emm/s")
boxplot(baseNum$VISIBILIDADE, labels = T, main = "Visibilidade (10m)")
boxplot(baseNum$TEMP_ORVALHO, labels = T, main = "Temperatura de pontode orvalho em ºC")
boxplot(baseNum$RAD_SOLAR, labels = T, main = "Umidade do ar em%")
boxplot(baseNum$CHUVA, labels = T, main = "Chuva em mm")
boxplot(baseNum$NEVE, labels = T, main = "Neve em mm")
boxplot(baseNum$HORA, labels = T, main = "Horas consideradas no estudo")
```
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/40a9e9ad-66ad-4b0d-a7f0-6bcbf7302f75" width="600">
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/26d0a033-7230-4b2e-9d9d-c927a7d2fdc2" width="600">
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/b3269b19-c0a0-4cad-8ac6-4ff68483de2c" width="600">
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/98a2c225-85d1-4057-89cc-7441538a8cb1" width="600">

Podemos identificar outliers em vários gráficos aqui: no de bicicletas alugadas por hora, velocidade do vento, chuva, radiação solar e neve. Como já discutido, estas são variáveis que apresentam dados com distribuição desigual. Apenas para ilustrar e relembrar, a neve se concentra em apenas três meses do ano. O índice 0 (zero) de neve que se estende ao longo de todo ano puxa os quartis e a mediana para baixo. Por isso, a caixa está achatada e a grande quantidade de outliers acima do ponto limite.

Já o gráfico da variável TEMPERATURA DO PONTO DE ORVALHO apresenta uma distribuição semelhante ao da TEMPERATURA. Isso é esperado, já que estas duas métricas guardam grande correlação. Caso você retorne para a tabela de correlação, verá que as duas possuem uma correlação muito forte: 0,91.

Não há nada para comentar sobre o boxplot da variável HORA do dia. Os valores foram registrados continuamente das 0 horas às 23 horas e, por isso, a disposição do gráfico apresenta perfeita simetria. A sua visualização se fez importante apenas para constatarmos a ocorrência uniforme dos registros.

# 9. Método de Monte Carlo, particionamento dos dados e criação do modelo de regressão

Dado o tamanho de nossa base, utilizaremos a técnica denominada cross-validation para particionamento dos dados em treinamento e teste e, posteriormente, avaliação de cada um de nossos modelos.

Vamos construir três modelos e depois compará-los. Os três terão como variável alvo BIC_ALUGADAS. O modelo 1 terá como variável independente aquela que apresentou correlação mais forte. O modelo 2 terá como variáveis independentes as duas que apresentaram maior correlação. E o modelo 3 irá abranger todas as demais variáveis de nossa base de dados. Apresento o esquema abaixo para facilitar o entendimento. Logo em seguida, apresento o script dos três modelos.

### 9.1 Criação do Modelo 1
Variável alvo (BIC_ALUGADAS)
Variável independente (TEMPERATURA)

```
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
# inicio do LOOP de MONTE CARLO
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
# Dividindo em Treino e Teste
test.data = baseNum[vetor,]
train.data = baseNum[-vetor,]
# Construção do Modelo de Regressão
modelo1 =lm(BIC_ALUGADAS ~ TEMPERATURA, data = train.data)
# Calculo do Valor predito
ValoresPreditos1 = predict(modelo1,newdata=data.frame(test.data))
# Métricas para Avaliar o modelo
ModeloAjustado1 [i] = R2(ValoresPreditos1, test.data$BIC_ALUGADAS)
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
```

### 9.2 Criação do Modelo 2
Variável alvo (BIC_ALUGADAS)
Variáveis independentes (TEMPERATURA e HORA)

```
# MODELO 2 - QUANTIDADE DE BICICLETAS ALUGADAS POR HORA, CONSIDERANDO AS VARIÁVEIS TEMPERATURA E HORA DO DIA
ModeloAjustado2 = c(0)
ErroAbsoluto2 = c(0)
ErroMedioQuadratico2 = c(0)
n = dim(baseNum)[1]
MC= 30
MA2=NULL
MAE2=NULL
RMSE2=NULL
# inicio do LOOP de MONTE CARLO
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
# Média final dos erros após o MC
mean(MA2)
mean(MAE2)
mean(RMSE2)
```

### 9.3 Criação do Modelo 3
Variável alvo (BIC_ALUGADAS)
Variáveis independentes (TEMPERATURA, HORA, TEMP_ORVALHOUMIDADE, VELOC_VENTO, VISIBILIDADE, RAD_SOLAR, CHUVA, NEVE)

```
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
modelo3 =lm(BIC_ALUGADAS ~ TEMPERATURA+HORA+TEMP_ORVALHO+UMIDADE+VELOC_VENTO+VI
SIBILIDADE+RAD_SOLAR+CHUVA+NEVE, data = train.data)
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
```

Vamos agora comparar as médias de erros do modelo ajustado, erro absoluto e erro médio quadrático.

### 9.4 Erros do Modelo 1
> mean(MA)   
[1] 0.3174221   
> mean(MAE)   
[1] 393.0512   
> mean(RMSE)   
[1] 530.8339   
### 9.5 Erros do Modelo 2   
> mean(MA2)   
[1] 0.3971569   
> mean(MAE2)   
[1] 366.4671   
> mean(RMSE2)   
[1] 498.9069   
### 9.6 Erros do Modelo 3   
> mean(MA3)   
[1] 0.512048   
> mean(MAE3)   
[1] 334.7368   
> mean(RMSE3)   
[1] 448.8965   
   
Ainda não é possível tirarmos conclusões. O índice do modelo ajustado 1 apresenta o menor valor. Por outro lado, o modelo 3 apresenta o menor erro absoluto. A partir de outras verificações poderemos chegar a uma conclusão sobre qual seria o melhor modelo. O test-t será fundamental para essa escolha.

# 10. Equação de regressão

Antes de seguirmos para a análise comparativa dos erros dos modelos, vamos entender melhor a equação de regressão, tomando como referência o nosso modelo1. Abaixo, apresento os coeficientes do teste de regressão:

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/12f6205c-b0ae-49b2-a4f1-53610e1e55cd" width="555">

O modelo de regressão pode ser expressado a partir da seguinte equação:

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/3fd65b9b-6f57-43f6-98fb-31d898f2872e" width="255">

Onde “a” seria o intercepto e b seria a inclinação da reta de regressão. Substituindo a e b pelos seus respectivos coeficientes temos:

Y = 348,98 + 29,83X

Desta forma, podemos dizer que a cada aumento de 1 grau de temperatura em graus celsius, teríamos o aumento de aproximadamente 30 bicicletas alugadas por hora.

Assim, podemos realizar a predição de um valor de bicicletas alugadas estimando uma dada temperatura hipotética. Por exemplo, 31,7 ºC é uma temperatura que não consta em nenhuma das 8.465 ocorrências registradas em nossa base de dados. Existem valores mais altos e mais baixos. Mas caso a temperatura alcance este índice em situações futuras e considerando a equação de regressão, qual seria a quantidadede bicicletas alugadas no intervalo de uma hora?

Para essa resposta, utilizamos os comandos abaixo e a já mencionada equação:

```
# PREDIÇÃO DE BICICLETAS ALUGADAS A PARTIR DA VARIAÇÃO DE TEMPERATURA
modelo1
a = 348.28
b = 29.87
x = 31.7
Y = a + (b*x)
Y
```
RESULTADO:
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/7e29aaea-0837-4524-abea-056d0762a627" width="205">

Como resultado temos uma estimativa de 1.295 bicicletas alugadas no intervalo de uma hora para a temperatura de 37,1ºC. Estas são estimativas interessantes de serem realizadas porque a gestão eficiente do sistema envolveria, por exemplo, a preparação e disponibilização de uma quantidade maior de bicicletas nos períodos de temperaturas mais altas.

# 11. Análise comparativa dos vetores de erros dos modelos de regressão

## 11.1 Verificação da normalidade na distribuição dos erros

Primeiro, é importante verificarmos o histograma dos erros.

```
# VERIFICAÇÃO DE POSSÍVEL NORMALIDADE POR MEIO DOS GRÁFICOS
hist(ErroAbsoluto1)
hist(ErroAbsoluto2)
hist(ErroAbsoluto3)
```
<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/35b7b638-6f46-4c94-8078-732ce52f3380" width="705">

Não é possível constatar a normalidade da distribuição dos erros apenas através da visualização dos histogramas acima. Assim, faz-se importante realizarmos o teste de Shapiro-wilk.

## 11.2 Teste de Shapiro-Wilk

```
# VERIFICAÇÃO DA NORMALIDADE DOS ERROS A PARTIR DO TESTE DE SHAPIRO
shapiro.test(ErroAbsoluto1)
shapiro.test(ErroAbsoluto2)
shapiro.test(ErroAbsoluto3)
```

Resultado:

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/ceae23b0-72cb-4a3f-94b6-0c330c1a5e78" width="505">

Os testes de Shapiro-Wilk retornou p-value superior a 0,05 para os três vetores deerros dos três modelos em análise. Assim, podemos constatar a normalidade dos três. Agora, temos condições de realizarmos o Teste-T para uma definição sobre qual modelo seria mais interessante.

## 11.3 Teste-T

```
# TESTE-T
t.test(ErroAbsoluto1,ErroAbsoluto2, alternative = c("less"))
t.test(ErroAbsoluto2,ErroAbsoluto3, alternative = c("less"))
t.test(ErroAbsoluto3,ErroAbsoluto2, alternative = c("less"))
```

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/0305a64e-a191-4d3f-8510-f8e9ac63c5fb" width="605">

Vamos admitir o intervalo de confiança de 95%, tal como convencionado e sugerido pela função “t.test( )”. Comparamos os erros absolutos dos modelos 1 e 2, supondo que o modelo 1, aquele que apresentava apenas a variável temperatura, seria melhor que o modelo 2. No entanto, o p-value apresentou o resultado “1”. Valor este superior ao admitido (0,05) e delimitado pelo nosso intervalo de confiança. Neste caso, aceitamos a hipótese nula e nada podemos dizer sobre qual seria o modelo com menos erros.

Em razão do resultado do primeiro teste, avançamos para o segundo, para saber se o modelo 2 seria melhor do que o modelo 3. No entanto, o valor do resultado do p-value também foi “1”. Mais uma vez, devemos aceitar a hipótese nula e nada podemos dizer sobre qual seria o melhor modelo.

Por fim, realizamos o teste para verificarmos se o modelo 3 seria melhor que omodelo 2. Nesse caso, o valor de p foi bastante inferior a 0,05, tendo como resultado 5.788e-07. Neste caso, rejeitamos a hipótese nula e admitimos a hipótese alternativa. Assim, o modelo que relaciona a variável alvo (BIC_ALUGADAS) com todas as demais variáveis da base foi o modelo que apresentou o melhor desempenho.

# 12. Teste de ANOVA

O teste de ANOVA é uma técnica estatística para realizar comparações entre três ou mais grupos em amostras independentes. Para realizarmos esse teste, vamos realizar
novo carregamento da base de dados sem nenhum tipo de pré-processamento. O objetivo aqui é o de resgatar duas variáveis categóricas: 1) estações do ano (Seasons)
e 2) feriados (Holiday); para verificarmos se existe diferença entre a quantidade debicicletas alugadas (Rented.Bike.Count), considerando estações do ano e feriados. Dito de outro modo, pensando nas nossas hipóteses nula e alternativa:

* H0: Não existe diferença na quantidade de bicicletas alugadas emrazão das estações do ano.
* H1: Há diferença na quantidade de bicicletas alugadas em pelo menos uma estação do ano.
* H0: Não existe diferença na quantidade de bicicletas alugadas emrazão dos feriados.
* H1:Há diferença na quantidade de bicicletas alugadas em pelo menos um dos feriados.

```
#ANOVA
baseANOVA = read.csv2("SeoulBikeData.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
View(baseANOVA)
dados_anova = aov(baseANOVA$Rented.Bike.Count ~
baseANOVA$Seasons+baseANOVA$Holiday)
dados_anova
summary(dados_anova)
```

Resultado:

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/95350465-2779-479a-9949-636b4aa02b06" width="600">

Diferentemente do Teste-T, no teste de ANOVA não formulamos a hipótese. O objetivo aqui é constatarmos se há variabilidade na relação entre as variáveis independentes sobre a variável alvo. Também diferente do Teste-T, não definimos o intervalo de confiança e a nossa principal referência para análise é o valor de “F” em comparação com os diferentes intervalos de confiança indicados pelos símbolos de asterisco ou ponto.

Conforme resultado, em ambos os casos, rejeitamos a hipótese nula e acolhemos a hipótese alternativa. Há relação e variação na quantidade de bicicletas alugadas tanto em decorrência de, pelo menos, uma estações do ano, como em decorrência de, pelo menos, um feriado. Os valores de F ficaram abaixo do mínimo estipulado pelo intervalo de confiança. “Estação do Ano”, com intervalo de confiança de 99,99%, obteve F-value de 2e-16 e “Feriado”, com intervalo de confiança de 95%, obteve F- value de 0,0154.

# 13. Considerações finais

Constatamos moderada correlação da variável temperatura com o quantitativo de aluguel de bicicletas. No entanto, ela por si não foi suficiente para criação de um modelo de inferência confiável. Agregando outras variáveis, dados meteorológicos e a variável “HORA” do dia, fomos capazes de encontrar um modelo de regressão capaz de prever a flutuação da demanda do sistema de compartilhamento de bicicletas.

Como sugestão para futuros trabalhos sobre o assunto, recomendamos verificar o possível aumento da acurácia de novos modelos ao tratar de forma específica as diferentes horas do dia e seu impacto na quantidade de bicicletas alugadas. Ao verificar a correlação entre BIC_ALUGADAS e TEMPERATURA, considerando apenas o mesmo intervalo de hora (das 17h às 18h), houve um aumento significativo da correlação (de 0,56 para 0,72). Este é um indicativo de que pode ser interessante tratar as horas do dia de forma individualizada ou específica. Assim, sugerimos a construção de modelos específicos para cada intervalo de hora ou a instrução para que um mesmo modelo trate as horas do dia de forma pareada. Por exemplo, é mais inteligente analisar comparativamente o quantitativo de bicicletas alugadas sempre as 18h de diferente dias úteis, do que comparar essa mesma hora com todos os intervalos de tempo possíveis, como madrugdas e feriados. Essa sugestão apenas tem o intuitode ampliar a capacidade do(s) modelo(s) em entender as especificidades que envolvem o negócio.

Considerando a recomendação anterior, também sugerimos a ampliação da base dedados, uma vez que cada intervalo de hora dispõe apenas de 365 ocorrências. Dados sobre os usuários também podem agregar muito valor para o entendimento sobre a flutuação da demanda ao longo do ano, assim como informações georeferenciadas sobre a circulação dessas bicicletas e suas demandas em diferentes pontos da cidade.

Por fim, cabe destacar que este estudo pode subsidiar outros trabalhos sobre sistemas de compartilhamento de bicicletas. Seul é a maior metrópole da Coréia do Sul e possui uma população de quase dez milhões de habitantes. Recife, por exemplo, dispõe de apenas 1,55 milhão de habitantes. O conhecimento da complexidade que envolve o sistema de bicicletas estudado e as características meteorológicas de Seul podem subsidiar novos trabalhos atentos às similitudes e diferenças de outros sistemas e localidades, de modo a identificar e potencializar oportunidades e reduzir e/ou evitar riscos do negócio.
