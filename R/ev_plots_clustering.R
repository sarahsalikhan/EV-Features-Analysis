# ==========================================================
# EV Plots & Clustering (GitHub-ready)  —  ev_plots_clustering.R
# ==========================================================

# ---- Setup ----
# Install/load helper for paths
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

# CHANGED: also load ggcorrplot and reshape2 here so ggcorrplot() exists
pacman::p_load(
  here, dplyr, ggplot2,
  ggcorrplot,   # NEW
  reshape2      # NEW
)

options(scipen = 999)  # avoid scientific notation

# Paths
data_path <- here::here("data", "EV_cars.csv")  # relative path to data
fig_dir   <- here::here("figures")              # relative path to figures
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)

# Load dataset
if (!file.exists(data_path)) stop("Place EV_cars.csv in /data")
cars <- read.csv(data_path, check.names = TRUE, stringsAsFactors = FALSE)

# ---- Analysis ----
#a Load data file
ev_df <- read.csv(data_path, check.names = TRUE, stringsAsFactors = FALSE)

#a Displaying 1st 6 rows
head(ev_df)
print(head(ev_df))

# ---- Correlation matrix prep ----
# dropping likely categorical cols:
# If the dataset has at least 3 columns, drop indices 2 and 3; then keep only numerics
drop_idx   <- intersect(c(2, 3), seq_along(ev_df))
df_num_raw <- if (length(drop_idx)) ev_df[, -drop_idx, drop = FALSE] else ev_df
df_num     <- dplyr::select(df_num_raw, where(is.numeric))

# Save correlation matrix to CSV (reproducibility)
cor_matrix <- cor(df_num, use = "pairwise.complete.obs")
write.csv(cor_matrix, file.path(fig_dir, "correlation_matrix_plots_script.csv"), row.names = TRUE)

# ---- Base heatmap (saved) ----
png(file.path(fig_dir, "heatmap_base.png"), width = 900, height = 900, res = 150)
heatmap(cor_matrix, Rowv = NA, Colv = NA, scale = "none")
dev.off()

# ---- Remove rows with NA for stricter viz/cluster steps ----
records.missing <- rowSums(is.na(ev_df)) > 0
df <- ev_df[!records.missing, , drop = FALSE]
str(df)

# Rebuild numeric-only after NA removal (and drop indices 2/3 again, safely)
df_nocat_raw <- if (length(drop_idx)) df[, -drop_idx, drop = FALSE] else df
df_nocat     <- dplyr::select(df_nocat_raw, where(is.numeric))

# ---- ggcorrplot figures (saved) ----
corr <- round(cor(df_nocat, use = "pairwise.complete.obs"), 2)

p_corr_full <- ggcorrplot(corr, type = "lower", lab = TRUE)
ggsave(file.path(fig_dir, "corr_heatmap_full.png"), p_corr_full, width = 8, height = 8, dpi = 300)

corr_masked <- corr * (abs(corr) >= 0.5)
p_corr_mask <- ggcorrplot(corr_masked, type = "lower", lab = TRUE)
ggsave(file.path(fig_dir, "corr_heatmap_masked_0_5.png"), p_corr_mask, width = 8, height = 8, dpi = 300)

# ---- Melted heatmap with ggplot (saved) ----
cor_melted <- reshape2::melt(cor(df_nocat, use = "pairwise.complete.obs"))
heatmap_plot <- ggplot(cor_melted, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
ggsave(file.path(fig_dir, "corr_heatmap_ggplot.png"), heatmap_plot, width = 8, height = 8, dpi = 300)

heatmap_plot_with_values <- heatmap_plot +
  geom_text(aes(label = sprintf("%.2f", value)), vjust = 1) +
  theme(legend.position = "bottom")
ggsave(file.path(fig_dir, "corr_heatmap_ggplot_labeled.png"), heatmap_plot_with_values, width = 8, height = 8, dpi = 300)

# ---- Pair plots (saved) ----
png(file.path(fig_dir, "pairs_all.png"), width = 1400, height = 1400, res = 130)
plot(ev_df)
dev.off()

png(file.path(fig_dir, "pairs_no_cat.png"), width = 1400, height = 1400, res = 130)
plot(df_num, col = "blue")
dev.off()

# ---- Summaries (optional saved artifacts) ----
sink(file.path(fig_dir, "summary_ev_df.txt"));    print(summary(ev_df));    sink()
sink(file.path(fig_dir, "summary_df_num.txt"));   print(summary(df_num));   sink()
sink(file.path(fig_dir, "summary_df_nocat.txt")); print(summary(df_nocat)); sink()

# ==========================================================
# CLUSTER ANALYSIS
# ==========================================================

# Scale numeric features
df_scaled <- scale(df_nocat)
print(head(df_scaled))

# Dissimilarity matrix & Hierarchical clustering (Complete)
d   <- dist(df_scaled, method = "euclidean")
hc1 <- hclust(d, method = "complete")

# Save dendrogram
png(file.path(fig_dir, "hc_complete_dendrogram.png"), width = 1100, height = 700, res = 150)
plot(hc1, cex = 0.6, hang = -1, main = "Hierarchical Clustering (Complete)")
abline(h = mean(hc1$height), lty = 2)
dev.off()

# Membership tables for k = 2 and k = 3
memb_k2 <- cutree(hc1, k = 2)
memb_k3 <- cutree(hc1, k = 3)
print(table(memb_k2))
print(table(memb_k3))

# Save membership to CSVs
write.csv(data.frame(id = seq_along(memb_k2), cluster_k2 = memb_k2),
          file.path(fig_dir, "hc_membership_k2.csv"), row.names = FALSE)
write.csv(data.frame(id = seq_along(memb_k3), cluster_k3 = memb_k3),
          file.path(fig_dir, "hc_membership_k3.csv"), row.names = FALSE)

# k-means (k=2, k=3) with reproducibility
set.seed(42)
km2 <- kmeans(df_scaled, centers = 2, nstart = 25)
km3 <- kmeans(df_scaled, centers = 3, nstart = 25)
print(km2$size); print(km3$size)

# Save k-means assignments
write.csv(data.frame(id = seq_along(km2$cluster), km2_cluster = km2$cluster),
          file.path(fig_dir, "kmeans_k2_assignments.csv"), row.names = FALSE)
write.csv(data.frame(id = seq_along(km3$cluster), km3_cluster = km3$cluster),
          file.path(fig_dir, "kmeans_k3_assignments.csv"), row.names = FALSE)

# Simple 2D projections (first two scaled features) for k-means clusters (saved)
if (ncol(df_scaled) >= 2) {
  proj <- as.data.frame(df_scaled[, 1:2, drop = FALSE])
  names(proj)[1:2] <- c("feat1", "feat2")
  proj$km2 <- factor(km2$cluster)
  proj$km3 <- factor(km3$cluster)

  p_km2 <- ggplot(proj, aes(x = feat1, y = feat2, shape = km2)) +
    geom_point() +
    labs(title = "k-means (k=2): First Two Scaled Features", x = "feat1", y = "feat2") +
    theme_minimal()
  ggsave(file.path(fig_dir, "kmeans_k2_projection.png"), p_km2, width = 7, height = 5, dpi = 300)

  p_km3 <- ggplot(proj, aes(x = feat1, y = feat2, shape = km3)) +
    geom_point() +
    labs(title = "k-means (k=3): First Two Scaled Features", x = "feat1", y = "feat2") +
    theme_minimal()
  ggsave(file.path(fig_dir, "kmeans_k3_projection.png"), p_km3, width = 7, height = 5, dpi = 300)
}

message("All plots and artifacts saved to: ", fig_dir)
