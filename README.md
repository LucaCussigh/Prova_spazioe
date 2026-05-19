# Presentazione: Analisi dei Dati - Una Prospettiva Scientifica

## Descrizione del Progetto

Questa presentazione Quarto in formato Reveal.js fornisce un corso completo di analisi dei dati, dalla preparazione dei dati alla comunicazione dei risultati. Il materiale è strutturato per un utilizzo accademico e didattico, con enfasi sulla riproducibilità e sulla comunicazione scientifica.

## Contenuti

### Presentazione Principale
- **File**: `presentazione.qmd`
- **Formato**: Quarto Reveal.js
- **Lingua**: Italiano
- **Slide**: Dalla Fase 1 alla Fase 4

### Fasi della Presentazione

#### Fase 1: Data Cleaning e Statistiche Descrittive
- Caricamento e esplorazione iniziale dei dati
- Gestione valori mancanti
- Rimozione duplicati e outliers
- Standardizzazione e trasformazione
- Statistiche descrittive (misure centrali, dispersione, forma)
- Visualizzazione distribuzioni univariate
- Tabelle riepilogative

#### Fase 2: Analisi Univariata e Bivariate
- Analisi variabili numeriche
- Analisi variabili categoriche
- Correlazioni bivariate
- Visualizzazione relazioni

#### Fase 3: Analisi Multivariata
- Regressione lineare semplice e multipla
- Assunzioni del modello
- Diagnostica e validazione
- Classificazione
- Metriche di performance

#### Fase 4: Comunicazione e Visualizzazione
- Principi di visualizzazione efficace
- Visualizzazioni comuni
- Ggplot2 e grammatica della grafica
- Visualizzazioni avanzate
- Interpretazione e comunicazione risultati
- Best practices

## Script R

Gli script R forniscono implementazioni pratiche dei concetti presentati:

- **script_00_setup.R**: Setup iniziale, caricamento librerie e dati
- **script_01_cleaning.R**: Data cleaning e gestione qualità dati
- *Ulteriori script*: (02-09) possono essere aggiunti per completare le fasi

## Personalizzazione

### Tema Personalizzato
- **File**: `custom.scss`
- Colori professionali per contesto accademico
- Stile coerente tra tutte le slide

### Modifiche Necessarie

1. **Dati**: Sostituire il dataset di esempio con i propri dati
2. **Contenuto**: Adattare testi ed esempi al proprio contesto
3. **Script**: Completare gli script R con analisi specifiche
4. **Immagini**: Aggiungere grafici e visualizzazioni specifiche

## Requisiti

### Software
- R (versione 4.0+)
- RStudio (consigliato)
- Quarto CLI (versione 1.3+)

### Pacchetti R
```r
install.packages(c(
  "tidyverse",      # Data manipulation
  "ggplot2",        # Visualizzazione
  "summarytools",   # Statistiche descrittive
  "corrplot",       # Correlazioni
  "moments",        # Asimmetria/curtosi
  "caret",          # Machine learning
  "lme4",           # Modelli misti
  "plotly"          # Grafici interattivi
))
```

## Uso

### Generare la Presentazione HTML
```bash
quarto render presentazione.qmd
```

### Visualizzare in Reveal.js
```bash
quarto preview presentazione.qmd
```

### Esportare in PDF
```bash
quarto render presentazione.qmd --to pdf
```

## Struttura dei File

```
.
├── presentazione.qmd       # Presentazione principale
├── custom.scss             # Tema personalizzato
├── script_00_setup.R       # Setup e caricamento dati
├── script_01_cleaning.R    # Data cleaning
├── script_02_*.R           # (Da aggiungere per fasi successive)
├── README.md               # Questo file
└── data/                   # Cartella per dati
    ├── dataset.csv         # Dati grezzi
    └── df_clean.rds        # Dati puliti
```

## Stile e Convenzioni

### Formatazione Slide
- **Titoli**: Intestazione `## Titolo` per nuove slide
- **Sottotitoli**: Intestazione `### Sottotitolo` per sezioni
- **Elenchi**: Bullet points sintetici (max 5 punti per slide)
- **Codice**: Chunk R con opzioni `echo: true, eval: true`

### Tone
- Professionale e accademico
- Didattico e accessibile
- Basato su evidenze scientifiche
- Con esempi pratici

### Colori Principali
- **Primario**: #2c3e50 (Blu scuro)
- **Secondario**: #3498db (Azzurro)
- **Accento**: #e74c3c (Rosso)

## Suggerimenti per l'Uso Didattico

1. **Preparazione**: Eseguire gli script R prima della presentazione
2. **Interattività**: Pause per domande dopo sezioni chiave
3. **Pratica**: Incoraggiare studenti a modificare il codice
4. **Output**: Mostrare grafici e risultati in tempo reale
5. **Discussione**: Collegare concetti teorici a dati reali

## Contributi e Miglioramenti

Per suggerimenti, correzioni o integrazioni:
1. Segnalare issue sul repository
2. Sottomettere pull request con miglioramenti
3. Condividere esperienze di utilizzo

## Licenza

Questo materiale è fornito per scopi didattici e accademici. Verificare le licenze dei pacchetti R utilizzati.

## Autori e Contatti

**Laboratorio di Data Science**
- 📧 Email: laboratorio@unipd.it
- 🌐 Web: https://www.unipd.it
- 📚 Repository: https://github.com/laboratoriodatascience/

## Note Storiche

- **Versione 1.0**: Creazione struttura base della presentazione (2025-12-06)
- **Aggiornamenti**: Da aggiungere nel corso del tempo

---

**Ultimo aggiornamento**: 2025-12-06
