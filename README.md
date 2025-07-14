# Alzheimer’s Dementia Analysis in R

## Project Overview

This project explores a dataset of MRI results and health indicators from over 700 individuals to identify key predictors of dementia. The goal is to assist early diagnosis by revealing patterns through statistical analysis and visualization. The study also investigates gender differences in dementia prevalence using R.

---

## Objectives

- Identify which health scores and brain measurements are strong indicators of dementia.
- Preprocess and clean MRI and health data for analysis.
- Explore gender-based trends in dementia occurrence.
- Visualize key findings using bar plots, scatter plots, and heatmaps.

---

## Repository Structure

- `dementia_analysis.R`: R script with full code for data loading, cleaning, visualization, and analysis.
- `MRI_Alzheimer_Dataset.csv`: Original dataset used (optional - if license allows sharing).
- `README.md`: Project documentation.
- `plots/`: Folder to store all generated graphs.

---

## Methodology

### 1. Data Cleaning & Preprocessing

- Renamed ambiguous columns (e.g., `SES` → `social_economic_status`)
- Removed rows with `NA` values.
- Converted gender to categorical (`factor`) data type.
- Removed redundant columns like `SES`, `MMSE`, and `eTIV` for cleaner analysis.
- Simplified diagnosis labels (`Converted` and `Demented` → `Demented`).

### 2. Key Findings

- **Top Predictive Variables**:
  - Clinical Dementia Rating (CDR)
  - Mini-Mental State Examination (MMSE)
  - Normalized Whole Brain Volume (nWBV)
- **Dementia Indicators**:
  - CDR > 1
  - MMSE < 20
  - nWBV < 0.80
- **Gender Trends**:
  - One gender had significantly higher dementia prevalence—indicating scope for gender-focused interventions.

---

## Visualizations

- **Correlation Heatmap**: Shows strong correlation between CDR, SES, and dementia.
- **Scatter Plots**: Relationship between CDR, MMSE, nWBV, and diagnosis.
- **Bar Charts**:
  - Dementia count by gender.
  - Average variable values grouped by diagnosis for fast pattern recognition.

---

## Packages Used

- `ggplot2` – for rich visualizations
- `dplyr` – for data manipulation
- `lubridate` – for date formatting (if used)
- Base R functions (`summary()`, `head()`, `tail()`, etc.)

---

## References

- R Graph Gallery – Heatmaps and bar plots
- R documentation for:
  - `mutate()`, `case_when()`
  - `ggplot2`, `dplyr`

---
