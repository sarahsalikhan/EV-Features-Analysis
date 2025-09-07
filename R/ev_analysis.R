# ============================
# ev_analysis.R (GitHub-ready)
# ============================

# ---- Setup ----
# Install/load helper for paths
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2)

options(scipen = 999)  # avoid scientific notation

# Paths
data_path <- here::here("data", "EV_cars.csv")  # relative path to data
fig_dir   <- here::here("figures")              # relative path to figures
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)

# Load dataset
if (!file.exists(data_path)) stop("Place EV_cars.csv in /data")
cars <- read.csv(data_path, check.names = TRUE, stringsAsFactors = FALSE)

# ---- Quick sanity checks ----
head(cars)
str(cars)

# ---- Analysis ----

# NEW: modern select of numeric columns
cars_numeric <- cars %>% dplyr::select(where(is.numeric))

# --- NA audit for plotting columns ---
na_counts <- sapply(cars[, c("Efficiency","Top_speed","Price.DE.")], function(x) sum(is.na(x)))
print(na_counts)

write.csv(data.frame(Variable=names(na_counts), NAs=as.integer(na_counts)),
          file.path(fig_dir, "na_counts_plot_columns.csv"), row.names = FALSE)


# view correlations, summary
cor_mat <- cor(cars_numeric, use = "pairwise.complete.obs")
print(cor_mat)
print(summary(cars_numeric))

# Save correlation matrix & summary to files for reproducibility
write.csv(cor_mat, file.path(fig_dir, "correlation_matrix.csv"), row.names = TRUE)
sink(file.path(fig_dir, "summary_numeric.txt"));  print(summary(cars_numeric));  sink()

# ---- Plots ----

# Efficiency vs Price (drop NAs used in this plot)
plot_df1 <- cars_numeric %>%
  dplyr::filter(!is.na(Efficiency), !is.na(Price.DE.))

p1 <- ggplot(plot_df1, aes(x = Efficiency, y = Price.DE.)) +
  geom_point(color = "blue") +
  labs(title = "Efficiency vs. Price", x = "Efficiency", y = "Price") +
  theme_minimal()

ggsave(file.path(fig_dir, "scatter_efficiency_price.png"),
       plot = p1, width = 7, height = 5, dpi = 300)

# Top_speed vs Price (drop NAs used in this plot)
plot_df2 <- cars_numeric %>%
  dplyr::filter(!is.na(Top_speed), !is.na(Price.DE.))

p2 <- ggplot(plot_df2, aes(x = Top_speed, y = Price.DE.)) +
  geom_point(color = "blue") +
  labs(title = "Top Speed vs. Price", x = "Top Speed", y = "Price") +
  theme_minimal()

ggsave(file.path(fig_dir, "scatter_topspeed_price.png"),
       plot = p2, width = 7, height = 5, dpi = 300)


# boxplot: Battery
png(file.path(fig_dir, "boxplot_battery.png"), width = 900, height = 600, res = 150)
boxplot(cars$Battery, col = "skyblue", main = "Battery Distribution")
dev.off()

# boxplot: all numeric
png(file.path(fig_dir, "boxplot_all_numeric.png"), width = 900, height = 600, res = 150)
boxplot(cars_numeric, main = "All Numeric Variables")
dev.off()

# ---- Models ----

# Price model vs all numeric factors
model <- lm(Price.DE. ~ ., data = cars_numeric)
summary(model)

# CHANGED: safe minus-Range (only drop if exists)
carsnorange <- if ("Range" %in% names(cars_numeric)) {
  dplyr::select(cars_numeric, -Range)
} else cars_numeric

model2 <- lm(Price.DE. ~ ., data = carsnorange)
summary(model2)

# ---- Brand features & Top-10 ----

# create brand name column
if ("Car_name" %in% names(cars)) {
  cars$Brand <- sapply(strsplit(cars$Car_name, " "), function(x) x[1])
} else if (!"Brand" %in% names(cars)) {
  cars$Brand <- "Unknown"  # CHANGED: fallback to avoid errors if Car_name missing
}

# create average price per brand column
cars <- cars %>%
  dplyr::group_by(Brand) %>%
  dplyr::mutate(Average_Price = mean(Price.DE., na.rm = TRUE)) %>%
  dplyr::ungroup()

# find top 10 brands
carssort <- cars %>% dplyr::arrange(dplyr::desc(Average_Price))

top_10_brands <- carssort %>%
  dplyr::distinct(Brand, .keep_all = TRUE) %>%
  dplyr::slice_head(n = 10)

# CHANGED: save the base R barplot to file
png(file.path(fig_dir, "bar_top10_brands_base.png"), width = 1100, height = 700, res = 150)
barplot(top_10_brands$Average_Price, names.arg = top_10_brands$Brand,
        main = "Top 10 Highest Average Priced EV Car Brands", xlab = "Car Brand",
        ylab = "Average Price", las = 2)
dev.off()

# pretty ggplot version (and save)
p3 <- ggplot(top_10_brands, aes(x = Brand, y = Average_Price, fill = Brand)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Top 10 Highest Average Priced EV Car Brands",
    x = "Car Brand",
    y = "Average Price"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none",
    panel.background = element_blank(),
    axis.line = element_line(color = "black")
  )

ggsave(file.path(fig_dir, "bar_top10_brands_ggplot.png"),
       plot = p3, width = 9, height = 6, dpi = 300)

# see how many of each brand (also save)
brand_counts <- as.data.frame(table(cars$Brand))
names(brand_counts) <- c("Brand", "Count")
print(brand_counts)
write.csv(brand_counts, file.path(fig_dir, "brand_counts.csv"), row.names = FALSE)

# model: Price ~ Brand (ANOVA-style)
carbrandmodel <- lm(Price.DE. ~ Brand, data = cars)
summary(carbrandmodel)

# ---- Save model summaries (TXT) ----
sink(file.path(fig_dir, "model_full_summary.txt"));       print(summary(model));         sink()
sink(file.path(fig_dir, "model_no_range_summary.txt"));   print(summary(model2));        sink()
sink(file.path(fig_dir, "model_brand_summary.txt"));      print(summary(carbrandmodel)); sink()

message("Analysis complete. Figures & artifacts saved to: ", fig_dir)
