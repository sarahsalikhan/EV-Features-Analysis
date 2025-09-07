# EV-Features-Analysis

Analysis of electric vehicle (EV) specifications and pricing in Germany using R. Includes exploratory data analysis, regression modeling, brand-level comparisons, and clustering to identify which factors most influence EV prices.





## Data Analysis on Electric Vehicle Specifications and Prices



This repository contains code and analysis for our \*\*ISM6423 Data Analytics \& Decision Support\*\* course project. The project investigates which technical specifications most influence the prices of electric vehicles (EVs) in Germany using data from the \[Electric Vehicle Database (Kaggle)](https://www.kaggle.com/datasets/fatihilhan/electric-vehicle-specifications-and-prices).



---



## 📌 Research Question

\*\*Which specifications for electric vehicles influence their price in Euros in Germany, what is the size of their effects, and how statistically significant is each?\*\*



---



## 📂 Project Structure

├─ data/
│ └─ EV_cars.csv # Dataset (must be placed here)
├─ figures/ # Auto-generated plots and outputs
├─ R/
│ ├─ ev_analysis.R # Regression models, brand-level analysis, plots
│ └─ ev_plots_clustering.R # Correlation heatmaps, clustering analysis
├─ README.md # Project documentation
├─ .gitignore
└─ LICENSE

---

## 🔧 Setup

### Requirements
- **R version**: 4.1 or higher
- **Required packages**:
  - pacman  
  - here  
  - dplyr  
  - ggplot2  
  - ggcorrplot  
  - reshape2  
  - tidyr  

### Install Packages (Simple Option)
Run this once in R:

install.packages(c("pacman", "here", "dplyr", "ggplot2", "ggcorrplot", "reshape2", "tidyr"))

For exact package versions, use {renv}:

install.packages("renv")
renv::restore()   # installs the exact package versions from renv.lock

--------

### 🚀 How to Run

Clone or download this repo.

Place the dataset file EV_cars.csv inside the /data folder.

Run the analysis scripts in R:

### Run regression analysis and brand-level plots
source("R/ev_analysis.R")

### Run correlation heatmaps and clustering analysis
source("R/ev_plots_clustering.R")

All figures and text outputs will be saved to the /figures folder.

---


### 📊 Methods Overview
#### 1. Exploratory Data Analysis

Correlations & summary statistics

Scatterplots: Efficiency vs Price, Top Speed vs Price

Boxplots of Battery and all numeric variables

#### 2. Regression Models

Model 1: Price vs all numeric predictors

Model 2: Price vs predictors excluding Range (to reduce collinearity)

Brand model: Price ~ Brand (ANOVA-style)

#### 3. Brand-Level Insights

Extracted Brand from Car_name

Calculated Average_Price per brand

Identified Top 10 most expensive EV brands

Visualized using both base R and ggplot2

#### 4. Correlation & Clustering

Heatmaps with ggcorrplot and ggplot2

Hierarchical clustering (Complete linkage)

k-means clustering with k=2, k=3

Cluster membership tables and dendrograms

### 📈 Key Findings

Efficiency and Top Speed are the strongest predictors of price.

Battery capacity and Fast charging time also significant at 0.01–0.05 levels.

Brand mediates pricing: Porsche, Lucid, and Lotus command the highest price premiums.

Range and Battery are highly correlated (r ≈ 0.88).

Clustering reveals clear groupings of EVs by efficiency and performance.

----------------------------------
### 📊 Dataset

\- \*\*Observations:\*\* 360  

\- \*\*Variables:\*\* 9 (7 numeric, 2 categorical)  

\- \*\*Key Columns:\*\*

&nbsp; - `Battery` – Capacity in kWh  

&nbsp; - `Efficiency` – Energy efficiency (Wh/km)  

&nbsp; - `Fast charge` – Fast charging capability (minutes)  

&nbsp; - `Range` – Driving range (km)  

&nbsp; - `Top speed` – Maximum speed (km/h)  

&nbsp; - `Acceleration 0–100` – Acceleration in seconds  

&nbsp; - `Price.DE.` – Vehicle price (€) in Germany  

&nbsp; - `Car\_name`, `Brand` (derived), `Average\_Price` (derived)



---

### 📂 Outputs

The following are saved automatically in /figures:

scatter_efficiency_price.png

scatter_topspeed_price.png

boxplot_battery.png

boxplot_all_numeric.png

bar_top10_brands_base.png

bar_top10_brands_ggplot.png

corr_heatmap_full.png

corr_heatmap_masked_0_5.png

corr_heatmap_ggplot.png

corr_heatmap_ggplot_labeled.png

hc_complete_dendrogram.png

kmeans_k2_projection.png

kmeans_k3_projection.png

plus CSV/TXT outputs: correlation matrices, model summaries, brand counts, cluster memberships

-----



### 📚 References

Fatih Ilhan. Electric Vehicle Specifications and Prices (Kaggle Dataset). Nov 2023.

International Energy Agency (IEA). Demand for Electric Cars is Booming. 2023.

Union of Concerned Scientists (UCS). What are Electric Cars? 2015.

Amanda Sloat. Germany’s Green Party and EV Policy. Brookings Institution, 2020.

U.S. Energy Information Administration (EIA). Germany Energy Analysis. 2020


### ✍️ Authors
Kirsten Hugh • Swetha Chukka • Samantha Snyder • Joshua Ippolitov • Sarah Alikhan

----

### 📜 License

This project is released under the MIT License.
See LICENSE for details.

