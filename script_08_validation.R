# ============================================================================
# Script 08: Validazione e Cross-Validazione
# ============================================================================
# Tecniche di validazione modelli: hold-out, k-fold CV, metriche
# Data: 2025-12-06

df_clean <- readRDS("data/df_clean.rds")

# ============================================================================
# Divisione train-test
# ============================================================================

cat("VALIDAZIONE DEI MODELLI\n")
cat("=======================\n")

set.seed(42)

# Proporzione: 80% train, 20% test
train_prop <- 0.8
n_train <- round(nrow(df_clean) * train_prop)

train_idx <- sample(1:nrow(df_clean), n_train)
df_train <- df_clean[train_idx, ]
df_test <- df_clean[-train_idx, ]

cat(sprintf("Divisione dati:\n"))
cat(sprintf("  Train: %d osservazioni (%.1f%%)\n", nrow(df_train), train_prop * 100))
cat(sprintf("  Test: %d osservazioni (%.1f%%)\n", nrow(df_test), (1 - train_prop) * 100))

# ========================================================================
# Addestramento modello su training set
# ========================================================================

numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]

if (length(numeric_vars) >= 2) {
  cat("\n\nADDESTRAMENTO MODELLO\n")
  cat("====================\n")
  
  var_indipendente <- numeric_vars[1]
  var_dipendente <- numeric_vars[2]
  
  # Modello su training set
  model_train <- lm(df_train[[var_dipendente]] ~ df_train[[var_indipendente]])
  
  cat(sprintf("Modello: %s ~ %s\n", var_dipendente, var_indipendente))
  cat(sprintf("R² (training): %.4f\n", summary(model_train)$r.squared))
  
  # ====================================================================
  # Valutazione su test set
  # ====================================================================
  
  cat("\n\nVALUTAZIONE SU TEST SET\n")
  cat("======================\n")
  
  # Predizioni su test set
  pred_test <- predict(model_train, newdata = df_test)
  
  # Calcolo metriche
  rmse_test <- sqrt(mean((df_test[[var_dipendente]] - pred_test)^2, na.rm = TRUE))
  mae_test <- mean(abs(df_test[[var_dipendente]] - pred_test), na.rm = TRUE)
  
  # R² su test set
  ss_res <- sum((df_test[[var_dipendente]] - pred_test)^2, na.rm = TRUE)
  ss_tot <- sum((df_test[[var_dipendente]] - mean(df_test[[var_dipendente]], na.rm = TRUE))^2, na.rm = TRUE)
  r2_test <- 1 - (ss_res / ss_tot)
  
  cat(sprintf("RMSE (test): %.4f\n", rmse_test))
  cat(sprintf("MAE (test): %.4f\n", mae_test))
  cat(sprintf("R² (test): %.4f\n", r2_test))
  
  # ====================================================================
  # Confronto train vs test
  # ====================================================================
  
  cat("\n\nCONFRONTO TRAIN vs TEST\n")
  cat("======================\n")
  
  pred_train <- predict(model_train)
  rmse_train <- sqrt(mean((df_train[[var_dipendente]] - pred_train)^2, na.rm = TRUE))
  
  cat(sprintf("RMSE Train: %.4f\n", rmse_train))
  cat(sprintf("RMSE Test: %.4f\n", rmse_test))
  
  # Overfitting check
  overfitting_ratio <- rmse_test / rmse_train
  cat(sprintf("Rapporto RMSE (Test/Train): %.4f\n", overfitting_ratio))
  
  if (overfitting_ratio > 1.2) {
    cat("⚠ Possibile overfitting: RMSE test > 20% RMSE train\n")
  } else {
    cat("✓ Nessun segno evidente di overfitting\n")
  }
}

# ========================================================================
# Cross-validazione k-fold (se possibile)
# ========================================================================

if (requireNamespace("caret", quietly = TRUE)) {
  cat("\n\nCROSS-VALIDAZIONE K-FOLD (5-fold)\n")
  cat("==================================\n")
  
  library(caret)
  
  if (length(numeric_vars) >= 2) {
    # Controllo training
    train_control <- trainControl(method = "cv", number = 5)
    
    # Addestramento con CV
    model_cv <- train(
      as.formula(paste(var_dipendente, "~", var_indipendente)),
      data = df_clean,
      method = "lm",
      trControl = train_control
    )
    
    cat(sprintf("RMSE medio (5-fold CV): %.4f\n", model_cv$results$RMSE))
    cat(sprintf("R² medio (5-fold CV): %.4f\n", model_cv$results$Rsquared))
    cat(sprintf("Deviazione std RMSE: %.4f\n", model_cv$results$RMSESD))
  }
}

# ========================================================================
# Bootstrap confidence intervals
# ========================================================================

cat("\n\nBOOTSTRAP CONFIDENCE INTERVALS\n")
cat("==============================\n")

if (length(numeric_vars) > 0) {
  var <- numeric_vars[1]
  
  # Bootstrap manuale (100 replicazioni)
  n_bootstrap <- 100
  bootstrap_means <- numeric(n_bootstrap)
  
  set.seed(42)
  for (i in 1:n_bootstrap) {
    sample_idx <- sample(1:nrow(df_clean), nrow(df_clean), replace = TRUE)
    bootstrap_means[i] <- mean(df_clean[[var]][sample_idx], na.rm = TRUE)
  }
  
  # Intervallo di confidenza al 95%
  ci_lower <- quantile(bootstrap_means, 0.025)
  ci_upper <- quantile(bootstrap_means, 0.975)
  
  cat(sprintf("Bootstrap IC (95%%) per media di %s:\n", var))
  cat(sprintf("  Media: %.4f\n", mean(df_clean[[var]], na.rm = TRUE)))
  cat(sprintf("  IC: [%.4f - %.4f]\n", ci_lower, ci_upper))
}

cat("\n✓ Validazione completata!\n")
