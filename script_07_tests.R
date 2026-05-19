# ============================================================================
# Script 07: Test Statistici e Inferenza
# ============================================================================
# Test d'ipotesi: t-test, ANOVA, test non-parametrici
# Data: 2025-12-06

df_clean <- readRDS("data/df_clean.rds")

# ============================================================================
# T-test
# ============================================================================

cat("TEST STATISTICI\n")
cat("===============\n")

numeric_vars <- names(df_clean)[sapply(df_clean, is.numeric)]
categorical_vars <- names(df_clean)[sapply(df_clean, function(x) 
  is.factor(x) || is.character(x))]

if (length(numeric_vars) > 0 && length(categorical_vars) > 0) {
  cat("\nT-TEST\n")
  cat("------\n")
  
  numeric_var <- numeric_vars[1]
  categorical_var <- categorical_vars[1]
  
  # Dividi dati per categorie
  unique_cats <- unique(df_clean[[categorical_var]])
  
  if (length(unique_cats) == 2) {
    group1 <- df_clean[[numeric_var]][df_clean[[categorical_var]] == unique_cats[1]]
    group2 <- df_clean[[numeric_var]][df_clean[[categorical_var]] == unique_cats[2]]
    
    # T-test indipendente
    ttest_result <- t.test(group1, group2)
    
    cat(sprintf("Variabile: %s per %s\n", numeric_var, categorical_var))
    cat(sprintf("Gruppo 1 (%s): n=%d, media=%.4f, sd=%.4f\n",
                unique_cats[1], length(group1), mean(group1, na.rm = TRUE), 
                sd(group1, na.rm = TRUE)))
    cat(sprintf("Gruppo 2 (%s): n=%d, media=%.4f, sd=%.4f\n",
                unique_cats[2], length(group2), mean(group2, na.rm = TRUE), 
                sd(group2, na.rm = TRUE)))
    cat(sprintf("\nt-statistic: %.4f\n", ttest_result$statistic))
    cat(sprintf("p-value: %.6f\n", ttest_result$p.value))
    
    if (ttest_result$p.value < 0.05) {
      cat("✓ Differenza significativa (α = 0.05)\n")
    } else {
      cat("✗ Nessuna differenza significativa (α = 0.05)\n")
    }
  }
}

# ============================================================================
# ANOVA (Analysis of Variance)
# ============================================================================

if (length(numeric_vars) > 0 && length(categorical_vars) > 0) {
  cat("\n\nANOVA AD UNA VIA\n")
  cat("================\n")
  
  numeric_var <- numeric_vars[1]
  categorical_var <- categorical_vars[1]
  
  # ANOVA
  formula_str <- paste(numeric_var, "~", categorical_var)
  anova_model <- lm(as.formula(formula_str), data = df_clean)
  anova_result <- anova(anova_model)
  
  print(anova_result)
  
  cat("\nInterpretazione:\n")
  p_value <- anova_result$"Pr(>F)"[1]
  if (!is.na(p_value) && p_value < 0.05) {
    cat("✓ Effetto significativo del fattore categorico (α = 0.05)\n")
  } else {
    cat("✗ Nessun effetto significativo del fattore categorico\n")
  }
}

# ============================================================================
# Test non-parametrici: Mann-Whitney U test
# ============================================================================

if (length(numeric_vars) > 0 && length(categorical_vars) > 0) {
  cat("\n\nMANN-WHITNEY U TEST (alternativa non-parametrica al t-test)\n")
  cat("============================================================\n")
  
  numeric_var <- numeric_vars[1]
  categorical_var <- categorical_vars[1]
  unique_cats <- unique(df_clean[[categorical_var]])
  
  if (length(unique_cats) == 2) {
    group1 <- df_clean[[numeric_var]][df_clean[[categorical_var]] == unique_cats[1]]
    group2 <- df_clean[[numeric_var]][df_clean[[categorical_var]] == unique_cats[2]]
    
    mw_result <- wilcox.test(group1, group2)
    
    cat(sprintf("Test per: %s tra %s\n", numeric_var, categorical_var))
    cat(sprintf("Statistica U: %.4f\n", mw_result$statistic))
    cat(sprintf("p-value: %.6f\n", mw_result$p.value))
  }
}

# ============================================================================
# Kruskal-Wallis test (alternativa non-parametrica ANOVA)
# ============================================================================

if (length(numeric_vars) > 0 && length(categorical_vars) > 0) {
  cat("\n\nKRUSKAL-WALLIS TEST (alternativa non-parametrica ANOVA)\n")
  cat("========================================================\n")
  
  numeric_var <- numeric_vars[1]
  categorical_var <- categorical_vars[1]
  
  kw_result <- kruskal.test(df_clean[[numeric_var]], df_clean[[categorical_var]])
  
  cat(sprintf("Test per: %s tra %s\n", numeric_var, categorical_var))
  cat(sprintf("Statistica H: %.4f\n", kw_result$statistic))
  cat(sprintf("p-value: %.6f\n", kw_result$p.value))
}

# ============================================================================
# Intervalli di confidenza
# ============================================================================

cat("\n\nINTERVALLI DI CONFIDENZA (95%)\n")
cat("==============================\n")

if (length(numeric_vars) > 0) {
  for (i in 1:min(3, length(numeric_vars))) {
    var <- numeric_vars[i]
    media <- mean(df_clean[[var]], na.rm = TRUE)
    se <- sd(df_clean[[var]], na.rm = TRUE) / sqrt(sum(!is.na(df_clean[[var]])))
    
    ci_lower <- media - 1.96 * se
    ci_upper <- media + 1.96 * se
    
    cat(sprintf("%s: %.4f [%.4f - %.4f]\n", 
                var, media, ci_lower, ci_upper))
  }
}

cat("\n✓ Test statistici completati!\n")
