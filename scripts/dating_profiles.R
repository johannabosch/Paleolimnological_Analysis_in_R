###################################
# PLOT CORE 210-PB ACTIVITY AND AGE

# Use this script to make plots of:
  # a sediment core's lead-210 activity over depth
  # a sediment core's depth related to year (based on a CRS dating model)

# I used data from the following files found in the Github repo
# (https://github.com/johannabosch/Paleo_Analysis_Using_R)
    
    # FileS3_Dating_CSM-IMP.csv
    # FileS4_Dating_CSM-REF.csv.

#Load the following packages
library(ggplot2)
library(dplyr)
library(viridis)
library(ggpubr)

#Load your data for impact and reference sites into R

setwd("Paleolimnological_Analysis_in_R")

dp_IMP2 <- read.csv("data/FileS3_Dating_CSM-IMP.csv") 
dp_REF3 <- read.csv("data/FileS4_Dating_CSM-REF.csv") 

# Define columns for core depth/year, activity, sedimentation rate + error

depth_IMP2 <- dp_IMP2$depth
year_IMP <- dp_IMP2$Year..CRS.
act_IMP2 <- dp_IMP2$Total.210Pb_activity..Bq.kg.
sed_IMP2 <- dp_IMP2$Sed..Rate..cm.y.
error_IMP <- dp_IMP2$Error.Sed..Rate..cm.y.

depth_REF3 <- dp_REF3$depth
year_REF <- dp_REF3$Year..CRS.
act_REF3 <- dp_REF3$Total.210Pb_activity..Bq.kg.
sed_REF3 <- dp_REF3$Sed..Rate..cm.y.
error_REF <- dp_REF3$Error.Sed..Rate..cm.y.

# Plot the activity 
activity <- ggplot() +
  
  geom_point(data = dp_IMP2, (aes(x= depth_IMP2, y=act_IMP2)), shape=22, fill="paleturquoise4", size=3, color = "paleturquoise4", alpha=0.5) +
  geom_line(data = dp_IMP2, (aes(x = depth_IMP2, y=act_IMP2)), color="paleturquoise4") +
  
  geom_point(data = dp_REF3, (aes(x = depth_REF3, y=act_REF3)), size =3, color="palegreen3") +
  geom_line(data = dp_REF3, (aes(x = depth_REF3, y=act_REF3)), color="palegreen3") +
  
  labs(x="Midpoint depth (cm)", y="Pb-210 Activity (Bq/kg)") +
  
  scale_x_continuous(breaks=seq(0,19, by= 1), limits = c(0,19)) +
  
  theme_classic()+
  
  theme(text = element_text(size = 12), panel.grid.major.x=element_line(), axis.text.y = element_text(size=12), axis.title.y = element_text(margin = margin(t=0, r= 20, b=0, l=0)))

activity


# Fix the plot margins
par(mar = c(10, 10,10,10))


# Plot year based on core depth

year <- ggplot() +
  
  geom_point(data = dp_IMP2, (aes(x = year_IMP, y= depth_IMP2)), na.rm=TRUE, shape=22, fill="paleturquoise4", size=3, color = "paleturquoise4", alpha=0.5) +
  geom_line(data = dp_IMP2, (aes(x = year_IMP, y= depth_IMP2)), na.rm=TRUE, color = "paleturquoise4") +
  stat_smooth(dp_IMP2, mapping=aes(year_IMP, depth_IMP2), method="lm", color = "paleturquoise4", fill = "paleturquoise4", alpha = 0.3) +
  geom_errorbar(aes(x=year_IMP, xmin=year_IMP-error_IMP, xmax=year_IMP+error_IMP, y=depth_IMP2, ymax=NULL, ymin=NULL), width=.2) +
  
  geom_point(data = dp_REF3, (aes(x = year_REF, y= depth_REF3)), na.rm=TRUE, shape=22, fill="palegreen3", size=3, color = "paleturquoise4", alpha=0.5) +
  geom_line(data = dp_REF3, (aes(x = year_REF, y= depth_REF3)), na.rm=TRUE, color = "palegreen3") +
  stat_smooth(dp_REF3, mapping=aes(year_REF, depth_REF3), method="lm", color = "palegreen3", fill = "palegreen3", alpha = 0.3) +
  geom_errorbar(aes(x=year_REF, xmin=year_REF-error_REF, xmax=year_REF+error_REF, y=depth_REF3, ymax=NULL, ymin=NULL), width=.2) +
  
  labs(x = "Year (CRS model)", y = "Midpoint depth (cm)") +
  scale_x_continuous(breaks=seq(1800,2023, by= 10)) +
  scale_y_reverse(limits=c(10,0), breaks=seq(10,0, by=-0.5)) +
  theme_classic() +
  theme(panel.grid.major.x=element_line(), text = element_text(size = 12), axis.text.y = element_text(size=10), axis.text.x = element_text(size=12))

year

