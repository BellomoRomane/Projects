#-------------------------#
# PREPARATION DES DONNEES # 
#-------------------------#

setwd("C:/Users/33666/Documents/Projects/Attrition")


# Chargement des donnees
projet1 <- read.csv("Data_Projet1.csv", header = TRUE, sep = ";", dec = ".", stringsAsFactors = T) 
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

# Functions for training trees
train_tree <- function(model, data) {
  return(model(Attrition ~ ., data = data))
}

# Train different trees
tree_names <- c("rpart", "C5.0", "tree")
tree_models <- list(
  rpart = function() rpart(Attrition ~ ., data = projet_EA, parms = list(split = "gini"), control = rpart.control(minbucket = 10)),
  C5.0 = function() C5.0(Attrition ~ ., data = projet_EA, control = C5.0Control(noGlobalPruning = FALSE, minCases = 10)),
  tree = function() tree(Attrition ~ ., data = projet_EA, parms = list(split = "deviance"), control = tree.control(nrow(projet_EA), mincut = 10))
)

success_rates <- data.frame(Tree = character(), Success_Rate = numeric())

for (name in tree_names) {
  train_func <- tree_models[[name]]
  model <- train_tree(train_func, data = projet_ET)
  predictions <- predict(model, newdata = projet_ET, type = "class")
  success_rate <- sum(predictions == projet_ET$Attrition) / nrow(projet_ET)
  success_rates <- rbind(success_rates, data.frame(Tree = name, Success_Rate = success_rate))
}
# Display success rates table
print(success_rates)


library(rpart)
library(C50)

# Train decision trees
tree1 <- rpart(Attrition ~ ., data = projet_EA)
tree2 <- C5.0(Attrition ~ ., data = projet_EA)
tree3 <- tree(Attrition ~ ., data = projet_EA)

# Plot decision trees
par(mfrow=c(1, 3))
plot(tree1)
plot(tree2, type = "simple")
plot(tree3)
par(mfrow=c(1, 1))  # Reset plotting settings

# Generate predicted classes
test_tree1 <- predict(tree1, newdata = projet_ET, type = "class")
test_tree2 <- predict(tree2, newdata = projet_ET, type = "class")
test_tree3 <- predict(tree3, newdata = projet_ET, type = "class")

# Detailed comparison of predictions
comparison_tree1 <- table(Actual = projet_ET$Attrition, Predicted = test_tree1)
comparison_tree2 <- table(Actual = projet_ET$Attrition, Predicted = test_tree2)
comparison_tree3 <- table(Actual = projet_ET$Attrition, Predicted = test_tree3)

# Calculate success rates
success_rate_tree1 <- sum(diag(comparison_tree1)) / sum(comparison_tree1)
success_rate_tree2 <- sum(diag(comparison_tree2)) / sum(comparison_tree2)
success_rate_tree3 <- sum(diag(comparison_tree3)) / sum(comparison_tree3)

# Detailed success rates
success_rates <- data.frame(
  Tree = c("Tree1", "Tree2", "Tree3"),
  Success_Rate = c(success_rate_tree1, success_rate_tree2, success_rate_tree3)
)
success_rate

# Parameter tuning for rpart
parameter_results <- list()
for (split_method in c("gini", "information")) {
  for (minbucket in c(5, 10)) {
    tree <- rpart(
      Attrition ~ ., 
      data = projet_EA, 
      parms = list(split = split_method), 
      control = rpart.control(minbucket = minbucket)
    )
    predicted_classes <- predict(tree, newdata = projet_ET, type = "class")
    comparison <- table(Actual = projet_ET$Attrition, Predicted = predicted_classes)
    success_rate <- sum(diag(comparison)) / sum(comparison)
    parameter_results <- c(
      parameter_results,
      list(
        split_method = split_method,
        minbucket = minbucket,
        success_rate = success_rate
      )
    )
  }
}

# Parameter tuning for C5.0
c50_parameter_results <- list()
for (global_pruning in c(TRUE, FALSE)) {
  for (min_cases in c(5, 10)) {
    tree <- C5.0(
      Attrition ~ ., 
      data = projet_EA,
      control = C5.0Control(noGlobalPruning = global_pruning), 
      controle = C5.0Control(minCases = min_cases)
    )
    predicted_classes <- predict(tree, newdata = projet_ET, type = "class")
    comparison <- table(Actual = projet_ET$Attrition, Predicted = predicted_classes)
    success_rate <- sum(diag(comparison)) / sum(comparison)
    c50_parameter_results <- c(
      c50_parameter_results,
      list(
        global_pruning = global_pruning,
        min_cases = min_cases,
        success_rate = success_rate
      )
    )
  }
}

