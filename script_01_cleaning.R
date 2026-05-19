# ============================================================================
# Script 01: Data Cleaning e Qualità Dati
# ============================================================================
# Rimozione valori mancanti, duplicati e gestione outliers
# Data: 2025-12-06

source("script_00_setup.R")  # Carica dati dal setup

# ============================================================================
# Analisi valori mancanti
# ============================================================================

cat("ANALISI VALORI MANCANTI\n")
cat("======================\n")

missing_data <- data.frame(
  Colonna = colnames(df),
  Mancanti = colSums(is.na(df)),
  Percentuale = round(colSums(is.na(df)) / nrow(df) * 100, 2)
)

print(missing_data)

# Rimozione righe con valori mancanti (se pochi)
df_clean <- na.omit(df)

cat("\nRighe rimosse:", nrow(df) - nrow(df_clean), "\n")

# ============================================================================
# Controllo duplicati
# ============================================================================

cat("\n\nCONTROLLO DUPLICATI\n")
cat("==================\n")

n_duplicati <- sum(duplicated(df_clean))
cat("Righe duplicate trovate:", n_duplicati, "\n")

df_clean <- df_clean[!duplicated(df_clean), ]

# ============================================================================
# Analisi e gestione outliers (metodo IQR)
# ============================================================================

cat("\nIDENTIFICAZIONE OUTLIERS (Metodo IQR)\n")
cat("====================================\n")

for (col in names(df_clean)[sapply(df_clean, is.numeric)]) {
  Q1 <- quantile(df_clean[[col]], 0.25, na.rm = TRUE)
  Q3 <- quantile(df_clean[[col]], 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  
  n_outliers <- sum(df_clean[[col]] < lower_bound | df_clean[[col]] > upper_bound, na.rm = TRUE)
  
  if (n_outliers > 0) {
    cat(sprintf("%s: %d outliers (Range: %.2f - %.2f)\n", 
                col, n_outliers, lower_bound, upper_bound))
  }
}

# ============================================================================
# Validazione logica tra variabili
# ============================================================================

cat("\n\nVALIDAZIONE LOGICA\n")
cat("==================\n")

# Verifica: age dovrebbe essere positiva e ragionevole
invalid_age <- df_clean$age < 0 | df_clean$age > 120
cat("Age invalidi:", sum(invalid_age), "\n")

# Verifica: income dovrebbe essere positivo
invalid_income <- df_clean$income < 0
cat("Income negativi:", sum(invalid_income), "\n")

# ============================================================================
# Standardizzazione variabili numeriche
# ============================================================================

cat("\n\nSTANDARDIZZAZIONE\n")
cat("================\n")

# Z-score standardization
df_scaled <- df_clean
numeric_cols <- names(df_clean)[sapply(df_clean, is.numeric)]

for (col in numeric_cols) {
  df_scaled[[paste0(col, "_scaled")]] <- scale(df_clean[[col]])
}

cat("Variabili scalate (z-score):\n")
print(head(df_scaled[, c(numeric_cols[1], paste0(numeric_cols[1], "_scaled"))], 3))

# ============================================================================
# Salvataggio dati puliti
# ============================================================================

cat("\n\nRIASSUNTO CLEANING\n")
cat("==================\n")
cat("Dataset originale:", nrow(df), "righe\n")
cat("Dataset pulito:", nrow(df_clean), "righe\n")
cat("Righe rimosse:", nrow(df) - nrow(df_clean), "\n")

saveRDS(df_clean, "data/df_clean.rds")
cat("\n✓ Dati puliti salvati in 'data/df_clean.rds'\n")
