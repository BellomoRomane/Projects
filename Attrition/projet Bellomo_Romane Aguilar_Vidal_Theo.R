#-------------------------#
# PREPARATION DES DONNEES #
#-------------------------#

# Chargement des donnees
projet1 <- read.csv("Data_Projet_1.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = T) 
projet1
projetNew<- read.csv("Data_Projet_1_New.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = T) 
projetNew

str(projetNew)
str(projet1)
View(projet1)
View(projetNew)

# Creation des ensembles d'apprentissage et de test
projet_EA<-projet1[1:980,]
projet_ET<-projet1[981:1470,]

# Suppression des variables StandardHours, EmployeeCount et Over18 de l'ensemble d'apprentissage
projet_EA <- subset(projet_EA, select=-StandardHours)
projet_EA <- subset(projet_EA, select=-EmployeeCount)
projet_EA <- subset(projet_EA, select=-Over18)

projet_ET <- subset(projet_ET, select=-StandardHours)
projet_ET <- subset(projet_ET, select=-EmployeeCount)
projet_ET <- subset(projet_ET, select=-Over18)


View(projet_EA)
View(projet_ET)


#fonction summary() pour afficher les caractéristiques principales des data frames
summary(projet1)
summary(projetNew)
summary(projet_EA)
summary(projet_ET)

# répartition des classes Attrition=Oui et Attrition=Non dans les 2 data frames
table(projet1$Attrition)
table(projet_EA$Attrition)
table(projet_ET$Attrition)

# Installation/m-a-j des librairies
install.packages("rpart")
install.packages("tree")
install.packages("C50")
install.packages("rpart.plot")
install.packages("ROCR")
install.packages("ggplot2")

# Activation des librairies
library(rpart)
library(C50)
library(tree)
library(rpart.plot)
library(ROCR)
library(ggplot2)


#-----------------------------------------#
# APPRENTISSAGE ARBRE DE DECISION 'rpart' #
#-----------------------------------------#

tree1<- rpart(Attrition~., projet_EA)
plot(tree1)
text(tree1,pretty = 0)
prp(tree1)

# Choix automatique des couleurs et intensité proportionnelle à la proportion de la classe majoritaire 
prp(tree1, type=4, extra=8, box.palette = "auto")
prp(tree1, type=4, extra=1, box.palette = "auto")


#----------------------------------------#
# APPRENTISSAGE ARBRE DE DECISION 'C5.0' #
#----------------------------------------#

tree2<- C5.0(Attrition~., projet_EA)
plot(tree2, type="simple")


#----------------------------------------#
# APPRENTISSAGE ARBRE DE DECISION 'tree' #
#----------------------------------------#

tree3<- tree(Attrition~., data=projet_EA)
plot(tree3)
text(tree3, pretty=0)


#-------------------------------------------#
# GENERATION DES PROBABILITES DE PREDICTION #
#-------------------------------------------#

# Generation de la classe prédite pour chaque exemple de test pour chaque arbre
test_tree1 <- predict(tree1, projet_ET, type="class")
test_tree2 <- predict(tree2, projet_ET, type="class")
test_tree3 <- predict(tree3, projet_ET, type="class")

test_tree1
test_tree2
test_tree3


# Comparaison des répartitions des predictions
table(test_tree1)
table(test_tree2)
table(test_tree3)

# taux de succès détaillé mais fait après
df_tree1 <- as.data.frame(table(projet_ET$Attrition, test_tree1)) 
colnames(df_tree1) = list("Classe", "Prediction", "Effectif")
df_tree1
sum(df_tree1[df_tree1$Classe==df_tree1$Prediction,"Effectif"]) /nrow(projet_ET)

df_tree2 <- as.data.frame(table(projet_ET$Attrition, test_tree2)) 
colnames(df_tree2) = list("Classe", "Prediction", "Effectif")
df_tree2
sum(df_tree2[df_tree2$Classe==df_tree2$Prediction,"Effectif"]) /nrow(projet_ET)

df_tree3 <- as.data.frame(table(projet_ET$Attrition, test_tree3)) 
colnames(df_tree3) = list("Classe", "Prediction", "Effectif")
df_tree3
sum(df_tree3[df_tree3$Classe==df_tree3$Prediction,"Effectif"]) /nrow(projet_ET)


#--------------------------#
# Calcul du taux de succès #
#--------------------------#
projet_ET$Tree1 <- test_tree1 
projet_ET$Tree2 <- test_tree2
projet_ET$Tree3 <- test_tree3

#Affichage des Attritions pour tree1, tree2 et tree3
View(projet_ET[,c("Attrition", "Tree1", "Tree2", "Tree3")])


#taux de succès de tree1, tree2 et tree3
taux_succes1 <- length(projet_ET[projet_ET$Attrition==projet_ET$Tree1,"Attrition"]) /nrow(projet_ET)
taux_succes1

taux_succes2 <- length(projet_ET[projet_ET$Attrition==projet_ET$Tree2,"Attrition"]) /nrow(projet_ET)
taux_succes2

taux_succes3 <- length(projet_ET[projet_ET$Attrition==projet_ET$Tree3,"Attrition"]) /nrow(projet_ET)
taux_succes3


#---------------------------------#
# TEST DE PARAMETRAGES DE RPART() #
#---------------------------------#

# Selection d'attribut par Index Gini et effectif minimal d'un noeud de 10
tree4<-rpart(Attrition~., projet_EA,parms = list(split="gini"),control =rpart.control(minbucket = 10))
prp(tree4, type=4, extra=8, box.col=c("tomato", "skyblue")[tree1$frame$yval])
prp(tree4, type=4, extra=1, box.palette = "auto")

# Selection d'attribut par Index Gini et effectif minimal d'un noeud de 5
tree5<-rpart(Attrition~., projet_EA,parms = list(split="gini"),control =rpart.control(minbucket = 5))
prp(tree5, type=4, extra=8, box.col=c("tomato", "skyblue")[tree1$frame$yval])
prp(tree5, type=4, extra=1, box.palette = "auto")

# Selection d'attribut par Index Information et effectif minimal d'un noeud de 10
tree6<-rpart(Attrition~., projet_EA,parms = list(split="information"),control =rpart.control(minbucket = 10))
prp(tree6, type=4, extra=8, box.col=c("tomato", "skyblue")[tree1$frame$yval])
prp(tree6, type=4, extra=1, box.palette = "auto")

# Selection d'attribut par Index Information et effectif minimal d'un noeud de 5
tree7<-rpart(Attrition~., projet_EA,parms = list(split="information"),control =rpart.control(minbucket = 5))
prp(tree7, type=4, extra=8, box.col=c("tomato", "skyblue")[tree1$frame$yval])
prp(tree7, type=4, extra=1, box.palette = "auto")



########### calcul du taux de succès #########
test_tree4 <- predict(tree4, projet_ET, type="class")
res_tree4 <- as.data.frame(table(projet_ET$Attrition, test_tree4))
colnames(res_tree4) = list("Classe", "Attrition", "Effectif")
sum(res_tree4[res_tree4$Classe==res_tree4$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8571429
table(test_tree4)

test_tree5 <- predict(tree5, projet_ET, type="class")
res_tree5 <- as.data.frame(table(projet_ET$Attrition, test_tree5))
colnames(res_tree5) = list("Classe", "Attrition", "Effectif")
sum(res_tree5[res_tree5$Classe==res_tree5$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8326531
table(test_tree5)

test_tree6 <- predict(tree6, projet_ET, type="class")
res_tree6 <- as.data.frame(table(projet_ET$Attrition, test_tree6))
colnames(res_tree6) = list("Classe", "Attrition", "Effectif")
sum(res_tree6[res_tree6$Classe==res_tree6$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8571429
table(test_tree6)

test_tree7 <- predict(tree7, projet_ET, type="class")
res_tree7 <- as.data.frame(table(projet_ET$Attrition, test_tree7))
colnames(res_tree7) = list("Classe", "Attrition", "Effectif")
sum(res_tree7[res_tree6$Classe==res_tree6$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8510204
table(test_tree7)


#---------------------------------#
# TEST DE PARAMETRAGES DE C5.0()  #
#---------------------------------#
 
# Selection d'attribut sans l'activation de l'élagage global et effectif minimal d'un noeud de 10
tree8<-C5.0(Attrition~., projet_EA,control = C5.0Control(noGlobalPruning = FALSE),controle = C5.0Control(minCases = 10))
plot(tree8)

# Selection d'attribut avec l'activation de l'élagage global et effectif minimal d'un noeud de 10
tree9<-C5.0(Attrition~., projet_EA,control = C5.0Control(noGlobalPruning = TRUE),controle = C5.0Control(minCases = 10))
plot(tree9)

# Selection d'attribut sans l'activation de l'élagage global et effectif minimal d'un noeud de 5
tree10<-C5.0(Attrition~., projet_EA,control = C5.0Control(noGlobalPruning = FALSE),controle = C5.0Control(minCases = 5))
plot(tree10)

# Selection d'attribut avec l'activation de l'élagage global et effectif minimal d'un noeud de 5
tree11<-C5.0(Attrition~., projet_EA,control = C5.0Control(noGlobalPruning = TRUE),controle = C5.0Control(minCases = 5))
plot(tree11)


#########calcul du taux de succès #########

test_tree8 <- predict(tree8, projet_ET, type="class")
res_tree8 <- as.data.frame(table(projet_ET$Attrition, test_tree8))
colnames(res_tree8) = list("Classe", "Attrition", "Effectif")
sum(res_tree8[res_tree8$Classe==res_tree8$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8285714
table(test_tree8)


test_tree9 <- predict(tree9, projet_ET, type="class")
res_tree9 <- as.data.frame(table(projet_ET$Attrition, test_tree9))
colnames(res_tree9) = list("Classe", "Attrition", "Effectif")
sum(res_tree9[res_tree9$Classe==res_tree9$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8285714
table(test_tree9)

test_tree10 <- predict(tree10, projet_ET, type="class")
res_tree10 <- as.data.frame(table(projet_ET$Attrition, test_tree10))
colnames(res_tree10) = list("Classe", "Attrition", "Effectif")
sum(res_tree10[res_tree10$Classe==res_tree10$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8285714 
table(test_tree10)

test_tree11 <- predict(tree11, projet_ET, type="class")
res_tree11 <- as.data.frame(table(projet_ET$Attrition, test_tree11))
colnames(res_tree11) = list("Classe", "Attrition", "Effectif")
sum(res_tree11[res_tree11$Classe==res_tree11$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8285714 
table(test_tree11)


#---------------------------------#
# TEST DE PARAMETRAGES DE TREE()  #
#---------------------------------#

# Selection d'attribut par Index Deviance et effectif minimal d'un noeud de 10
tree12<- tree(Attrition~., projet_EA, parms=list(split="deviance"), control = tree.control(nrow(projet_EA), mincut=10))
plot(tree12)
text(tree12, pretty=0)

# Selection d'attribut par Index Deviance et effectif minimal d'un noeud de 5
tree13<- tree(Attrition~., projet_EA, parms=list(split="deviance"), control = tree.control(nrow(projet_EA), mincut=5))
plot(tree13)
text(tree13, pretty=0)

# Selection d'attribut par Index Gini et effectif minimal d'un noeud de 10
tree14<- tree(Attrition~., projet_EA, parms=list(split="gini"), control = tree.control(nrow(projet_EA), mincut=10))
plot(tree14)
text(tree14, pretty=0)

# Selection d'attribut par Index Gini et effectif minimal d'un noeud de 5
tree15<- tree(Attrition~., projet_EA, parms=list(split="gini"), control = tree.control(nrow(projet_EA), mincut=5))
plot(tree15)
text(tree15, pretty=0)


###############taux de succès#####################
test_tree12 <- predict(tree12, projet_ET, type="class")
res_tree12 <- as.data.frame(table(projet_ET$Attrition, test_tree12))
colnames(res_tree12) = list("Classe", "Attrition", "Effectif")
sum(res_tree12[res_tree12$Classe==res_tree12$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8489796
table(test_tree12)

test_tree13 <- predict(tree13, projet_ET, type="class")
res_tree13<- as.data.frame(table(projet_ET$Attrition, test_tree13))
colnames(res_tree13) = list("Classe", "Attrition", "Effectif")
sum(res_tree13[res_tree13$Classe==res_tree13$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8346939
table(test_tree13)

test_tree14 <- predict(tree14, projet_ET, type="class")
res_tree14<- as.data.frame(table(projet_ET$Attrition, test_tree14))
colnames(res_tree14) = list("Classe", "Attrition", "Effectif")
sum(res_tree14[res_tree14$Classe==res_tree14$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8489796 
table(test_tree14)

test_tree15 <- predict(tree15, projet_ET, type="class")
res_tree15<- as.data.frame(table(projet_ET$Attrition, test_tree15))
colnames(res_tree15) = list("Classe", "Attrition", "Effectif")
sum(res_tree15[res_tree15$Classe==res_tree15$Attrition,"Effectif"])/nrow(projet_ET)
# 0.8346939
table(test_tree15)


#----------------------------------#
# CALCUL DES MATRICES DE CONFUSION #
#----------------------------------#

# Matrice de confusion pour 'tree1'
mc_tree1 <- table(projet_ET$Attrition, test_tree1)
print(mc_tree1)
#On affiche le nombre de faux positifs de 'tree1'
mc_tree1[1,2]
#Taux de succès
(mc_tree1[1,1]+mc_tree1[2,2])/(mc_tree1[2,2]+mc_tree1[2,1]+mc_tree1[1,1]+mc_tree1[1,2])
# Rappel
mc_tree1[2,2]/(mc_tree1[2,2]+mc_tree1[2,1])
# Spécificité
mc_tree1[1,1]/(mc_tree1[1,1]+mc_tree1[1,2])
# Précision 
mc_tree1[2,2]/(mc_tree1[2,2]+mc_tree1[1,2])
# Taux de Vrais Négatifs 
mc_tree1[1,1]/(mc_tree1[1,1]+mc_tree1[2,1])


# Matrice de confusion pour 'tree2'
mc_tree2 <- table(projet_ET$Attrition, test_tree2)
print(mc_tree2)
#On affiche le nombre de faux positifs de 'tree2'
mc_tree2[1,2]
#Taux de succès
(mc_tree2[1,1]+mc_tree2[2,2])/(mc_tree2[2,2]+mc_tree2[2,1]+mc_tree2[1,1]+mc_tree2[1,2])
# Rappel
mc_tree2[2,2]/(mc_tree2[2,2]+mc_tree2[2,1])
# Spécificité
mc_tree2[1,1]/(mc_tree2[1,1]+mc_tree2[1,2])
# Précision 
mc_tree2[2,2]/(mc_tree2[2,2]+mc_tree2[1,2])
# Taux de Vrais Négatifs
mc_tree2[1,1]/(mc_tree2[1,1]+mc_tree2[2,1])
mc_tree1 <- table(projet_ET$Attrition, test_tree1) 

# Matrice de confusion pour 'tree3'
mc_tree3 <- table(projet_ET$Attrition, test_tree3)
print(mc_tree3)
#On affiche le nombre de faux positifs de 'tree3'
mc_tree3[1,2]
#Taux de succès
(mc_tree3[1,1]+mc_tree3[2,2])/(mc_tree3[2,2]+mc_tree3[2,1]+mc_tree3[1,1]+mc_tree3[1,2])
# Rappel
mc_tree3[2,2]/(mc_tree3[2,2]+mc_tree3[2,1])
# Spécificité
mc_tree3[1,1]/(mc_tree3[1,1]+mc_tree3[1,2])
# Précision 
mc_tree3[2,2]/(mc_tree3[2,2]+mc_tree3[1,2])
# Taux de Vrais Négatifs
mc_tree3[1,1]/(mc_tree3[1,1]+mc_tree3[2,1])

# Matrice de confusion pour 'tree4'
mc_tree4 <- table(projet_ET$Attrition, test_tree4)
print(mc_tree4)
#On affiche le nombre de faux positifs de 'tree4'
mc_tree4[1,2]
#Taux de succès
(mc_tree4[1,1]+mc_tree4[2,2])/(mc_tree4[2,2]+mc_tree4[2,1]+mc_tree4[1,1]+mc_tree4[1,2])
# Rappel
mc_tree4[2,2]/(mc_tree4[2,2]+mc_tree4[2,1])
# Spécificité
mc_tree4[1,1]/(mc_tree4[1,1]+mc_tree4[1,2])
# Précision 
mc_tree4[2,2]/(mc_tree4[2,2]+mc_tree4[1,2])
# Taux de Vrais Négatifs
mc_tree4[1,1]/(mc_tree4[1,1]+mc_tree4[2,1])

# Matrice de confusion pour 'tree5'
mc_tree5 <- table(projet_ET$Attrition, test_tree5)
print(mc_tree5)
#On affiche le nombre de faux positifs de 'tree5'
mc_tree5[1,2]
#Taux de succès
(mc_tree5[1,1]+mc_tree5[2,2])/(mc_tree5[2,2]+mc_tree5[2,1]+mc_tree5[1,1]+mc_tree5[1,2])
# Rappel
mc_tree5[2,2]/(mc_tree5[2,2]+mc_tree5[2,1])
# Spécificité
mc_tree5[1,1]/(mc_tree5[1,1]+mc_tree5[1,2])
# Précision 
mc_tree5[2,2]/(mc_tree5[2,2]+mc_tree5[1,2])
# Taux de Vrais Négatifs
mc_tree5[1,1]/(mc_tree5[1,1]+mc_tree5[2,1])

# Matrice de confusion pour 'tree6'
mc_tree6 <- table(projet_ET$Attrition, test_tree6)
print(mc_tree6)
#On affiche le nombre de faux positifs de 'tree6'
mc_tree6[1,2]
#Taux de succès
(mc_tree6[1,1]+mc_tree6[2,2])/(mc_tree6[2,2]+mc_tree6[2,1]+mc_tree6[1,1]+mc_tree6[1,2])
# Rappel
mc_tree6[2,2]/(mc_tree6[2,2]+mc_tree6[2,1])
# Spécificité
mc_tree6[1,1]/(mc_tree6[1,1]+mc_tree6[1,2])
# Précision 
mc_tree6[2,2]/(mc_tree6[2,2]+mc_tree6[1,2])
# Taux de Vrais Négatifs
mc_tree6[1,1]/(mc_tree6[1,1]+mc_tree6[2,1])

# Matrice de confusion pour 'tree7'
mc_tree7 <- table(projet_ET$Attrition, test_tree7)
print(mc_tree7)
#On affiche le nombre de faux positifs de 'tree7'
mc_tree7[1,2]
#Taux de succès
(mc_tree7[1,1]+mc_tree7[2,2])/(mc_tree7[2,2]+mc_tree7[2,1]+mc_tree7[1,1]+mc_tree7[1,2])
# Rappel
mc_tree7[2,2]/(mc_tree7[2,2]+mc_tree7[2,1])
# Spécificité
mc_tree7[1,1]/(mc_tree7[1,1]+mc_tree7[1,2])
# Précision 
mc_tree7[2,2]/(mc_tree7[2,2]+mc_tree7[1,2])
# Taux de Vrais Négatifs
mc_tree7[1,1]/(mc_tree7[1,1]+mc_tree7[2,1])

# Matrice de confusion pour 'tree8'
mc_tree8 <- table(projet_ET$Attrition, test_tree8)
print(mc_tree8)
#On affiche le nombre de faux positifs de 'tree8'
mc_tree8[1,2]
#Taux de succès
(mc_tree8[1,1]+mc_tree8[2,2])/(mc_tree8[2,2]+mc_tree8[2,1]+mc_tree8[1,1]+mc_tree8[1,2])
# Rappel
mc_tree8[2,2]/(mc_tree8[2,2]+mc_tree8[2,1])
# Spécificité
mc_tree8[1,1]/(mc_tree8[1,1]+mc_tree8[1,2])
# Précision 
mc_tree8[2,2]/(mc_tree8[2,2]+mc_tree8[1,2])
# Taux de Vrais Négatifs
mc_tree8[1,1]/(mc_tree8[1,1]+mc_tree8[2,1])

# Matrice de confusion pour 'tree9'
mc_tree9 <- table(projet_ET$Attrition, test_tree9)
print(mc_tree9)
#On affiche le nombre de faux positifs de 'tree9'
mc_tree9[1,2]
#Taux de succès
(mc_tree9[1,1]+mc_tree9[2,2])/(mc_tree9[2,2]+mc_tree9[2,1]+mc_tree9[1,1]+mc_tree9[1,2])
# Rappel
mc_tree9[2,2]/(mc_tree9[2,2]+mc_tree9[2,1])
# Spécificité
mc_tree9[1,1]/(mc_tree9[1,1]+mc_tree9[1,2])
# Précision 
mc_tree9[2,2]/(mc_tree9[2,2]+mc_tree9[1,2])
# Taux de Vrais Négatifs
mc_tree9[1,1]/(mc_tree9[1,1]+mc_tree9[2,1])

# Matrice de confusion pour 'tree10'
mc_tree10 <- table(projet_ET$Attrition, test_tree10)
print(mc_tree10)
#On affiche le nombre de faux positifs de 'tree10'
mc_tree10[1,2]
#Taux de succès
(mc_tree10[1,1]+mc_tree10[2,2])/(mc_tree10[2,2]+mc_tree10[2,1]+mc_tree10[1,1]+mc_tree10[1,2])
# Rappel
mc_tree10[2,2]/(mc_tree10[2,2]+mc_tree10[2,1])
# Spécificité
mc_tree10[1,1]/(mc_tree10[1,1]+mc_tree10[1,2])
# Précision 
mc_tree10[2,2]/(mc_tree10[2,2]+mc_tree10[1,2])
# Taux de Vrais Négatifs
mc_tree10[1,1]/(mc_tree10[1,1]+mc_tree10[2,1])

# Matrice de confusion pour 'tree11'
mc_tree11 <- table(projet_ET$Attrition, test_tree11)
print(mc_tree11)
#On affiche le nombre de faux positifs de 'tree11'
mc_tree11[1,2]
#Taux de succès
(mc_tree11[1,1]+mc_tree11[2,2])/(mc_tree11[2,2]+mc_tree11[2,1]+mc_tree11[1,1]+mc_tree11[1,2])
# Rappel
mc_tree11[2,2]/(mc_tree11[2,2]+mc_tree11[2,1])
# Spécificité
mc_tree11[1,1]/(mc_tree11[1,1]+mc_tree11[1,2])
# Précision 
mc_tree11[2,2]/(mc_tree11[2,2]+mc_tree11[1,2])
# Taux de Vrais Négatifs
mc_tree11[1,1]/(mc_tree11[1,1]+mc_tree11[2,1])

# Matrice de confusion pour 'tree12'
mc_tree12 <- table(projet_ET$Attrition, test_tree12)
print(mc_tree12)
#On affiche le nombre de faux positifs de 'tree12'
mc_tree12[1,2]
#Taux de succès
(mc_tree12[1,1]+mc_tree12[2,2])/(mc_tree12[2,2]+mc_tree12[2,1]+mc_tree12[1,1]+mc_tree12[1,2])
# Rappel
mc_tree12[2,2]/(mc_tree12[2,2]+mc_tree12[2,1])
# Spécificité
mc_tree12[1,1]/(mc_tree12[1,1]+mc_tree12[1,2])
# Précision 
mc_tree12[2,2]/(mc_tree12[2,2]+mc_tree12[1,2])
# Taux de Vrais Négatifs
mc_tree12[1,1]/(mc_tree12[1,1]+mc_tree12[2,1])

# Matrice de confusion pour 'tree13'
mc_tree13 <- table(projet_ET$Attrition, test_tree13)
print(mc_tree13)
#On affiche le nombre de faux positifs de 'tree13'
mc_tree13[1,2]
#Taux de succès
(mc_tree13[1,1]+mc_tree13[2,2])/(mc_tree13[2,2]+mc_tree13[2,1]+mc_tree13[1,1]+mc_tree13[1,2])
# Rappel
mc_tree13[2,2]/(mc_tree13[2,2]+mc_tree13[2,1])
# Spécificité
mc_tree13[1,1]/(mc_tree13[1,1]+mc_tree13[1,2])
# Précision 
mc_tree13[2,2]/(mc_tree13[2,2]+mc_tree13[1,2])
# Taux de Vrais Négatifs
mc_tree13[1,1]/(mc_tree13[1,1]+mc_tree13[2,1])

# Matrice de confusion pour 'tree14'
mc_tree14 <- table(projet_ET$Attrition, test_tree14)
print(mc_tree14)
#On affiche le nombre de faux positifs de 'tree14'
mc_tree14[1,2]
#Taux de succès
(mc_tree14[1,1]+mc_tree14[2,2])/(mc_tree14[2,2]+mc_tree14[2,1]+mc_tree14[1,1]+mc_tree14[1,2])
# Rappel
mc_tree14[2,2]/(mc_tree14[2,2]+mc_tree14[2,1])
# Spécificité
mc_tree14[1,1]/(mc_tree14[1,1]+mc_tree14[1,2])
# Précision 
mc_tree14[2,2]/(mc_tree14[2,2]+mc_tree14[1,2])
# Taux de Vrais Négatifs
mc_tree14[1,1]/(mc_tree14[1,1]+mc_tree14[2,1])

# Matrice de confusion pour 'tree15'
mc_tree15 <- table(projet_ET$Attrition, test_tree15)
print(mc_tree15)
#On affiche le nombre de faux positifs de 'tree15'
mc_tree15[1,2]
#Taux de succès
(mc_tree15[1,1]+mc_tree15[2,2])/(mc_tree15[2,2]+mc_tree15[2,1]+mc_tree15[1,1]+mc_tree15[1,2])
# Rappel
mc_tree15[2,2]/(mc_tree15[2,2]+mc_tree15[2,1])
# Spécificité
mc_tree15[1,1]/(mc_tree15[1,1]+mc_tree15[1,2])
# Précision 
mc_tree15[2,2]/(mc_tree15[2,2]+mc_tree15[1,2])
# Taux de Vrais Négatifs
mc_tree15[1,1]/(mc_tree15[1,1]+mc_tree15[2,1])


#------------#
# Courbe ROC #
#------------#

#Courbe ROC de tree1

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree1 <- predict(tree1, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred1 <- prediction(prob_tree1[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf1 <- performance(roc_pred1,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf1, col = "green")


#Courbe ROC de tree2

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree2 <- predict(tree2, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred2 <- prediction(prob_tree2[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf2 <- performance(roc_pred2,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf2, col = "red",add=TRUE)


#Courbe ROC de tree3

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree3 <- predict(tree3, projet_ET, type = "vector") 
# Génération des donnees necessaires pour la courbe ROC
roc_pred3 <- prediction(prob_tree3[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf3 <- performance(roc_pred3,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf3, col = "blue",add=TRUE)


#Courbe ROC de tree4
# Génération des probabilites de prediction sur l'ensemble de test
prob_tree4 <- predict(tree4, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred4 <- prediction(prob_tree4[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf4 <- performance(roc_pred4,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf4, col = "darkgreen")


#Courbe ROC de tree5

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree5 <- predict(tree5, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred5 <- prediction(prob_tree5[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf5 <- performance(roc_pred5,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf5, col = "black", add=TRUE)


#Courbe ROC de tree6

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree6 <- predict(tree6, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred6 <- prediction(prob_tree6[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf6 <- performance(roc_pred6,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf6, col = "blue",add=TRUE)


#Courbe ROC de tree7

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree7 <- predict(tree7, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred7 <- prediction(prob_tree7[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf7 <- performance(roc_pred7,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf7, col = "pink",add=TRUE)


#Courbe ROC de tree8

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree8 <- predict(tree8, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred8 <- prediction(prob_tree8[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf8 <- performance(roc_pred8,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf8, col = "navy")


#Courbe ROC de tree9

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree9 <- predict(tree9, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred9 <- prediction(prob_tree9[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf9 <- performance(roc_pred9,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf9, col = "purple",add=TRUE)


#Courbe ROC de tree10

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree10 <- predict(tree10, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred10 <- prediction(prob_tree10[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf10 <- performance(roc_pred10,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf10, col = "gold",add=TRUE)


#Courbe ROC de tree11

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree11 <- predict(tree11, projet_ET, type = "prob")
# Génération des donnees necessaires pour la courbe ROC
roc_pred11 <- prediction(prob_tree11[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf11 <- performance(roc_pred11,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf11, col = "magenta",add=TRUE)


#Courbe ROC de tree12

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree12 <- predict(tree12, projet_ET, type = "vector") 
# Génération des donnees necessaires pour la courbe ROC
roc_pred12 <- prediction(prob_tree12[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf12 <- performance(roc_pred12,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf12, col = "grey")


#Courbe ROC de tree13

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree13 <- predict(tree13, projet_ET, type = "vector") 
# Génération des donnees necessaires pour la courbe ROC
roc_pred13 <- prediction(prob_tree13[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf13 <- performance(roc_pred13,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf13, col = "coral",add=TRUE)


#Courbe ROC de tree14

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree14 <- predict(tree14, projet_ET, type = "vector") 
# Génération des donnees necessaires pour la courbe ROC
roc_pred14 <- prediction(prob_tree14[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf14 <- performance(roc_pred14,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf14, col = "brown",add=TRUE)


#Courbe ROC de tree15

# Génération des probabilites de prediction sur l'ensemble de test
prob_tree15 <- predict(tree15, projet_ET, type = "vector") 
# Génération des donnees necessaires pour la courbe ROC
roc_pred15 <- prediction(prob_tree15[,2], projet_ET$Attrition)
# Calcul des taux de vrais positifs (tpr) et taux de faux positifs (fpr)
roc_perf15 <- performance(roc_pred15,"tpr","fpr") 
# Tracage de la  courbe ROC
plot(roc_perf15, col = "darkgreen",add=TRUE)


#------------------------#
# Calcul des indices AUC #
#------------------------#

# Calcul de l'AUC à partir des données générées : arbre 'tree1'
auc_tree1 <- performance(roc_pred1, "auc")
# Affichage de la structure de l'objet 'auc_tree1' généré
str(auc_tree1)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree1'
attr(auc_tree1, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree2'
auc_tree2 <- performance(roc_pred2, "auc")
# Affichage de la structure de l'objet 'auc_tree2' généré
str(auc_tree2)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree2'
attr(auc_tree2, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree3'
auc_tree3 <- performance(roc_pred3, "auc")
# Affichage de la structure de l'objet 'auc_tree3' généré
str(auc_tree3)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree3'
attr(auc_tree3, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree4'
auc_tree4 <- performance(roc_pred4, "auc")
# Affichage de la structure de l'objet 'auc_tree4' généré
str(auc_tree4)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree4'
attr(auc_tree4, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree5'
auc_tree5 <- performance(roc_pred5, "auc")
# Affichage de la structure de l'objet 'auc_tree5' généré
str(auc_tree5)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree5'
attr(auc_tree5, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree6'
auc_tree6 <- performance(roc_pred6, "auc")
# Affichage de la structure de l'objet 'auc_tree6' généré
str(auc_tree6)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree6'
attr(auc_tree6, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree7'
auc_tree7 <- performance(roc_pred7, "auc")
# Affichage de la structure de l'objet 'auc_tree7' généré
str(auc_tree7)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree7'
attr(auc_tree7, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree8'
auc_tree8 <- performance(roc_pred8, "auc")
# Affichage de la structure de l'objet 'auc_tree8' généré
str(auc_tree8)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree8'
attr(auc_tree8, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree9'
auc_tree9 <- performance(roc_pred9, "auc")
# Affichage de la structure de l'objet 'auc_tree9' généré
str(auc_tree9)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree9'
attr(auc_tree9, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree10'
auc_tree10 <- performance(roc_pred10, "auc")
# Affichage de la structure de l'objet 'auc_tree10' généré
str(auc_tree10)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree10'
attr(auc_tree10, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree11'
auc_tree11 <- performance(roc_pred11, "auc")
# Affichage de la structure de l'objet 'auc_tree11' généré
str(auc_tree11)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree11'
attr(auc_tree11, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree1'
auc_tree12 <- performance(roc_pred12, "auc")
# Affichage de la structure de l'objet 'auc_tree12' généré
str(auc_tree12)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree12'
attr(auc_tree12, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree13'
auc_tree13 <- performance(roc_pred13, "auc")
# Affichage de la structure de l'objet 'auc_tree13' généré
str(auc_tree13)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree13'
attr(auc_tree13, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree14'
auc_tree14 <- performance(roc_pred14, "auc")
# Affichage de la structure de l'objet 'auc_tree14' généré
str(auc_tree14)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree14'
attr(auc_tree14, "y.values")

# Calcul de l'AUC à partir des données générées : arbre 'tree15'
auc_tree15 <- performance(roc_pred15, "auc")
# Affichage de la structure de l'objet 'auc_tree15' généré
str(auc_tree15)
# Affichage de la valeur de l'AUC stockee dans l'attribut 'y.values' de 'auc_tree15'
attr(auc_tree15, "y.values")



#------------------------------------------#
# Affichage graphique et Boîte à moustache #
#------------------------------------------#

table(projet1$Attrition)
table(projet_EA$Attrition)
table(projet_ET$Attrition)


# Comparaison des effectifs des classes dans les 3 ensembles
qplot(projet1$Attrition, data=projet1, fill=projet1$Attrition)
qplot(projet_EA$Attrition, data=projet_EA, fill=projet_EA$Attrition)
qplot(projet_ET$Attrition, data=projet_ET, fill=projet_ET$Attrition)

# Diagrammes circulaire en secteurs de variables discretes
pie(table(projet1$Attrition), main = "Répartition des classes")
pie(table(projet_EA$Attrition), main = "Répartition des classes")
pie(table(projet_ET$Attrition), main = "Répartition des classes")

t=as.numeric(projet1$Attrition)
summary(t)
t1=as.numeric(projet_EA$Attrition)
summary(t1)
t2=as.numeric(projet_ET$Attrition)
summary(t2)
#On voit que ET et EA sont bien représentatifs pour la variable Attrition



# Comparaison des proportions des classes pour 'MaritalStatus' par histogrammes
qplot(projet1$MaritalStatus , data=projet1, fill=projet1$Attrition)
qplot(projet_EA$MaritalStatus , data=projet_EA, fill=projet_EA$Attrition)
qplot(projet_ET$MaritalStatus , data=projet_ET, fill=projet_ET$Attrition)


# Comparaison des distribution des valeurs de 'MaritalStatus' pour chaque classe par boxplots
boxplot(as.numeric(MaritalStatus)~Attrition, data=projet1, col=c("red","blue"), main="MaritalStatus selon Attrition dans projet", 
        ylab="MaritalStatus", xlab="Attrition")
boxplot(as.numeric(MaritalStatus)~Attrition, data=projet_EA,col=c("red","blue"), main="MaritalStatus selon Attrition dans projet_EA", 
        ylab="MaritalStatus", xlab="Attrition")
boxplot(as.numeric(MaritalStatus)~Attrition, data=projet_ET,col=c("red","blue"), main="MaritalStatus selon Attrition dans projet_ET", 
        ylab="MaritalStatus", xlab="Attrition")



# Comparaison des proportions des classes pour 'OverTime' par histogrammes
qplot(projet1$OverTime, data=projet1, fill=projet1$Attrition)
qplot(projet_EA$OverTime, data=projet_EA, fill=Attrition)
qplot(projet_ET$OverTime, data=projet_ET, fill=projet_ET$Attrition)

# Comparaison des proportions des classes pour 'OverTime' par diagramme circulaire
pie(table(projet1$OverTime), main = "Répartition des OverTime")
pie(table(projet_EA$OverTime), main = "Répartition des OverTime")
pie(table(projet_ET$OverTime), main = "Répartition des OverTime")

# Comparaison des distribution des valeurs de 'OverTime' pour chaque classe par boxplots
boxplot(as.numeric(OverTime)~Attrition, data=projet1, col=c("red","blue"), main="OverTime selon Attrition dans projet1", 
        ylab="OverTime", xlab="Attrition")
boxplot(as.numeric(OverTime)~Attrition, data=projet_EA, col=c("red","blue"), main="OverTime selon Attrition dans projet_EA", 
        ylab="OverTime", xlab="Attrition")
boxplot(as.numeric(OverTime)~Attrition, data=projet_ET,col=c("red","blue"), main="OverTime selon Attrition dans projet_ET", 
        ylab="OverTime", xlab="Attrition")



# Comparaison des proportions des classes pour 'MonthlyIncome' par histogrammes
qplot(projet1$MonthlyIncome, data=projet1, fill=projet1$Attrition)
qplot(projet_EA$MonthlyIncome, data=projet_EA, fill=Attrition)
qplot(projet_ET$MonthlyIncome, data=projet_ET, fill=Attrition)

# Comparaison des distribution des valeurs de 'MonthlyIncome' pour chaque classe par boxplots
boxplot(MonthlyIncome~Attrition, data=projet1, col=c("red","blue"), main="MonthlyIncome selon Attrition dans projet1", 
        ylab="MonthlyIncome", xlab="Attrition")
boxplot(MonthlyIncome~Attrition, data=projet_EA, col=c("red","blue"), main="MonthlyIncome selon Attrition dans projet_EA", 
        ylab="MonthlyIncome", xlab="Attrition")
boxplot(MonthlyIncome~Attrition, data=projet_ET,col=c("red","blue"), main="MonthlyIncome selon Attrition dans projet_ET", 
        ylab="MonthlyIncome", xlab="Attrition")



# Comparaison des proportions des classes pour 'JobRole' par histogrammes
qplot(projet1$JobRole, data=projet1, fill=projet1$Attrition)
qplot(projet_EA$JobRole, data=projet_EA, fill=projet_EA$Attrition)
qplot(projet_ET$JobRole, data=projet_ET, fill=projet_ET$Attrition)

#Comparaison des proportions des classes pour 'JobRole' par diagramme circulaire
pie(table(projet1$JobRole), main = "Répartition des JobRole")
pie(table(projet_EA$JobRole), main = "Répartition des JobRole")
pie(table(projet_ET$JobRole), main = "Répartition des JobRole")

# Comparaison des distribution des valeurs de 'JobRole' pour chaque classe par boxplots
boxplot(as.numeric(JobRole)~Attrition, data=projet1, col=c("red","blue"), main="JobRole selon Attrition dans projet1", 
        ylab="JobRole", xlab="Attrition")
boxplot(as.numeric(JobRole)~Attrition, data=projet_EA, col=c("red","blue"), main="JobRole selon Attrition dans projet_EA", 
        ylab="JobRole", xlab="Attrition")
boxplot(as.numeric(JobRole)~Attrition, data=projet_ET,col=c("red","blue"), main="JobRole selon Attrition dans projet_ET", 
        ylab="JobRole", xlab="Attrition")



# Comparaison des proportions des classes pour 'StockOptionLevel' par histogrammes
qplot(projet1$StockOptionLevel, data=projet1, fill=projet1$Attrition)
qplot(projet_EA$StockOptionLevel, data=projet_EA, fill=projet_EA$Attrition)
qplot(projet_ET$StockOptionLevel, data=projet_ET, fill=projet_ET$Attrition)

# Nuages de points des variables continues StockOptionLevel
qplot(projet1$Attrition, projet1$StockOptionLevel, data=projet1, main="Nuage de point de Attrition et StockOptionLevel ", xlab="Valeur de Attrition", ylab="Valeur de StockOptionLevel ", color=projet1$Attrition) + geom_jitter(width = 0.35, height = 0.35)
qplot(projet_EA$Attrition, projet_EA$StockOptionLevel, data=projet_EA, main="Nuage de point de Attrition et StockOptionLevel ", xlab="Valeur de Attrition", ylab="Valeur de StockOptionLevel ", color=projet_EA$Attrition) + geom_jitter(width = 0.35, height = 0.35)
qplot(projet_ET$Attrition, projet_ET$StockOptionLevel, data=projet_ET, main="Nuage de point de Attrition et StockOptionLevel ", xlab="Valeur de Attrition", ylab="Valeur de StockOptionLevel ", color=projet_ET$Attrition) + geom_jitter(width = 0.35, height = 0.35)

#Comparaison des proportions des classes pour 'StockOptionLevel' par diagramme circulaire
pie(table(projet1$StockOptionLevel), main = "Répartition des StockOptionLevel")
pie(table(projet_EA$StockOptionLevel), main = "Répartition des StockOptionLevel")
pie(table(projet_ET$StockOptionLevel), main = "Répartition des StockOptionLevel")

# Comparaison des distribution des valeurs de 'StockOptionLevel' pour chaque classe par boxplots
boxplot(StockOptionLevel~Attrition, data=projet1, col=c("red","blue"), main="StockOptionLevel selon Attrition dans projet1", 
        ylab="StockOptionLevel", xlab="Attrition")
boxplot(StockOptionLevel~Attrition, data=projet_EA, col=c("red","blue"), main="StockOptionLevel selon Attrition dans projet_EA", 
        ylab="StockOptionLevel", xlab="Attrition")
boxplot(StockOptionLevel~Attrition, data=projet_ET,col=c("red","blue"), main="StockOptionLevel selon Attrition dans projet_ET", 
        ylab="StockOptionLevel", xlab="Attrition")


# Comparaison des proportions des classes pour 'DistanceFromHome' par histogrammes
qplot(projet1$DistanceFromHome, data=projet1, fill=projet1$Attrition)
qplot(projet_EA$DistanceFromHome, data=projet_EA, fill=projet_EA$Attrition)
qplot(projet_ET$DistanceFromHome, data=projet_ET, fill=projet_ET$Attrition)

# Nuages de points des variables continues DistanceFromHome
qplot(projet1$Attrition, projet1$DistanceFromHome , data=projet1, main="Nuage de point de Attrition et DistanceFromHome", xlab="Valeur de Attrition", ylab="Valeur de DistanceFromHome ", color=projet1$Attrition) + geom_jitter(width = 0.35, height = 0.35)
qplot(projet_EA$Attrition, projet_EA$DistanceFromHome , data=projet_EA, main="Nuage de point de Attrition et DistanceFromHome", xlab="Valeur de Attrition", ylab="Valeur de DistanceFromHome ", color=projet_EA$Attrition) + geom_jitter(width = 0.35, height = 0.35)
qplot(projet_ET$Attrition, projet_ET$DistanceFromHome , data=projet_ET, main="Nuage de point de Attrition et DistanceFromHome", xlab="Valeur de Attrition", ylab="Valeur de DistanceFromHome ", color=projet_ET$Attrition) + geom_jitter(width = 0.35, height = 0.35)

# Comparaison des distribution des valeurs de 'DistanceFromHome' pour chaque classe par boxplots
boxplot(DistanceFromHome~Attrition, data=projet1, col=c("red","blue"), main="DistanceFromHome selon Attrition dans projet1", 
        ylab="DistanceFromHome", xlab="Attrition")
boxplot(DistanceFromHome~Attrition, data=projet_EA, col=c("red","blue"), main="DistanceFromHome selon Attrition dans projet_EA", 
        ylab="DistanceFromHome", xlab="Attrition")
boxplot(DistanceFromHome~Attrition, data=projet_ET,col=c("red","blue"), main="DistanceFromHome selon Attrition dans projet_ET", 
        ylab="DistanceFromHome", xlab="Attrition")



#-------------------------------------------#
# GENERATION DES PROBABILITES DE PREDICTION #
#-------------------------------------------#

projetNew <- subset(projetNew, select=-StandardHours)
projetNew <- subset(projetNew, select=-Over18)
projetNew <- subset(projetNew, select=-EmployeeCount)
str(projetNew)

#On applique tree6 à ProjetNew pour prédire les Attritions
pred_testProjetNew <- predict(tree6, projetNew, type="class") 
table(pred_testProjetNew)

#On ajoute la colonne des predictions à projetNew
projetNew$Prediction <- pred_testProjetNew
View(projetNew)

# Generation des probabilites pour chaque exemple de test pour l'arbre 'tree6'
prob_tree <- predict(tree6, projetNew, type="prob")

# Affichage des deux vecteurs de probabilites generes
print(prob_tree)

# Affichage du vecteur de probabilites de prediction 'Oui'
prob_tree[,2]

# Affichage du vecteur de probabilites de prediction 'Non'
prob_tree[,1]

# Construction d'un data frame contenant classe reelle, prediction et probabilités des predictions
df_resultat <- data.frame(projetNew[0],pred_testProjetNew , prob_tree[,2], prob_tree[,1])
View(df_resultat)

# Rennomage des colonnes afin d'en faciliter la lecture et les manipulations
colnames(df_resultat) = list("Prediction", "P(Oui)", "P(Non)")
summary(df_resultat)
View(df_resultat)

#Ajout des Attritions prédites à projetNew
projetNew$OUI<-prob_tree[,2]
projetNew$NON<-prob_tree[,1]
View(projetNew)

# Quartiles et moyenne des probabilites des predictions 'Oui' pour l'arbre 'tree1'
summary(df_resultat)


#--------------------------------------------------------------#
#Création du fichier csv, comprennant les prédictions trouvées #
#--------------------------------------------------------------#

#Création d'un nouveau fichier csv
write.table(projetNew,file='resultats.csv', sep="\t", dec=".", row.names = F)

#lecture du fichier
projetF<- read.csv("resultats.csv", header = TRUE, sep = "\t", dec = ".",stringsAsFactors = T) 

#Affichage du fichier de données
View(projetF)

#Affichage des probabilités pour chaque instance
summary(projetF)








