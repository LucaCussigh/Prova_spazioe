# ============================================================================
# Script 03: Correlazioni e Analisi Bivariate
# ============================================================================
# Analisi delle relazioni tra variabili: correlazioni, test d'associazione
# Data: 2025-12-06

df_clean <- readRDS("data/df_clean.rds")
library(corrplot)
library(ggplot2)

# ============================================================================
# Correlazioni tra variabili numeriche
# ============================================================================

cat("MATRICE DI CORRELAZIONE (Pearson)\n")
cat("==================================\n")

numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]
cor_matrix <- cor(df_clean[, numeric_vars], use = "complete.obs", method = "pearson")

print(cor_matrix)

cat("\n\nCORRELAZIONI SIGNIFICATIVE (Pearson)\n")
cat("=====================================\n")

# Funzione per test di significatività
cor_test <- function(x, y) {
  result <- cor.test(x, y, method = "pearson")
  return(c(correlation = result$estimate, p_value = result$p.value))
}

significant_cors <- list()
for (i in 1:(ncol(cor_matrix) - 1)) {
  for (j in (i + 1):ncol(cor_matrix)) {
    test_result <- cor_test(df_clean[[numeric_vars[i]]], df_clean[[numeric_vars[j]]])
    if (test_result["p_value"] < 0.05) {
      cat(sprintf("%s vs %s: r=%.4f, p=%.4f\n", 
                  numeric_vars[i], numeric_vars[j], 
                  test_result["correlation"], test_result["p_value"]))
    }
  }
}

# ============================================================================
# Correlazione di Spearman (robusta agli outliers)
# ============================================================================

cat("\n\nCORRELAZIONE DI SPEARMAN (Robusta)\n")
cat("====================================\n")

cor_spearman <- cor(df_clean[, numeric_vars], 
                    use = "complete.obs", 
                    method = "spearman")

print(head(cor_spearman, 3))

# ============================================================================
# Associazioni categoriche (Chi-quadro)
# ============================================================================

cat("\n\nTEST CHI-QUADRO PER VARIABILI CATEGORICHE\n")
cat("==========================================\n")

categorical_vars <- names(df_clean)[sapply(df_clean, function(x) is.factor(x) || is.character(x))]

if (length(categorical_vars) >= 2) {
  for (i in 1:(length(categorical_vars) - 1)) {
    for (j in (i + 1):length(categorical_vars)) {
      contingency_table <- table(df_clean[[categorical_vars[i]]], 
                                 df_clean[[categorical_vars[j]]])
      chi_test <- chisq.test(contingency_table)
      
      cat(sprintf("%s vs %s: χ²=%.4f, p=%.4f\n", 
                  categorical_vars[i], categorical_vars[j], 
                  chi_test$statistic, chi_test$p.value))
    }
  }
}

# ============================================================================
# Visualizzazione correlazioni
# ============================================================================

cat("\n\nVISUALIZZAZIONE HEATMAP CORRELAZIONI\n")
cat("====================================\n")

if (length(numeric_vars) > 1) {
  # Heatmap con corrplot
  corrplot(cor_matrix, 
           method = "color",
           type = "upper",
           order = "hclust",
           tl.col = "black",
           tl.srt = 45,
           main = "Matrice di Correlazione")
}

# ============================================================================
# Scatter plot con regressione
# ============================================================================

if (length(numeric_vars) >= 2) {
  cat("\nSCATTER PLOT: Visualizzazione relazioni bivariate\n")
  
  var1 <- numeric_vars[1]
  var2 <- numeric_vars[2]
  
  plot(df_clean[[var1]], df_clean[[var2]],
       main = paste("Relazione tra", var1, "e", var2),
       xlab = var1,
       ylab = var2,
       pch = 19,
       col = rgb(0, 0, 1, 0.3))
  
  # Aggiunta linea di regressione
  model <- lm(df_clean[[var2]] ~ df_clean[[var1]])
  abline(model, col = "red", lwd = 2)
}

cat("\n✓ Analisi bivariate completata!\n")
