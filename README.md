# Computational Metagenomics (CoMeg) – Assignments Repository

## Overview

This repository contains coursework and assignments completed for the **Computational Metagenomics (CoMeg)** course. The assignments explore microbial community analysis, microbiome data processing, and machine learning methods for analyzing metagenomic datasets.

The repository includes implementations of microbiome analysis workflows, statistical analysis of microbial communities, and predictive modeling using species abundance data.

---

# Repository Structure

```
Computational-Metagenomics-CoMeg/
│
├── Assignment-1/
│   ├── scripts / notebooks
│   ├── analysis outputs
│   └── README.md
│
├── Assignment-2/
│   ├── Comeg_assignment_2_group3.ipynb
│   ├── CoMeg Assignment-2 Report (Group-3).pdf
│   ├── data/
│   ├── q1_outputs/
│   ├── q2_outputs/
│   ├── q3_outputs/
│   └── README.md
│
├── Assignment-3/
│   ├── machine learning scripts
│   ├── dataset files
│   └── README.md
│
└── Additional materials
```

---

# Assignment 1 – 16S rRNA Microbiome Processing Pipeline

Assignment 1 focuses on building a **complete microbiome analysis pipeline** for processing 16S rRNA sequencing data.

The workflow includes:

1. **Quality Control**

   * Raw sequencing reads were assessed using FastQC.

2. **Read Trimming**

   * Low-quality bases and sequencing adapters were removed using Trimmomatic.

3. **Taxonomic Classification**

   * Species-level classification was performed using the SPINGO classifier with the RDP database.

4. **Species Abundance Calculation**

   * Species counts were converted into relative abundance tables.

5. **Diversity Analysis**

   * Shannon diversity index
   * Pielou’s evenness

The pipeline generates species abundance tables, diversity metrics, and visualization outputs. 

---

# Assignment 2 – Microbial Community Analysis

Assignment 2 performs **statistical analysis of microbial community composition** using species abundance profiles and metadata.

The project includes three major analyses:

### Alpha Diversity

* Shannon diversity index calculation
* Comparison across age groups and disease conditions
* Statistical tests (Mann-Whitney U and Kruskal-Wallis)

### Beta Diversity

* Bray-Curtis dissimilarity
* Principal Coordinate Analysis (PCoA)
* PERMANOVA statistical tests
* Community clustering visualization

### Differential Abundance Analysis

* Identification of microbial species associated with disease
* Statistical testing using Wilcoxon tests
* False Discovery Rate (FDR) correction
* Visualization with volcano plots and species abundance boxplots

The full analysis workflow and results are documented in the accompanying report and notebook. 

---

# Assignment 3 – Machine Learning for Microbiome Data

Assignment 3 applies **machine learning models to microbiome datasets** to predict disease status and host age from species abundance profiles.

## Datasets

Four microbiome cohort datasets were used:

* LloydPriceJ_2019
* SongJ_2023
* WallenZ_2020
* YachidaS_2019

These datasets include:

* species abundance matrices
* sample metadata (age, disease status, study)

## Tasks Performed

### Disease Classification

Binary classification predicting disease vs control.

Models used:

* Random Forest
* XGBoost

Evaluation metrics:

* Accuracy
* ROC-AUC

### Age Prediction

Regression models predicting host age using microbial species profiles.

Metrics used:

* Mean Absolute Error (MAE)
* Pearson correlation

### Cross-Study Generalization

Leave-One-Study-Out (LOSO) validation was performed to test how well models trained on some studies generalize to unseen cohorts.

Results showed strong performance in random splits but significantly reduced accuracy in LOSO experiments due to dataset heterogeneity. 

---

# Technologies Used

Programming Languages

* Python
* Bash

Bioinformatics Tools

* FastQC
* Trimmomatic
* SPINGO

Python Libraries

* pandas
* numpy
* matplotlib
* scikit-learn
* xgboost
* scipy

Statistical Methods

* Shannon diversity
* Bray-Curtis dissimilarity
* PERMANOVA
* Wilcoxon tests
* Machine learning classification and regression

---

# Reproducibility

To reproduce the analyses:

1. Install required Python libraries.
2. Place all required dataset files in the corresponding directories.
3. Execute the notebooks or scripts in each assignment folder.

Each assignment folder contains its own documentation explaining how to run the workflow.

---

# Authors

Group 3 – Computational Metagenomics

* Athiyo Chakma
* Dev Utkarsh Pal
* Kunjkumar Prajapati
* Gargi

---

