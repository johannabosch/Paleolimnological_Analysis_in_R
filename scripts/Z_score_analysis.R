#######################################################
# Plotting proxy data (z-scored) with population counts

#Getting started

library(ggplot2)
library(dplyr)
library(viridis)
library(ggpubr)
library(tidyverse)

setwd("Paleolimnological_Analysis_in_R/")

# Loading data

zscores <- read.csv("data/FileS9_ZScores_CSM-IMP.csv")

popn <- read.csv("data/FileS2_MonitoringData.csv")

# Plot proxy data
z_plot <- ggplot() +
  geom_smooth(zscores, mapping=aes(x=year, y=mean), method="lm", na.rm=TRUE, formula = y ~ poly(x, 2), color="lightgrey", fill="lightgrey", linetype = 0) +
  scale_x_continuous(breaks=seq(1800,2023, by=10), limits = c(1800,2025), position="top") +
  
  #plot mean line (move this to the last line if you want the mean line to lay overtop your proxy data)
  geom_line(data=zscores[!is.na(zscores$mean),], mapping=aes(x=year, y=mean), color="black", linewidth=1,) +
  
  #plot chlorophyll data
  geom_line(data=zscores[!is.na(zscores$z_chla),], mapping=aes(x=year, y=z_chla), color="green") +
  geom_point(data=zscores, mapping=aes(x=year, y=z_chla), color="green", shape=16, size=2) +
  
  #plot d15N data
  geom_line(data=zscores[!is.na(zscores$z_d15N),], mapping=aes(x=year, y=z_d15N), color="blue3") +
  geom_point(data=zscores, mapping=aes(x=year, y=z_d15N), color="blue3", shape=4, size=2) +
  
  #plot Phosphorus data
  geom_line(data=zscores[!is.na(zscores$z_P),], mapping=aes(x=year, y=z_P), color="orange") +
  geom_point(data=zscores, mapping=aes(x=year, y=z_P), color="orange", shape=15, size=2) +
  
  #plot Zinc data
  geom_line(data=zscores[!is.na(zscores$z_Zn),], mapping=aes(x=year, y=z_Zn), color="firebrick1") +
  geom_point(data=zscores, mapping=aes(x=year, y=z_Zn), color="firebrick1", shape=25, size=2) +
  
  #plot Cadmium data
  geom_line(data=zscores[!is.na(zscores$Z_Cd),], mapping=aes(x=year, y=Z_Cd), color="red4") +
  geom_point(data=zscores, mapping=aes(x=year, y=Z_Cd), color="red4", shape=17, size=2) +
  
  #plot diatom data
  geom_line(data=zscores[!is.na(zscores$z_S.cons),], mapping=aes(x=year, y=z_S.cons), color="mediumaquamarine") +
  geom_point(data=zscores, mapping=aes(x=year, y=z_S.cons), color="mediumaquamarine", shape=20, size=2) +
  
  #set a theme
  theme_classic()+
  theme(panel.grid.major.x=element_line(),
        text = element_text(size = 12),
        axis.text.x.top= element_text(vjust=0.5, angle=90, color = "black"),
        axis.text.y = element_text(color = "black"),
        axis.title.x = element_blank())+
  
  #set axis labels
  xlab(NULL)+
  ylab("z-score")

# Define some vals for pop counts
NOGA <- popn$Northern.gannet
COMU <- popn$Common.murre
BLKI <- popn$Black.legged.kittiwake
year <- popn$Year

# plot population counts

popn_plot <- ggplot(popn, (aes(x=year))) +
  
  geom_point(aes(y=BLKI), width=1, color="hotpink3", size=2) +

  geom_point(aes(y=NOGA), width=1, color="slateblue4", size=2) +

  geom_point(aes(y=COMU), width=1, color="olivedrab4", size=2) +

  scale_x_continuous(breaks=seq(1800,2023, by=10), limits = c(1800,2025), position="bottom") +
  scale_y_continuous(breaks=seq(0,16000, by=4000)) +
  
  ylab("nesting pairs")+
  
  theme_classic()+
  theme(panel.grid.major.x=element_line(),
        text = element_text(size = 12, color = "black"),
        axis.text.x = element_text(margin = margin(t=1), color = "black"),
        axis.text.y = element_text(margin = margin(t=1), color = "black"),
        axis.title.x = element_blank(),
        axis.text.x.bottom = element_text(vjust=0.5, angle=90))


# Plot pop counts and proxy data together
ggarrange(z_plot, popn_plot,
          ncol = 1, nrow = 2,
          heights=c(20,15),
          align="hv")

