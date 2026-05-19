# ============================================================================
# Script 06: Visualizzazione con ggplot2
# ============================================================================
# Grafici avanzati e principi di data visualization
# Data: 2025-12-06

df_clean <- readRDS("data/df_clean.rds")
library(ggplot2)
library(tidyverse)

# ============================================================================
# Tema personalizzato
# ============================================================================

theme_custom <- function() {
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray50"),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "gray90", size = 0.3),
    panel.grid.minor = element_blank()
  )
}

cat("VISUALIZZAZIONI CON GGPLOT2\n")
cat("==========================\n")

# ============================================================================
# Visualizzazioni univariate
# ============================================================================

numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]
categorical_vars <- names(df_clean)[sapply(df_clean, function(x) 
  is.factor(x) || is.character(x))]

if (length(numeric_vars) > 0) {
  var <- numeric_vars[1]
  
  # Istogramma
  cat("Creazione istogramma...\n")
  p_hist <- ggplot(df_clean, aes_string(x = var)) +
    geom_histogram(bins = 30, fill = "steelblue", alpha = 0.7, color = "black") +
    labs(title = paste("Distribuzione di", var),
         subtitle = "Istogramma con 30 classi",
         x = var,
         y = "Frequenza") +
    theme_custom()
  print(p_hist)
  
  # Density plot
  cat("Creazione density plot...\n")
  p_density <- ggplot(df_clean, aes_string(x = var)) +
    geom_density(fill = "skyblue", alpha = 0.6) +
    geom_histogram(aes(y = after_stat(density)), bins = 30, 
                  alpha = 0.4, color = "black") +
    labs(title = paste("Densità di", var),
         x = var,
         y = "Densità") +
    theme_custom()
  print(p_density)
  
  # Box plot
  if (length(categorical_vars) > 0) {
    cat("Creazione box plot per gruppo...\n")
    cat_var <- categorical_vars[1]
    
    p_box <- ggplot(df_clean, aes_string(x = cat_var, y = var, fill = cat_var)) +
      geom_boxplot(alpha = 0.7) +
      geom_jitter(width = 0.2, alpha = 0.3, size = 2) +
      labs(title = paste("Distribuzione di", var, "per", cat_var),
           x = cat_var,
           y = var,
           fill = cat_var) +
      theme_custom() +
      theme(legend.position = "none")
    print(p_box)
  }
}

# ============================================================================
# Visualizzazioni bivariate
# ============================================================================

if (length(numeric_vars) >= 2) {
  var1 <- numeric_vars[1]
  var2 <- numeric_vars[2]
  
  # Scatter plot con regressione
  cat("Creazione scatter plot...\n")
  p_scatter <- ggplot(df_clean, aes_string(x = var1, y = var2)) +
    geom_point(alpha = 0.5, size = 3, color = "steelblue") +
    geom_smooth(method = "lm", se = TRUE, color = "red", fill = "red", alpha = 0.1) +
    labs(title = paste("Relazione tra", var1, "e", var2),
         x = var1,
         y = var2,
         subtitle = "Con linea di regressione e intervallo di confidenza") +
    theme_custom()
  print(p_scatter)
  
  # Scatter plot colorato per categoria
  if (length(categorical_vars) > 0) {
    cat_var <- categorical_vars[1]
    
    p_scatter_colored <- ggplot(df_clean, aes_string(x = var1, y = var2, color = cat_var)) +
      geom_point(alpha = 0.6, size = 3) +
      scale_color_brewer(palette = "Set1") +
      facet_wrap(as.formula(paste("~", cat_var))) +
      labs(title = paste("Relazione tra", var1, "e", var2),
           x = var1,
           y = var2,
           color = cat_var) +
      theme_custom()
    print(p_scatter_colored)
  }
}

# ============================================================================
# Visualizzazioni categoriche
# ============================================================================

if (length(categorical_vars) > 0) {
  cat_var <- categorical_vars[1]
  
  # Grafico a barre
  cat("Creazione bar plot...\n")
  p_bar <- ggplot(df_clean, aes_string(x = cat_var, fill = cat_var)) +
    geom_bar(alpha = 0.7) +
    geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
    labs(title = paste("Frequenza di", cat_var),
         x = cat_var,
         y = "Conteggio") +
    theme_custom() +
    theme(legend.position = "none")
  print(p_bar)
  
  # Grafico a torta (alternativa: geom_col con coord_polar)
  if (requireNamespace("ggpie", quietly = TRUE)) {
    cat("Creazione pie chart...\n")
    p_pie <- ggplot(df_clean, aes_string(x = "", fill = cat_var)) +
      geom_bar(width = 1) +
      coord_polar("y", start = 0) +
      theme_void() +
      labs(fill = cat_var,
           title = paste("Distribuzione di", cat_var))
    print(p_pie)
  }
}

# ============================================================================
# Heatmap di correlazione
# ============================================================================

if (length(numeric_vars) > 1) {
  cat("Creazione heatmap di correlazione...\n")
  
  cor_matrix <- cor(df_clean[, numeric_vars], use = "complete.obs")
  cor_melted <- reshape2::melt(cor_matrix)
  
  p_heatmap <- ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(color = "white") +
    scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                        limits = c(-1, 1)) +
    geom_text(aes(label = round(value, 2)), size = 3) +
    labs(title = "Matrice di Correlazione",
         x = "Variabile 1",
         y = "Variabile 2",
         fill = "Correlazione") +
    theme_custom() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  print(p_heatmap)
}

cat("\n✓ Visualizzazioni completate!\n")
