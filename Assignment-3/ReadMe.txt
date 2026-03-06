Sections 3 and 4: Machine Learning Prediction & Cross-study Generalization
Programming Language Used: Python

1) Overview

This README describes how Sections 3 and 4 of Assignment-3 were solved using machine learning on microbiome species abundance data from four different studies.
It includes:

Dataset loading and merging steps

Preprocessing

Model selection and training

Performance evaluation

Leave-One-Study-Out (LOSO) generalization

Key findings and interpretation

2) Datasets Used (provided in Assignment ZIP)

Species abundance matrices:

Species_LloydPriceJ_2019.csv
Species_SongJ_2023.csv
Species_WallenZ_2020.csv
Species_YachidaS_2019.csv


Corresponding metadata files:

Metadata_LloydPriceJ_2019.csv
Metadata_SongJ_2023.csv
Metadata_WallenZ_2020.csv
Metadata_YachidaS_2019.csv


Metadata columns used:

study_name

age

disease

3) Software and Libraries

Python version: 3.10+

Required libraries:

pandas
numpy
matplotlib
scikit-learn
xgboost
scipy

4) Section 3 — Model Training and Evaluation
4.1 PREPROCESSING PIPELINE
Step 1 — Load all CSV files
import pandas as pd
import os

base_path = "./"

species_files = [
    "Species_LloydPriceJ_2019.csv",
    "Species_SongJ_2023.csv",
    "Species_WallenZ_2020.csv",
    "Species_YachidaS_2019.csv"
]
meta_files = [
    "Metadata_LloydPriceJ_2019.csv",
    "Metadata_SongJ_2023.csv",
    "Metadata_WallenZ_2020.csv",
    "Metadata_YachidaS_2019.csv"
]

species_tables = [pd.read_csv(os.path.join(base_path, f), index_col=0)
                  for f in species_files]
meta_tables = [pd.read_csv(os.path.join(base_path, f), index_col=0)
               for f in meta_files]

Step 2 — Combine species tables (stack by rows)
combined_species = pd.concat(species_tables, axis=0, join="outer")

Step 3 — Combine metadata (stack by rows)
combined_meta = pd.concat(meta_tables, axis=0)

Step 4 — Merge into a single dataset
final_df = combined_species.join(combined_meta, how="inner")


Final dataset shape obtained:

2566 samples × 2221 columns

4.2 LABELS
Disease (binary classification):
Control        → 0
Disease(other) → 1

y_disease_bin = (final_df["disease"] != "Control").astype(int)

Age (numerical regression):
y_age = final_df["age"].astype(float)

4.3 FEATURE MATRIX

Species abundance features (float):

feature_cols = [c for c in final_df.columns if c not in
                ["study_name", "age", "disease"]]
X = final_df[feature_cols].fillna(0.0).astype("float32")

4.4 TRAIN-TEST SPLIT (Section 3)
from sklearn.model_selection import train_test_split

X_train, X_test, y_train_cls, y_test_cls, \
    y_train_age, y_test_age = train_test_split(
        X, y_disease_bin, y_age,
        test_size=0.2,
        random_state=42,
        stratify=y_disease_bin
    )

4.5 MODELS USED
Classification:

Random Forest (RF)

XGBoost (XGB)

Regression:

Random Forest Regressor

XGBoost Regressor

4.6 TRAINING & TESTING CODE — Classification
from sklearn.metrics import accuracy_score, roc_auc_score
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier

# RF Classifier
rf_clf = RandomForestClassifier(
    n_estimators=300,
    class_weight="balanced",
    random_state=42
)
rf_clf.fit(X_train, y_train_cls)
y_pred_rf = rf_clf.predict(X_test)
y_proba_rf = rf_clf.predict_proba(X_test)[:, 1]
rf_acc = accuracy_score(y_test_cls, y_pred_rf)
rf_auc = roc_auc_score(y_test_cls, y_proba_rf)

