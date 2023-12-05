# Projeto Seoul-Bike
Produto final do Curso de Estatística Computacional (Poli-UPE). Através da investigação da base de dados “Seoul Bike Sharing Data Set” - Machine Learning UCI, buscamos identificar correlações e fazer previsões que permitam melhor conhecimento deste negócio e, assim, o seu melhor aproveitamento.

# 1. Introdução

Mobilidade urbana é um dos temas centrais do desenvolvimento das cidades. O ciclismo se apresenta como interessante alternativa para a mobilidade em razão dos diversos benefícios coletivos e individuais à saúde e ao meio ambiente. Cidades mais limpas, menos barulhentas e com mais espaços livres trazem maior qualidade de vidaaos cidadãos que ali residem e/ou trabalham.

Uma das alternativas, além do estímulo ao uso de bicicletas particulares é a oferta de serviços de aluguel. A gestão deste serviço envolve um complexo de fatores que, quando bem administrado, pode trazer maior aproveitamento pelo público beneficiário, além da redução dos custos para manutenção do serviço.

Através da investigação da base de dados “Seoul Bike Sharing Data Set”, disponível no repositório de Machine Learning UCI, buscaremos identificar correlações e fazer previsões que permitam melhor conhecimento deste negócio e, assim, o seu melhor aproveitamento.

# 2. Objetivo

Investigar eventuais correlações e realizar predições sobre a influência de fatores meteorológicos e hora do dia (variáveis independentes) na quantidade de bicicletas alugadas na cidade de Seul (variável alvo, dependente).

# 3. Base de dados
O conjunto de dados apresenta a quantidade de bicicletas alugadas por hora noSistema Público de Compartilhamento de Bicicletas da cidade de Seul, na Coreia doSul, juntamente com dados meteorológicos, hora do dia e informações sobre ofuncionamento da cidade (se dia útil ou feriado).

Para fins desta pesquisa, vamos nos ater a dois grupos de informações da base dedados:

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

Uma segunda tarefa foi o ajuste do formato das datas registradas na variável “Date”, de “yyyy/mm/dd” para “yyyy-mm-dd”. Por último, como terceira tarefa, realizamos a tradução da primeira linha da base para o português, que continha os títulos de cada variável. Todas as demais operações foram realizadas no software RStudio.

## 4.1 Importação da base e ajuste para correta leitura das variáveis

Para importação da base foram realizados os comandos abaixo:

```
# IMPORTAÇÃO DA BASE
getwd()
base = read.csv2("SeoulBikeDataV1.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
View(base)
```

A partir da função str( ), pudemos verificar as variáveis que necessitariam ser configuradas para a leitura correta.

<img src="https://github.com/jairzinhoR/Seoul-Bike/assets/96251048/d5d7c73e-43ea-4354-882a-3a3e69ac45ff" width="300">


