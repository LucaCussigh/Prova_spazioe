# ============================================================================
# Script 00: Setup Iniziale e Caricamento Dati
# ============================================================================
# Questo script configura l'ambiente R e carica i dati necessari per l'analisi
# Data: 2025-12-06
# Autore: Laboratorio di Data Science

# Librerie necessarie
library(tidyverse)      # Data manipulation e visualizzazione
library(summarytools)   # Statistiche descrittive
library(ggplot2)        # Visualizzazione avanzata
library(dplyr)          # Transformazione dati
library(magrittr)       # Pipe operator
library(corrplot)       # Visualizzazione correlazioni
library(moments)        # Asimmetria e curtosi

# Configurazione globale
options(digits = 4)     # Decimali per output
set.seed(42)            # Riproducibilità

# ============================================================================
# Caricamento dati
# ============================================================================

# Esempio: caricamento da CSV
# df <- read.csv("data/dataset.csv", stringsAsFactors = FALSE)

# Opzione alternativa: creazione dataset di esempio
df <- data.frame(
  id = 1:100,
  age = rnorm(100, mean = 35, sd = 10),
  income = rnorm(100, mean = 50000, sd = 15000),
  education = sample(c("High School", "Bachelor", "Master", "PhD"), 100, replace = TRUE),
  region = sample(c("North", "Center", "South"), 100, replace = TRUE),
  satisfaction = sample(1:5, 100, replace = TRUE)
)

# ============================================================================
# Informazioni generali sul dataset
# ============================================================================

cat("INFORMAZIONI DATASET\n")
cat("==================\n")
cat("Dimensioni:", nrow(df), "righe,", ncol(df), "colonne\n")
cat("\nNomi colonne:\n")
print(colnames(df))

cat("\nTipi di dati:\n")
print(sapply(df, class))

cat("\nPrime righe:\n")
print(head(df, 10))

cat("\nValori mancanti per colonna:\n")
print(colSums(is.na(df)))

# ============================================================================
# Statistiche descrittive di base
# ============================================================================

cat("\n\nSTATISTICHE DESCRITTIVE NUMERICHE\n")
cat("=================================\n")
print(summary(df[, sapply(df, is.numeric)]))

cat("\nDistribuzioni categoriche:\n")
print(table(df$education))

# ============================================================================
# Salvataggio dell'ambiente
# ============================================================================

# Salva il dataset pulito per gli script successivi
# saveRDS(df, "data/df_clean.rds")

cat("\n✓ Setup completato con successo!\n")
