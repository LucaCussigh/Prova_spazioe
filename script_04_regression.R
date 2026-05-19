# ============================================================================
# Script 04: Regressione Lineare
# ============================================================================
# Modelli di regressione semplice e multipla con diagnostica
# Data: 2025-12-06

df_clean <- readRDS("data/df_clean.rds")

# ============================================================================
# Regressione lineare semplice
# ============================================================================

cat("REGRESSIONE LINEARE SEMPLICE\n")
cat("============================\n")

numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]

if (length(numeric_vars) >= 2) {
  var_indipendente <- numeric_vars[1]
  var_dipendente <- numeric_vars[2]
  
  # Adattamento del modello
  model_simple <- lm(df_clean[[var_dipendente]] ~ df_clean[[var_indipendente]])
  
  cat(sprintf("Modello: %s ~ %s\n\n", var_dipendente, var_indipendente))
  print(summary(model_simple))
  
  # ========================================================================
  # Regressione lineare multipla
  # ========================================================================
  
  cat("\n\nREGRESSIONE LINEARE MULTIPLA\n")
  cat("=============================\n")
  
  if (length(numeric_vars) >= 3) {
    # Seleziona prime 3 variabili numeriche
    vars_indipendenti <- numeric_vars[1:3]
    formula_str <- paste(var_dipendente, "~", paste(vars_indipendenti, collapse = " + "))
    
    model_multi <- lm(as.formula(formula_str), data = df_clean)
    
    cat(sprintf("Modello: %s\n\n", formula_str))
    print(summary(model_multi))
    
    # ====================================================================
    # Diagnostica del modello
    # ====================================================================
    
    cat("\n\nDIAGNOSTICA DEL MODELLO\n")
    cat("======================\n")
    
    # R-squared
    cat(sprintf("R-squared: %.4f\n", summary(model_multi)$r.squared))
    cat(sprintf("Adjusted R-squared: %.4f\n", summary(model_multi)$adj.r.squared))
    
    # Residui
    residui <- residuals(model_multi)
    cat(sprintf("Residui - Media: %.4f, SD: %.4f\n", 
                mean(residui), sd(residui)))
    
    # Test F
    fstat <- summary(model_multi)$fstatistic
    cat(sprintf("F-statistic: %.4f (p-value: %.4e)\n", fstat[1], 
                1 - pf(fstat[1], fstat[2], fstat[3])))
    
    # ====================================================================
    # Assunzioni del modello
    # ====================================================================
    
    cat("\n\nVALUTAZIONE ASSUNZIONI\n")
    cat("====================\n")
    
    # Test di normalità dei residui
    if (length(residui) > 5000) {
      shapiro_result <- shapiro.test(sample(residui, 5000))
    } else {
      shapiro_result <- shapiro.test(residui)
    }
    cat(sprintf("Shapiro-Wilk test (normalità): p=%.4f\n", shapiro_result$p.value))
    
    # Test di omoschedasticità (Breusch-Pagan)
    library(lmtest)
    bp_test <- bptest(model_multi)
    cat(sprintf("Breusch-Pagan test (omoschedasticità): p=%.4f\n", bp_test$p.value))
    
    # Multicollinearità (VIF)
    if (requireNamespace("car", quietly = TRUE)) {
      library(car)
      vif_values <- vif(model_multi)
      cat("\nFattori d'Inflazione della Varianza (VIF):\n")
      print(vif_values)
    }
    
    # ====================================================================
    # Visualizzazioni diagnostiche
    # ====================================================================
    
    cat("\n\nVISUALIZZAZIONI DIAGNOSTICHE\n")
    cat("============================\n")
    
    par(mfrow = c(2, 2))
    plot(model_multi, which = 1:4)
    par(mfrow = c(1, 1))
    
    # ====================================================================
    # Predizioni
    # ====================================================================
    
    cat("\nPREDIZIONI\n")
    cat("==========\n")
    
    predictions <- predict(model_multi)
    residui_std <- rstandard(model_multi)
    
    df_diagnostics <- data.frame(
      Osservato = df_clean[[var_dipendente]][!is.na(predictions)],
      Predetto = predictions[!is.na(predictions)],
      Residuo = residui[!is.na(predictions)],
      Residuo_Std = residui_std[!is.na(predictions)]
    )
    
    cat("Prime 5 predizioni:\n")
    print(head(df_diagnostics, 5))
    
    # RMSE e MAE
    rmse <- sqrt(mean((df_diagnostics$Osservato - df_diagnostics$Predetto)^2))
    mae <- mean(abs(df_diagnostics$Osservato - df_diagnostics$Predetto))
    
    cat(sprintf("\nRMSE: %.4f\n", rmse))
    cat(sprintf("MAE: %.4f\n", mae))
  }
}

cat("\n✓ Analisi di regressione completata!\n")