# Parameter tuning for tree
tree_parameter_results <- list()
for (split_method in c("deviance", "gini")) {
  for (mincut in c(5, 10)) {
    tree <- tree(
      Attrition ~ ., 
      data = projet_EA,
      parms = list(split = split_method),
      control = tree.control(nrow(projet_EA), mincut = mincut)
    )
    predicted_classes <- predict(tree, newdata = projet_ET, type = "class")
    comparison <- table(Actual = projet_ET$Attrition, Predicted = predicted_classes)
    success_rate <- sum(diag(comparison)) / sum(comparison)
    tree_parameter_results <- c(
      tree_parameter_results,
      list(
        split_method = split_method,
        mincut = mincut,
        success_rate = success_rate
      )
    )
  }
}

# Store all results in detail
results <- list(
  tree1 = list(
    decision_tree = tree1,
    predicted_classes = test_tree1,
    comparison = comparison_tree1,
    success_rate = success_rate_tree1
  ),
  tree2 = list(
    decision_tree = tree2,
    predicted_classes = test_tree2,
    comparison = comparison_tree2,
    success_rate = success_rate_tree2
  ),
  tree3 = list(
    decision_tree = tree3,
    predicted_classes = test_tree3,
    comparison = comparison_tree3,
    success_rate = success_rate_tree3
  ),
  parameter_tuning_rpart = parameter_results,
  parameter_tuning_c50 = c50_parameter_results,
  parameter_tuning_tree = tree_parameter_results
)

# Access the results as needed
# Convert C5.0 parameter tuning results to a data frame
c50_parameter_results_df <- do.call(rbind, c50_parameter_results)
c50_parameter_results_df <- data.frame(
  Model = "C5.0",
  Global_Pruning = sapply(c50_parameter_results_df, function(x) x$global_pruning),
  Min_Cases = sapply(c50_parameter_results_df, function(x) x$min_cases),
  Success_Rate = sapply(c50_parameter_results_df, function(x) x$success_rate)
)

# Convert rpart parameter tuning results to a data frame
rpart_parameter_results_df <- do.call(rbind, parameter_results)
rpart_parameter_results_df <- data.frame(
  Model = "rpart",
  Split_Method = sapply(rpart_parameter_results_df, function(x) x$split_method),
  Minbucket = sapply(rpart_parameter_results_df, function(x) x$minbucket),
  Success_Rate = sapply(rpart_parameter_results_df, function(x) x$success_rate)
)

# Convert tree parameter tuning results to a data frame
tree_parameter_results_df <- do.call(rbind, tree_parameter_results)
tree_parameter_results_df <- data.frame(
  Model = "tree",
  Split_Method = sapply(tree_parameter_results_df, function(x) x$split_method),
  Mincut = sapply(tree_parameter_results_df, function(x) x$mincut),
  Success_Rate = sapply(tree_parameter_results_df, function(x) x$success_rate)
)

# Combine all results into a single dataframe
all_results <- rbind(c50_parameter_results_df, rpart_parameter_results_df, tree_parameter_results_df)

# Display the combined results
print(all_results)



# Function to calculate confusion matrix and other metrics
calculate_metrics <- function(tree_model, model_name, parameters, data) {
  # Predict classes
  predictions <- predict(tree_model, newdata = data, type = "class")
  
  # Calculate confusion matrix
  confusion_matrix <- table(Actual = data$Attrition, Predicted = predictions)
  
  # Calculate True Positives, False Positives, True Negatives, False Negatives
  TP <- confusion_matrix[2, 2]
  FP <- confusion_matrix[1, 2]
  TN <- confusion_matrix[1, 1]
  FN <- confusion_matrix[2, 1]
  
  # Calculate Recall (Sensitivity)
  Recall <- TP / (TP + FN)
  
  # Calculate Specificity
  Specificity <- TN / (TN + FP)
  
  # Calculate Precision
  Precision <- TP / (TP + FP)
  
  # Calculate False Positive Rate
  FPR <- FP / (FP + TN)
  
  # Calculate True Negative Rate
  TNR <- TN / (TN + FP)
  
  # Calculate Success Rate
  Success_Rate <- sum(predictions == data$Attrition) / nrow(data)
  
  # Create a dataframe to store the metrics
  metrics_df <- data.frame(
    Model_Name = model_name,
    Parameters = parameters,
    False_Positives = FP,
    Success_Rate = Success_Rate,
    Recall = Recall,
    Specificity = Specificity,
    Precision = Precision,
    False_Positive_Rate = FPR,
    True_Negative_Rate = TNR
  )
  
  # Print confusion matrix
  cat("Confusion Matrix for", model_name, "with parameters:", parameters, "\n")
  print(confusion_matrix)
  
  # Return metrics dataframe
  return(metrics_df)
}

