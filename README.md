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

# 6. Correlação de todas as variáveis numéricas

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

