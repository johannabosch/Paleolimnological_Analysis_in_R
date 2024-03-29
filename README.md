## **Paleoecological Analysis in R**

 

|Open the Gitbook to get started: [johannabosch/Paleoecological Analysis in R](https://johannabosch.github.io/Paleolimnological_Analysis_in_R/)|
|--|
|This is a tutorial-based review of the analysis from Bosch et al. 2024 (see below), hosted by Github pages. It includes a total of 5 chapters, each pertaining to a specific analysis conducted in R using the data found in this repository|

### Study overview

This is a public repo that can be used to learn how to conduct a paleoecological analysis in R. The project methods described here are formally reviewed and cited in the following paper. Please use this citation to cite this repository:

    Bosch J, Álvarez-Manzaneda I, Smol J, Michelutti N, Robertson GJ, Wilhelm SI, Montevecchi WA. 2024 Blending census and paleolimnological data allows for tracking the establishment and growth of a major gannet colony over several centuries. Proceedings of the Royal Society B [in review].

### Accessing the data

A list of each of the data files from the `/data` folder and their contents:

* `FileS1_ColonialSeabirdDatabase_WilhelmSI.csv` : Historical population reports collected for seabird species nesting in Cape St. Mary’s Ecological Reserve from 1883-2018. A blank cell indicates that population counts were not collected for that year.


* `FileS2_MonitoringData.csv` : Raw monitoring data from File S1 used to align population data to the proxies.


* `FileS3_Dating_CSM-IMP.csv` and `File S4_Dating_CSM-REF.csv` : Table containing 210Pb dating profiles over the depth of the impact core (CSM-IMP) and reference core (CSM-REF).


* `FileS5_ProxyData_CSM-IMP.csv` and `FileS6_ProxyData_CSM-REF.csv` : Table containing the isotope, metal(loid), chlorophyll a, and diatom count data for the depths of the sediment core collected from the reference pond.


* `File S7_Metalloids_CSM-IMP.csv` and `File S8_Metalloids_CSM-REF.csv` : Table of all metal(loid)s analyzed for the impact core and reference core.


* `FileS9_ZScores_CSM-IMP.csv` : Z-score data for the isotope, metal(loid)s, chlorophyll a, and diatom count for the depths of the sediment core collected from the impact pond.