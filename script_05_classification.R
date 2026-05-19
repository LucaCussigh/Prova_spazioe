# ============================================================================
# Script 05: Classificazione
# ============================================================================
# Modelli di classificazione: logistica, alberi, valutazione performance
# Data: 2025-12-06

df_clean <- readRDS("data/df_clean.rds")

# ============================================================================
# Preparazione dati per classificazione
# ============================================================================

cat("PREPARAZIONE PER CLASSIFICAZIONE\n")
cat("=================================\n")

# Identifica variabile categorica target (binarizzazione)
categorical_vars <- names(df_clean)[sapply(df_clean, function(x) 
  is.factor(x) || is.character(x))]

if (length(categorical_vars) > 0) {
  target_var <- categorical_vars[1]
  cat(sprintf("Variabile target: %s\n", target_var))
  cat(sprintf("Classi: %s\n", paste(unique(df_clean[[target_var]]), collapse = ", ")))
  
  # Binarizzazione (primo livello vs altri)
  unique_values <- unique(df_clean[[target_var]])
  df_clean$target_binary <- as.numeric(df_clean[[target_var]] == unique_values[1])
  
  cat(sprintf("Distribuzione target (binarizzato):\n"))
  print(table(df_clean$target_binary))
  
  # ========================================================================
  # Regressione logistica
  # ========================================================================
  
  cat("\n\nREGRESSIONE LOGISTICA\n")
  cat("====================\n")
  
  numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]
  if (length(numeric_vars) >= 1) {
    # Usa prime 2 variabili numeriche
    predictors <- numeric_vars[1:min(2, length(numeric_vars))]
    formula_str <- paste("target_binary ~", paste(predictors, collapse = " + "))
    
    model_logit <- glm(as.formula(formula_str), 
                       family = binomial(link = "logit"), 
                       data = df_clean)
    
    cat(sprintf("Modello: %s\n\n", formula_str))
    print(summary(model_logit))
    
    # ====================================================================
    # Predizioni e matrice di confusione
    # ====================================================================
    
    cat("\n\nVALUTAZIONE CLASSIFICAZIONE\n")
    cat("===========================\n")
    
    # Probabilità predette
    probs <- predict(model_logit, type = "response")
    
    # Classificazione con soglia 0.5
    predictions <- as.numeric(probs > 0.5)
    
    # Matrice di confusione
    confusion_matrix <- table(
      Osservato = df_clean$target_binary,
      Predetto = predictions
    )
    
    cat("\nMatrice di Confusione:\n")
    print(confusion_matrix)
    
    # Metriche di performance
    TP <- confusion_matrix[2, 2]
    TN <- confusion_matrix[1, 1]
    FP <- confusion_matrix[1, 2]
    FN <- confusion_matrix[2, 1]
    
    accuracy <- (TP + TN) / sum(confusion_matrix)
    precision <- TP / (TP + FP)
    recall <- TP / (TP + FN)
    f1 <- 2 * (precision * recall) / (precision + recall)
    
    cat(sprintf("\nAccuracy: %.4f\n", accuracy))
    cat(sprintf("Precision: %.4f\n", precision))
    cat(sprintf("Recall: %.4f\n", recall))
    cat(sprintf("F1-Score: %.4f\n", f1))
    
    # ====================================================================
    # Curva ROC (se possibile)
    # ====================================================================
    
    if (requireNamespace("pROC", quietly = TRUE)) {
      library(pROC)
      
      roc_obj <- roc(df_clean$target_binary, probs)
      auc_value <- auc(roc_obj)
      
      cat(sprintf("\nAUC (Area Under Curve): %.4f\n", auc_value))
      
      # Plot ROC curve
      plot(roc_obj, 
           main = "Curva ROC",
           col = "blue", 
           lwd = 2)
    }
  }
}

# ========================================================================
# Albero decisionale (se possibile)
# ========================================================================

if (requireNamespace("rpart", quietly = TRUE)) {
  cat("\n\nALBERO DECISIONALE\n")
  cat("==================\n")
  
  library(rpart)
  
  numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]
  if (length(numeric_vars) >= 1 && exists("target_binary", df_clean)) {
    
    predictors <- numeric_vars[1:min(3, length(numeric_vars))]
    formula_str <- paste("factor(target_binary) ~", paste(predictors, collapse = " + "))
    
    tree_model <- rpart(as.formula(formula_str), 
                       data = df_clean,
                       method = "class")
    
    cat("Albero:\n")
    print(tree_model)
    
    # Predizioni albero
    tree_predictions <- predict(tree_model, type = "class")
    
    # Accuracy albero
    tree_accuracy <- sum(tree_predictions == df_clean$target_binary) / length(df_clean$target_binary)
    cat(sprintf("\nAccuracy (Albero): %.4f\n", tree_accuracy))
  }
}

cat("\n✓ Analisi di classificazione completata!\n")
