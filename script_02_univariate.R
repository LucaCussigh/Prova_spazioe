# ============================================================================
# Script 02: Analisi Univariata
# ============================================================================
# Analisi dettagliata di variabili singole: distribuzione, forma, normalità
# Data: 2025-12-06

# Carica dati puliti
df_clean <- readRDS("data/df_clean.rds")

# ============================================================================
# Funzioni helper per analisi univariata
# ============================================================================

univariate_analysis <- function(x, var_name) {
  cat(sprintf("\n%s\n%s\n", var_name, strrep("=", nchar(var_name))))
  
  if (is.numeric(x)) {
    cat("Tipo: Numerica\n")
    cat(sprintf("N osservazioni: %d\n", length(x)))
    cat(sprintf("Media: %.4f\n", mean(x, na.rm = TRUE)))
    cat(sprintf("Mediana: %.4f\n", median(x, na.rm = TRUE)))
    cat(sprintf("Deviazione Standard: %.4f\n", sd(x, na.rm = TRUE)))
    cat(sprintf("Minimo: %.4f\n", min(x, na.rm = TRUE)))
    cat(sprintf("Massimo: %.4f\n", max(x, na.rm = TRUE)))
    cat(sprintf("Range: %.4f\n", max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
    cat(sprintf("IQR: %.4f\n", IQR(x, na.rm = TRUE)))
    cat(sprintf("Asimmetria (Skewness): %.4f\n", moments::skewness(x, na.rm = TRUE)))
    cat(sprintf("Curtosi: %.4f\n", moments::kurtosis(x, na.rm = TRUE)))
    
    # Test di normalità
    if (length(x) > 5000) {
      # Troppi dati per Shapiro-Wilk, usa sample
      test_result <- shapiro.test(sample(x, 5000, na.rm = TRUE))
    } else {
      test_result <- shapiro.test(x)
    }
    cat(sprintf("Test Shapiro-Wilk p-value: %.4f\n", test_result$p.value))
    
  } else {
    cat("Tipo: Categorica\n")
    freq_table <- table(x, useNA = "ifany")
    print(freq_table)
    cat(sprintf("N categorie: %d\n", length(unique(x)))
    )
  }
}

# ============================================================================
# Analisi univariata per ciascuna variabile
# ============================================================================

cat("ANALISI UNIVARIATA DETTAGLIATA\n")
cat("=============================\n")

for (col in colnames(df_clean)) {
  univariate_analysis(df_clean[[col]], col)
}

# ============================================================================
# Visualizzazioni
# ============================================================================

cat("\n\nVISUALIZZAZIONI\n")
cat("===============\n")

# Istogrammi per variabili numeriche
numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]

par(mfrow = c(2, 2))
for (var in numeric_vars[1:min(4, length(numeric_vars))]) {
  hist(df_clean[[var]], 
       main = paste("Distribuzione", var),
       xlab = var, 
       ylab = "Frequenza",
       col = "steelblue",
       breaks = 30)
}
par(mfrow = c(1, 1))

cat("\n✓ Analisi univariata completata!\n")
