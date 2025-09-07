# EV-Features-Analysis

Analysis of electric vehicle (EV) specifications and pricing in Germany using R. Includes exploratory data analysis, regression modeling, brand-level comparisons, and clustering to identify which factors most influence EV prices.





#### Data Analysis on Electric Vehicle Specifications and Prices



This repository contains code and analysis for our \*\*ISM6423 Data Analytics \& Decision Support\*\* course project. The project investigates which technical specifications most influence the prices of electric vehicles (EVs) in Germany using data from the \[Electric Vehicle Database (Kaggle)](https://www.kaggle.com/datasets/fatihilhan/electric-vehicle-specifications-and-prices).



---



#### 📌 Research Question

\*\*Which specifications for electric vehicles influence their price in Euros in Germany, what is the size of their effects, and how statistically significant is each?\*\*



---



#### 📂 Project Structure

├─ data/

│ └─ EV\_cars.csv # EV dataset from Kaggle

├─ figures/ # Auto-generated plots and charts

├─ ev\_analysis.R # Main analysis script

├─ ISM6423 Final Paper.pdf # Full written report

└─ README.md # This file

---



#### 📊 Dataset

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



#### ⚙️ Methods

The analysis was conducted in \*\*R\*\* using packages such as `ggplot2`, `dplyr`, `ggcorrplot`, and `reshape2`.



##### 1\. \*\*Exploratory Data Analysis (EDA)\*\*

\- Summary statistics for all numeric variables  

\- Correlation matrix \& heatmaps  

\- Scatterplots:

&nbsp; - Efficiency vs. Price

&nbsp; - Top Speed vs. Price  

\- Boxplots for distribution checks  



##### 2\. \*\*Regression Models\*\*

\- \*\*Model 1:\*\* Price vs. all numeric predictors  

\- \*\*Model 2:\*\* Price vs. numeric predictors (excluding Range to reduce multicollinearity)  

\- \*\*Brand Impact Model:\*\* Price ~ Brand (ANOVA-style)  



##### 3\. \*\*Brand-Level Analysis\*\*

\- Created a `Brand` variable from car names  

\- Calculated `Average\_Price` per brand  

\- Ranked and visualized the \*\*Top 10 most expensive EV brands\*\*  



##### 4\. \*\*Clustering\*\*

\- Hierarchical clustering (Complete linkage)  

\- k-means clustering with 2–3 clusters  

\- Dendrograms and projection plots  



---



#### 📈 Key Findings

\- \*\*Efficiency\*\* and \*\*Top Speed\*\* were the most statistically significant predictors of EV price (p < 0.001).  

\- \*\*Battery capacity\*\* and \*\*Fast charging time\*\* were also significant predictors at the 0.01–0.05 levels.  

\- \*\*Brand acts as a mediator\*\*: Porsche, Lucid, and Lotus had the strongest premium impact, followed by BMW and Mercedes:contentReference\[oaicite:0]{index=0}.  

\- Correlation analysis showed:

&nbsp; - Range and Battery were highly correlated (0.88), so Range was removed in regression.  

&nbsp; - Acceleration had a negative relationship with most variables.  

\- Cluster analysis grouped EVs into \*\*4 main clusters\*\*, reinforcing the role of efficiency and top speed in price differentiation.  



---



#### 📂 Outputs

Figures generated include:

\- Scatterplots (Efficiency vs. Price, Top Speed vs. Price)  

\- Correlation heatmaps (base R + `ggcorrplot`)  

\- Boxplots of numeric variables  

\- Bar chart of Top 10 EV brands by price  

\- Dendrograms and k-means cluster visualizations  



---



#### 🚀 How to Run

1\. Place `EV\_cars.csv` in the `/data` folder.  

2\. Run the analysis script in R:

&nbsp;  ```r

&nbsp;  source("ev\_analysis.R")

Outputs (plots \& figures) will be saved in the /figures folder.



Model results will print in the R console.



#### 📚 References

Fatih Ilhan. Electric Vehicle Specifications and Prices (Kaggle Dataset). Nov 2023.



International Energy Agency (IEA). Demand for Electric Cars is Booming. 2023.



Union of Concerned Scientists (UCS). What are Electric Cars? 2015.



Amanda Sloat. Germany’s Green Party and EV Policy. Brookings Institution, 2020.



U.S. Energy Information Administration (EIA). Germany Energy Analysis. 2020

ISM6423 Final Paper



.



#### ✍️ Authors

Team Data Detectives

Kirsten Hugh • Swetha Chukka • Samantha Snyder • Joshua Ippolitov • Sarah Alikhan



