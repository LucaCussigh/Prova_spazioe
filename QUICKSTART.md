# QUICK START GUIDE - Presentazione Data Science

Questa guida rapida ti aiuterà a iniziare con la presentazione Quarto e gli script R.

## 🚀 Avvio Rapido (5 minuti)

### 1. Installazione Dipendenze

```bash
# Installa R e RStudio
# Scarica da https://www.r-project.org/ e https://posit.co/download/rstudio-desktop/

# Installa Quarto
# Scarica da https://quarto.org/docs/get-started/

# Installa pacchetti R necessari
Rscript -e "
install.packages(c(
  'tidyverse', 'ggplot2', 'summarytools', 'corrplot', 'moments',
  'caret', 'lmtest', 'car', 'rpart', 'pROC', 'lme4'
))
"
```

### 2. Genera Dataset di Esempio

```r
# Esegui lo script di setup
source("script_00_setup.R")
# Questo crea un dataset di esempio in memoria
```

### 3. Visualizza la Presentazione

```bash
# Apri in browser con live preview
quarto preview presentazione.qmd

# Oppure genera HTML statico
quarto render presentazione.qmd --to html

# Oppure esporta in PDF
quarto render presentazione.qmd --to pdf
```

## 📊 Struttura dei File

```
├── presentazione.qmd          ← Presentazione principale
├── custom.scss                ← Tema personalizzato
├── script_00_setup.R          ← Setup e dati
├── script_01_cleaning.R       ← Pulizia dati
├── script_02_univariate.R     ← Analisi univariate
├── script_03_bivariate.R      ← Correlazioni
├── script_04_regression.R     ← Modelli regressione
├── script_05_classification.R ← Classificazione
├── script_06_visualization.R  ← Grafici ggplot2
├── script_07_tests.R          ← Test statistici
├── script_08_validation.R     ← Validazione modelli
├── script_09_report.R         ← Rapporto finale
├── README.md                  ← Documentazione
└── QUICKSTART.md             ← Questa guida
```

## 🎯 Scenari d'Uso

### Scenario 1: Visualizzare la Presentazione (Solo Lettura)

```bash
# Genera HTML per distribuire agli studenti
quarto render presentazione.qmd --to html
# Condividi il file HTML generato
```

### Scenario 2: Adattare a Dati Propri

1. Modifica `script_00_setup.R` per caricare i tuoi dati:
   ```r
   df <- read.csv("miei_dati.csv")
   # Invece di usare i dati di esempio
   ```

2. Esegui gli script nell'ordine:
   ```r
   source("script_01_cleaning.R")
   source("script_02_univariate.R")
   # ... ecc
   ```

3. Consulta la presentazione per le spiegazioni teoriche

### Scenario 3: Creare Presentazione Personalizzata

1. Copia `presentazione.qmd` a `mia_presentazione.qmd`
2. Modifica i titoli e il contenuto secondo necessità
3. Incorpora risultati dai tuoi script R usando codice dinamico:
   ```r
   source("script_01_cleaning.R")
   ```

## 📈 Esempi di Utilizzo Tipici

### Eseguire un Singolo Script

```r
# In RStudio, apri script_02_univariate.R e premi Ctrl+Shift+S (o Cmd+Shift+S)
# Oppure da terminale:
Rscript script_02_univariate.R
```

### Eseguire Tutti gli Script Sequenzialmente

```r
# Crea file run_all.R con:
for (i in 0:9) {
  script_name <- sprintf("script_%02d.R", i)
  if (file.exists(script_name)) {
    source(script_name)
  }
}
```

### Generare Rapporto HTML Dinamico

```r
# In file Rmarkdown o Quarto documento
quarto::quarto_render("presentazione.qmd")
```

## 🔧 Personalizzazione

### Modificare Colori del Tema

Modifica `custom.scss`:
```scss
$primary: #2c3e50;    // Blu scuro principale
$secondary: #3498db;  // Azzurro secondario
$accent: #e74c3c;     // Rosso accento
```

### Aggiungere Proprie Slide

In `presentazione.qmd`, aggiungi:
```markdown
## Titolo Nuova Slide

- Punto 1
- Punto 2

\`\`\`{r}
# Codice R
\`\`\`
```

### Modificare Configurazione Quarto

Personalizza il YAML in `presentazione.qmd`:
```yaml
format:
  revealjs:
    transition: zoom  # Cambia transizione
    width: 1400       # Aumenta larghezza
```

## 📚 Risorse Utili

- **Quarto Documentation**: https://quarto.org/
- **Reveal.js Presentations**: https://quarto.org/docs/presentations/revealjs/
- **R for Data Science**: https://r4ds.hadley.nz/
- **ggplot2**: https://ggplot2.tidyverse.org/

## ⚠️ Troubleshooting

### "Quarto command not found"
```bash
# Installa Quarto o aggiungi al PATH
# Windows: C:\Program Files\Quarto\bin
# macOS: /Applications/quarto/bin
# Linux: /opt/quarto/bin
```

### "Error: package 'xyz' not found"
```r
# Installa il pacchetto mancante
install.packages("xyz")
```

### "Cannot find script_00_setup.R"
```bash
# Verifica di essere nella directory corretta
getwd()  # In R
pwd      # In terminale
cd /home/runner/work/Prova_spazioe/Prova_spazioe
```

## 💡 Suggerimenti Pratici

1. **Slide per lezione**: Crea più file `.qmd` per modularità
2. **Dataset voluminosi**: Salva con `saveRDS()` e carica velocemente
3. **Grafici reattivi**: Integra `plotly` o `shiny` per interattività
4. **Versioning**: Usa `git` per tracciare modifiche
5. **Collaborazione**: Condividi il repository GitHub

## 🎓 Per Docenti

- Preparare materiale una volta, riutilizzare ogni anno
- Aggiungere dataset locali facilmente
- Mostrare live coding durante la presentazione
- Distribuire slide e script agli studenti

## 🔗 Prossimi Passi

1. ✅ Installa dipendenze
2. ✅ Esegui `script_00_setup.R`
3. ✅ Visualizza presentazione: `quarto preview presentazione.qmd`
4. ✅ Esplora gli altri script
5. ✅ Personalizza con i tuoi dati

---

**Buona presentazione!** 🎉

Per domande o suggerimenti: laboratorio@unipd.it
