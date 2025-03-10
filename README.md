# Progetto di Reti Logiche - 2023/2024

## 📌 Descrizione
Questo progetto implementa un **modulo hardware in VHDL** che elabora una sequenza di parole lette da una memoria, sostituendo i valori **zero** con l’ultimo valore valido e assegnando un valore di **credibilità** che viene aggiornato secondo precise regole.

Il modulo è testato attraverso un **TestBench** fornito dai docenti e sintetizzato utilizzando **Xilinx Vivado Webpack**.

## 🚀 Funzionamento del Modulo
1. **Lettura dei dati** dalla memoria a partire dall’indirizzo `ADD`.
2. **Sostituzione dei valori zero** con l’ultimo valore valido precedente.
3. **Calcolo del valore di credibilità (C)**:
    - Se il valore non è zero, `C = 31`.
    - Se il valore è zero, `C` viene decrementato fino a un minimo di `0`.
4. **Scrittura del risultato** nella memoria.

### 📖 Esempio di Elaborazione
**Input (sequenza di partenza):**
128 0 64 0 0 0 100 0 1 0 0 0 5 0 23 0 200 0 0 0
**Output (sequenza elaborata):**
128 31 64 31 64 30 64 29 100 31 1 31 1 30 5 31 23 31 200 31 200 30

## 🛠️ Setup del Progetto
### 1️⃣ Requisiti
- **Xilinx Vivado Webpack** (consigliata versione 2016.4)
- **Linguaggio:** VHDL

### 2️⃣ Clonare la repository
Apri un terminale e clona questa repository in locale:
```sh
git clone https://github.com/TUO-NOME-UTENTE/reti-logiche-2024.git
cd reti-logiche-2024
