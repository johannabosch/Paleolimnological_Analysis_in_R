##################
# RUN A BREAKPOINT ANALYSIS ON METAL(LOID)S

# This is a breakpoint analysis for metal(loid) data obtained from individual coring sites.
# I used data containing more than 20 metals, and their concentrations at each depth of the impacted core.
# Data files can be found in the GitHub repo: 
# `FileS7_Metalloids_CSM-IMP.csv` and `FileS8_Metalloids_CSM-REF.csv`

# Access the files [here](https://github.com/johannabosch/Paleo_Analysis_Using_R).

# Libraries
library(tidyverse)
library(tidypaleo)
library(vegan)

# Load and prepare the data
metals_IMP <- read.csv("data/FileS7_Metalloids_CSM-IMP.csv")

# Convert to long format
metals_long_IMP <- metals_IMP %>%
  pivot_longer(-depth, names_to = "metals", values_to = "concentration")

# Check the structure of the data
str(metals_long_IMP)

# Check for NA values
sum(is.na(metals_long_IMP))

# Ensure depth column is numeric
metals_long_IMP$depth <- as.numeric(metals_long_IMP$depth)

# Remove rows with missing values in either depth or concentration
metals_long_IMP <- metals_long_IMP %>%
  filter(!is.na(depth) & !is.na(concentration))

# Perform a cluster analysis using CONISS (Constrained Incremental Sum of Squares)
nested_coniss_IMP <- metals_long_IMP %>%
  nested_data(depth, metals, concentration) %>%
  nested_chclust_coniss()

# Plot the cluster analysis results
plot(nested_coniss_IMP)

# Plot a broken stick diagram
broken_stick_plot <- nested_coniss_IMP %>%
  select(broken_stick) %>%
  unnest(broken_stick) %>%
  tidyr::gather(type, value, broken_stick_dispersion, dispersion) %>%
  ggplot(aes(x = n_groups, y = value, col = type)) +
  geom_line() +
  geom_point()

# Display the broken stick plot
print(broken_stick_plot)
