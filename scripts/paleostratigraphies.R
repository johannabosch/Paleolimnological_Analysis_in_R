##########################################
# PLOTTING MULTI-SITE PALEOSTRATIGRAPHIES

# Use this script to plot a stratigraphy of proxy values from one or more sediment coring site(s).
# I arranged my proxy data into geochemical and abundance plots

# Load necessary libraries
library(ggplot2)
library(tidyverse)
library(tidypaleo)
library(ggh4x)
library(patchwork)

theme_set(theme_paleo(8))

# Load the geochem data for your coring sites
pd_IMP2 <- read.csv("data/FileS5_ProxyData_CSM-IMP.csv")
pd_REF3 <- read.csv("data/FileS6_ProxyData_CSM-REF.csv")

# Calculate Cd/Al and Zn/Al ratios
pd_IMP2 <- pd_IMP2 %>%
  mutate(Cd_Al = Cd / Al,
         Zn_Al = Zn / Al)

pd_REF3 <- pd_REF3 %>%
  mutate(Cd_Al = Cd / Al,
         Zn_Al = Zn / Al)

# Reshape the geochem data to long format for the required parameters
pd_IMP2_long <- pd_IMP2 %>%
  pivot_longer(cols = c(chla, d15N, Cd_Al, Zn_Al, P),
               names_to = "param", 
               values_to = "value") %>%
  select(param, value, midpoint) %>%
  drop_na()

pd_REF3_long <- pd_REF3 %>%
  pivot_longer(cols = c(chla, d15N, Cd_Al, Zn_Al, P),
               names_to = "param", 
               values_to = "value") %>%
  select(param, value, midpoint) %>%
  drop_na()

# Plot the geochem stratigraphic diagram for the Impact Site
geo_strat_IMP2 <- ggplot(pd_IMP2_long, aes(x = value, y = midpoint)) +
  geom_lineh() +
  geom_point() +
  facet_geochem_gridh(vars(param)) +
  labs(x = NULL, y = "Midpoint Depth (cm)") +
  facetted_pos_scales(
    x = list(scale_x_continuous(limits = c(0, 0.00025)),  # Cd/Al
             scale_x_continuous(limits = c(0, 0.16)),   # chlA
             scale_x_continuous(limits = c(-2, 11)), # d15N
             scale_x_continuous(limits = c(0, 10000)), # P
             scale_x_continuous(limits = c(0, 0.025))), # Zn/Al
    scale_y_reverse(breaks = seq(0, 26, by = 1), limits = c(26, 0)))

geo_strat_IMP2

# Plot the geochem stratigraphic diagram for the Reference Site
geo_strat_REF3 <- ggplot(pd_REF3_long, aes(x = value, y = midpoint)) +
  geom_lineh() +
  geom_point() +
  facet_geochem_gridh(vars(param)) +
  labs(x = NULL, y = "Midpoint Depth (cm)") +
  facetted_pos_scales(
    x = list(scale_x_continuous(limits = c(0, 0.00025)),  # Cd/Al
             scale_x_continuous(limits = c(0, 0.16)),   # chlA
             scale_x_continuous(limits = c(-2, 11)), # d15N
             scale_x_continuous(limits = c(0, 10000)), # P
             scale_x_continuous(limits = c(0, 0.025))), # Zn/Al
    scale_y_reverse(breaks = seq(0, 26, by = 1), limits = c(26, 0))
  )

geo_strat_REF3

# Reshape the abundance data to long format
abundance_IMP2_long <- pd_IMP2 %>%
  pivot_longer(cols = c(S.cons, S.exi),
               names_to = "abundance_type", 
               values_to = "abundance") %>%
  select(abundance_type, abundance, midpoint) %>%
  drop_na()

abundance_REF3_long <- pd_REF3 %>%
  pivot_longer(cols = c(S.cons, S.exi),
               names_to = "abundance_type", 
               values_to = "abundance") %>%
  select(abundance_type, abundance, midpoint) %>%
  drop_na()

# Plot the abundance stratigraphic diagram for the Impact Site
abundance_strat_IMP2 <- ggplot(abundance_IMP2_long, aes(x = abundance, y = midpoint)) +
  geom_areah() +
  geom_col_segsh() +
  facet_abundanceh(vars(abundance_type)) + 
  labs(x = NULL, y = "Midpoint Depth (cm)") +
  facetted_pos_scales(
    x = list(scale_x_abundance(limits = c(0, 100), breaks = seq(0,100, by =20)),
             scale_x_abundance(limits = c(0, 100), breaks = seq(0,100, by =20))),
    scale_y_reverse(limits = c(17, 0))
  )

abundance_strat_IMP2

# Plot the abundance stratigraphic diagram for the Reference Site
abundance_strat_REF3 <- ggplot(abundance_REF3_long, aes(x = abundance, y = midpoint)) +
  geom_areah() +
  geom_col_segsh() +
  facet_abundanceh(vars(abundance_type)) + 
  labs(x = NULL, y = "Midpoint Depth (cm)") +
  facetted_pos_scales(
    x = list(scale_x_abundance(limits = c(0, 100), breaks = seq(0,100, by =20)),
             scale_x_abundance(limits = c(0, 100), breaks = seq(0,100, by =20))),
    scale_y_reverse(limits = c(17, 0))
  )

abundance_strat_REF3

# Arrange multiple stratigraphies (Impact Site)
strat_final_IMP2 <- wrap_plots(geo_strat_IMP2 + 
                                 theme(strip.background = element_blank(), strip.text.y = element_blank()),
                               abundance_strat_IMP2 +
                                 theme(axis.text.y.left = element_blank(), axis.ticks.y.left = element_blank()) +
                                 labs(y = NULL), nrow = 1, widths = c(3, 1))

strat_final_IMP2

# Arrange multiple stratigraphies (Reference Site)
strat_final_REF3 <- wrap_plots(geo_strat_REF3 + 
                                 theme(strip.background = element_blank(), strip.text.y = element_blank()),
                               abundance_strat_REF3 +
                                 theme(axis.text.y.left = element_blank(), axis.ticks.y.left = element_blank()) +
                                 labs(y = NULL), nrow = 1, widths = c(3, 1))

strat_final_REF3


# Combine the plots with more space for the x-axis
final_strat <- wrap_plots(strat_final_IMP2, strat_final_REF3, nrow = 2, ncol = 1) +
  plot_layout(heights = c(1, 1)) +  # Ensure equal space for both plots
  theme(plot.margin = margin(t = 10, r = 10, b = 50, l = 10))  # Add space at the bottom for x-axis labels

# Save the plot with increased width
ggsave("figs/paleostratigraphies.png", plot = final_strat, width = 12, height = 8)