# XGB Classifier
xgb_clf = XGBClassifier(
    n_estimators=300,
    learning_rate=0.05,
    max_depth=5,
    subsample=0.8,
    colsample_bytree=0.8,
    eval_metric="auc",
    random_state=42
)
xgb_clf.fit(X_train, y_train_cls)
y_proba_xgb = xgb_clf.predict_proba(X_test)[:, 1]
y_pred_xgb = (y_proba_xgb >= 0.5).astype(int)
xgb_acc = accuracy_score(y_test_cls, y_pred_xgb)
xgb_auc = roc_auc_score(y_test_cls, y_proba_xgb)

4.7 TRAINING & TESTING CODE — Age Regression
from sklearn.metrics import mean_absolute_error
from scipy.stats import pearsonr
from sklearn.ensemble import RandomForestRegressor
from xgboost import XGBRegressor

# RF Age
rf_reg = RandomForestRegressor(n_estimators=300, random_state=42)
rf_reg.fit(X_train, y_train_age)
y_pred_rf_age = rf_reg.predict(X_test)
rf_mae = mean_absolute_error(y_test_age, y_pred_rf_age)
rf_corr, _ = pearsonr(y_test_age, y_pred_rf_age)

# XGB Age
xgb_reg = XGBRegressor(
    n_estimators=300,
    learning_rate=0.05,
    max_depth=5,
    subsample=0.8,
    colsample_bytree=0.8,
    objective="reg:squarederror",
    random_state=42
)
xgb_reg.fit(X_train, y_train_age)
y_pred_xgb_age = xgb_reg.predict(X_test)
xgb_mae = mean_absolute_error(y_test_age, y_pred_xgb_age)
xgb_corr, _ = pearsonr(y_test_age, y_pred_xgb_age)

4.8 RESULTS SUMMARY (Section 3)
Classification (random 80/20 split)

RF: Accuracy = 0.6907, AUC = 0.7826

XGB: Accuracy = 0.6926, AUC = 0.7884

Age Prediction (random 80/20 split)

RF: MAE = 8.8508, Corr = 0.7046

XGB: MAE = 8.6967, Corr = 0.7176

5) Section 4 — Leave-One-Study-Out (LOSO)
5.1 LOSO Logic

For each study:

Train using samples from 3 studies

Test strictly on the held-out study

Compute metrics

Repeat for all 4 studies

5.2 Helper function
def get_study_data(study_name):
    df_s = final_df[final_df["study_name"] == study_name]
    X_s = df_s[feature_cols].fillna(0.0).astype("float32")
    y_s_cls = (df_s["disease"] != "Control").astype(int)
    y_s_age = df_s["age"].astype(float)
    return X_s, y_s_cls, y_s_age

5.3 LOSO — Disease Classification

(Training RF & XGB for each held-out study)

Final LOSO results obtained:

Held-out study	RF Accuracy	RF AUC	XGB Accuracy	XGB AUC
LloydPriceJ_2019	0.4267	0.5038	0.3978	0.5254
SongJ_2023	0.4398	0.4531	0.5746	0.4519
WallenZ_2020	0.4075	0.4957	0.3813	0.4092
YachidaS_2019	0.5642	0.4734	0.5417	0.5018
5.4 LOSO — Age Prediction
Held-out study	RF MAE	RF Corr	XGB MAE	XGB Corr
LloydPriceJ_2019	22.22	0.1216	21.42	0.1071
SongJ_2023	21.47	0.0792	19.24	0.0662
WallenZ_2020	24.07	0.0249	24.35	0.0952
YachidaS_2019	22.42	0.2152	22.48	0.2291
6) Interpretation Notes

Random train-test splits produce much stronger results than LOSO → microbiome patterns do not generalize well across cohorts

XGBoost slightly outperforms Random Forest overall

Disease classification AUC remains low in LOSO

Age prediction correlations remain weak in LOSO

Performance differences reflect dataset heterogeneity (sample processing, population variation, sequencing depth differences, etc.)

7) Assumptions & Additional Notes

Missing abundance values assumed as 0 (species absent)

No additional normalization or filtering applied

Disease labels simplified to binary

No hyperparameter tuning performed (default + reasonable settings)

Trained models are reproducible with random_state=42

8) Reproducibility

To reproduce all results:

Place all 8 CSV files in the same directory

Run the Python scripts exactly as provided

Results will match (minor floating-point tolerance possible)