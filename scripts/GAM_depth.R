#######################################################
# GENERALIZED ADDITIVE MODELS: PROXY DATA VS CORE DEPTH

# Run a GAM on your sediment core proxy data according to depths of the core.

# I use files found in the /data folder of this repo:
# https://github.com/johannabosch/Paleolimnological_Analysis_in_R

setwd("Paleolimnological_Analysis_in_R/")

library(mgcv)      # For GAMs
library(ggplot2)   # For plotting
library(analogue)  # For general use and support of other packages
library(gratia)    # For derivatives to identify significant periods of change
library(viridis)   # For colors
library(ggpubr)    # For arranging plots

signifD <- function(x, d, upper, lower, eval = 0) {
  miss <- upper > eval & lower < eval
  incr <- decr <- x
  want <- d > eval
  incr[!want | miss] <- NA
  want <- d < eval
  decr[!want | miss] <- NA
  list(incr = incr, decr = decr)
}

# Load the proxy data
pd <- read.csv("data/FileS5_ProxyData_CSM-IMP.csv")

# Create new columns for Zn/Al, Cd/Al, and Phosphorus (P)
pd$Zn_Al <- pd$Zn / pd$Al
pd$Cd_Al <- pd$Cd / pd$Al

# Create individual data frames for each variable and remove NA values
chla_df <- pd[, c("midpoint", "chla")]
chla_df <- chla_df[complete.cases(chla_df), ]

d15N_df <- pd[, c("midpoint", "d15N")]
d15N_df <- d15N_df[complete.cases(d15N_df), ]

Cd_Al_df <- pd[, c("midpoint", "Cd_Al")]
Cd_Al_df <- Cd_Al_df[complete.cases(Cd_Al_df), ]

Zn_Al_df <- pd[, c("midpoint", "Zn_Al")]
Zn_Al_df <- Zn_Al_df[complete.cases(Zn_Al_df), ]

S_cons_df <- pd[, c("midpoint", "S.cons")]
S_cons_df <- S_cons_df[complete.cases(S_cons_df), ]

P_df <- pd[, c("midpoint", "P")]
P_df <- P_df[complete.cases(P_df), ]

# Function to run GAM analysis on the cleaned data
run_gam_analysis <- function(data, response_var, k_value) {
  print(paste("Running GAM for:", response_var))  # Debugging output
  print(head(data))  # Check the data being used
  
  if (nrow(data) == 0) {
    warning(paste("No data available for", response_var))
    return(NULL)
  }
  
  gam_model <- gam(as.formula(paste(response_var, "~ s(midpoint, k =", k_value, ")")), data = data, method = "REML")
  gam.check(gam_model)
  
  fit_gcv <- predict(gam_model, newdata = data, se.fit = TRUE)
  crit.t <- qt(0.975, df.residual(gam_model))
  
  new_data <- data.frame(midpoint = data$midpoint, fit = fit_gcv$fit, se.fit = fit_gcv$se.fit)
  new_data <- transform(new_data, upper = fit + (crit.t * se.fit), lower = fit - (crit.t * se.fit))
  
  derivatives_data <- derivatives(gam_model, type = "central", n = length(data$midpoint))
  sig_data <- signifD(new_data$fit, d = derivatives_data$.derivative, upper = derivatives_data$.upper_ci, lower = derivatives_data$.lower_ci)
  
  new_data$incr <- as.numeric(sig_data$incr)  # Ensure numeric
  new_data$decr <- as.numeric(sig_data$decr)  # Ensure numeric
  
  # Debugging output
  print(head(new_data))
  
  return(list(new_data = new_data, original_data = data))
}

# Function to create plots
create_plot <- function(new_data, original_data, response_var, y_label) {
  print(paste("Creating plot for:", response_var))  # Debugging output
  
  if (nrow(new_data) == 0 || all(is.na(new_data$fit))) {
    warning(paste("All", response_var, "values are NA or no data after filtering. Skipping plot."))
    return(NULL)
  }
  
  plot <- ggplot() +
    geom_ribbon(data = new_data, aes(x = midpoint, ymax = upper, ymin = lower), fill = "#b3e0ff", alpha = 0.5) +
    geom_line(data = new_data, aes(y = fit, x = midpoint), colour = "lightblue4") +
    geom_line(data = new_data, aes(y = incr, x = midpoint), colour = "deepskyblue4", size = 1) +
    geom_line(data = new_data, aes(y = decr, x = midpoint), colour = "deepskyblue4", size = 1) +
    geom_point(data = original_data, aes_string(y = response_var, x = "midpoint"), shape = 21, fill = "#0099cc", colour = "lightblue4", size = 0.5) +
    scale_x_reverse(limits = c(26, 0), breaks = seq(26, 0, by = -1)) +  # Enforce x-axis limits
    labs(x = NULL, y = y_label) +
    theme_classic() +
    theme(text = element_text(size = 10, face = "bold"))
  
  return(plot)
}

# Run the analyses for each cleaned data frame
chla_results <- run_gam_analysis(chla_df, "chla", 82)
d15N_results <- run_gam_analysis(d15N_df, "d15N", 26)
Cd_Al_results <- run_gam_analysis(Cd_Al_df, "Cd_Al", 15)
Zn_Al_results <- run_gam_analysis(Zn_Al_df, "Zn_Al", 15)
S_cons_results <- run_gam_analysis(S_cons_df, "S.cons", 17)
P_results <- run_gam_analysis(P_df, "P", 15)

# Create the plots
chla_plot <- if (!is.null(chla_results)) create_plot(chla_results$new_data, chla_results$original_data, "chla", "Chlorophyll-a") else NULL
d15N_plot <- if (!is.null(d15N_results)) create_plot(d15N_results$new_data, d15N_results$original_data, "d15N", "d15N") else NULL
Cd_Al_plot <- if (!is.null(Cd_Al_results)) create_plot(Cd_Al_results$new_data, Cd_Al_results$original_data, "Cd_Al", "Cd/Al") else NULL
Zn_Al_plot <- if (!is.null(Zn_Al_results)) create_plot(Zn_Al_results$new_data, Zn_Al_results$original_data, "Zn_Al", "Zn/Al") else NULL
S_cons_plot <- if (!is.null(S_cons_results)) create_plot(S_cons_results$new_data, S_cons_results$original_data, "S.cons", "S.cons") else NULL
P_plot <- if (!is.null(P_results)) create_plot(P_results$new_data, P_results$original_data, "P", "Phosphorus") else NULL

# Combine the plots
ggarrange(chla_plot, d15N_plot, Zn_Al_plot, Cd_Al_plot, S_cons_plot, P_plot, ncol = 2, nrow = 3, heights = 5, widths = 5)