# Calculate metrics for each tree model
metrics_tree1 <- calculate_metrics(tree1, "rpart", "split = gini, minbucket = 10", projet_ET)
metrics_tree2 <- calculate_metrics(tree2, "C5.0", "", projet_ET)
metrics_tree3 <- calculate_metrics(tree3, "tree", "split = deviance, mincut = 5", projet_ET)

# Combine metrics for all trees into a single dataframe
all_metrics <- rbind(metrics_tree1, metrics_tree2, metrics_tree3)

# Print the dataframe containing metrics
print(all_metrics)



# List to store metrics dataframes
all_metrics <- list()

# Calculate metrics for each tree model
for (i in 1:length(results)) {
  if (length(results[[i]]) == 5) {  # This indicates it's a tree model
    model_name <- names(results)[i]
    parameters <- paste(results[[i]][[1]]$parms$split, results[[i]][[1]]$parms$minbucket, sep = ", ")
    metrics <- calculate_metrics(results[[i]][[1]], model_name, parameters, projet_ET)
    all_metrics[[length(all_metrics) + 1]] <- metrics
  } else {  # This indicates it's a parameter tuning result
    for (j in 1:nrow(results[[i]])) {
      model_name <- paste(names(results)[i], "_", j, sep = "")
      parameters <- paste(results[[i]][j, "split_method"], results[[i]][j, "minbucket"], sep = ", ")
      metrics <- calculate_metrics(results[[i]][[j, "decision_tree"]], model_name, parameters, projet_ET)
      all_metrics[[length(all_metrics) + 1]] <- metrics
    }
  }
}

# Combine metrics for all trees into a single dataframe
all_metrics_df <- do.call(rbind, all_metrics)

# Print the dataframe containing metrics
print(all_metrics_df)




# Initialize an empty dataframe to store all metrics
all_metrics <- data.frame(
  Model_Name = character(),
  Parameters = character(),
  False_Positives = numeric(),
  Success_Rate = numeric(),
  Recall = numeric(),
  Specificity = numeric(),
  Precision = numeric(),
  False_Positive_Rate = numeric(),
  True_Negative_Rate = numeric()
)

# Function to calculate metrics for parameter tuning
calculate_metrics_parameter_tuning <- function(model_name, parameters, tree_model, data) {
  # Predict classes
  predictions <- predict(tree_model, newdata = data, type = "class")
  
  # Calculate confusion matrix
  confusion_matrix <- table(Actual = data$Attrition, Predicted = predictions)
  
  # Calculate True Positives, False Positives, True Negatives, False Negatives
  TP <- confusion_matrix[2, 2]
  FP <- confusion_matrix[1, 2]
  TN <- confusion_matrix[1, 1]
  FN <- confusion_matrix[2, 1]
  
  # Calculate Recall (Sensitivity)
  Recall <- TP / (TP + FN)
  
  # Calculate Specificity
  Specificity <- TN / (TN + FP)
  
  # Calculate Precision
  Precision <- TP / (TP + FP)
  
  # Calculate False Positive Rate
  FPR <- FP / (FP + TN)
  
  # Calculate True Negative Rate
  TNR <- TN / (TN + FP)
  
  # Calculate Success Rate
  Success_Rate <- sum(predictions == data$Attrition) / nrow(data)
  
  # Create a dataframe to store the metrics
  metrics_df <- data.frame(
    Model_Name = model_name,
    Parameters = parameters,
    False_Positives = FP,
    Success_Rate = Success_Rate,
    Recall = Recall,
    Specificity = Specificity,
    Precision = Precision,
    False_Positive_Rate = FPR,
    True_Negative_Rate = TNR
  )
  
  # Print confusion matrix
  cat("Confusion Matrix for", model_name, "with parameters:", parameters, "\n")
  print(confusion_matrix)
  
  # Return metrics dataframe
  return(metrics_df)
}

# Parameter tuning for rpart
parameter_results_rpart <- list()
for (split_method in c("gini", "information")) {
  for (minbucket in c(5, 10)) {
    # Create rpart model with current parameters
    tree_model <- rpart(
      Attrition ~ ., 
      data = projet_EA, 
      parms = list(split = split_method), 
      control = rpart.control(minbucket = minbucket)
    )
    
    # Calculate metrics and store results
    metrics <- calculate_metrics_parameter_tuning("rpart", paste("split =", split_method, ", minbucket =", minbucket), tree_model, projet_ET)
    
    # Add metrics to the dataframe
    all_metrics <- rbind(all_metrics, metrics)
  }
}

# Parameter tuning for C5.0
parameter_results_c50 <- list()
for (global_pruning in c(TRUE, FALSE)) {
  for (min_cases in c(5, 10)) {
    # Create C5.0 model with current parameters
    tree_model <- C5.0(
      Attrition ~ ., 
      data = projet_EA,
      control = C5.0Control(noGlobalPruning = global_pruning), 
      controle = C5.0Control(minCases = min_cases)
    )
    
    # Calculate metrics and store results
    metrics <- calculate_metrics_parameter_tuning("C5.0", paste("noGlobalPruning =", global_pruning, ", minCases =", min_cases), tree_model, projet_ET)
    
    # Add metrics to the dataframe
    all_metrics <- rbind(all_metrics, metrics)
  }
}

# Parameter tuning for tree
parameter_results_tree <- list()
for (split_method in c("deviance", "gini")) {
  for (mincut in c(5, 10)) {
    # Create tree model with current parameters
    tree_model <- tree(
      Attrition ~ ., 
      data = projet_EA,
      parms = list(split = split_method),
      control = tree.control(nrow(projet_EA), mincut = mincut)
    )
    
    # Calculate metrics and store results
    metrics <- calculate_metrics_parameter_tuning("tree", paste("split =", split_method, ", mincut =", mincut), tree_model, projet_ET)
    
    # Add metrics to the dataframe
    all_metrics <- rbind(all_metrics, metrics)
  }
}

# Print the dataframe containing all metrics
print(all_metrics)



# Function to calculate ROC curve and plot
calculate_roc_and_plot <- function(model_name, tree_model, data) {
  auc_values <- c()
  for (i in 1:nrow(tree_model)) {
    # Extract tuning parameters
    params <- tree_model[i, ]
    
    # Train model with tuning parameters
    model <- train_tree(tree_model = model_name, params = params)
    
    # Predict classes and probabilities
    predictions <- predict(model, newdata = data, type = "prob")[, 2]
    
    # Calculate ROC curve
    roc_curve <- roc(data$Attrition, predictions)
    
    # Plot ROC curve
    plot(roc_curve, add = TRUE, col = rainbow(nrow(tree_model))[i])
    
    # Calculate AUC value
    auc_value <- auc(roc_curve)
    
    # Store AUC value
    auc_values <- c(auc_values, auc_value)
  }
  
  # Return AUC values
  return(auc_values)
}

# Initialize an empty plot
plot(NA, xlim = c(0, 1), ylim = c(0, 1), type = "n", xlab = "False Positive Rate", ylab = "True Positive Rate", main = "ROC Curve for Tuned Tree Models")

# Calculate and plot ROC curves for rpart
auc_values_rpart <- calculate_roc_and_plot("rpart", parameter_tuning_rpart, projet_ET)

# Calculate and plot ROC curves for C5.0
auc_values_c50 <- calculate_roc_and_plot("C5.0", parameter_tuning_c50, projet_ET)

# Calculate and plot ROC curves for tree
auc_values_tree <- calculate_roc_and_plot("tree", parameter_tuning_tree, projet_ET)

# Add legend
legend("bottomright", legend = c("rpart", "C5.0", "tree"), col = rainbow(nrow(parameter_tuning_rpart)), lwd = 2)

# Print AUC values
cat("AUC values for rpart:", auc_values_rpart, "\n")
cat("AUC values for C5.0:", auc_values_c50, "\n")
cat("AUC values for tree:", auc_values_tree, "\n")
