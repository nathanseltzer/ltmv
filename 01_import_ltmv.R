## 01 ltmv import
## "less trust, moore verification"
## Nathan Seltzer

## Packages -------------------------------------------------------------------
library(dplyr)


## Data Import ----------------------------------------------------------------

# (1) Alabama Counties
  al_fips <- read.csv("./raw data/st01_al_cou.csv")
  # scrub " County" characters from each 'county_name'
    al_fips2 <- al_fips %>% 
                mutate(county_name = factor(gsub("\\s*\\w*$", "",  as.character(county_name))))

    
# (2) Alabama Congressional Districts
  al_districts <- read.csv("./raw data/al_districts.csv")

  
# (3) Alabama Intercensal Population Estimates 2017
  pop_est <- read.csv("./raw data/PEP_2017_PEPANNRES.csv")

  
# (4) Emerson Poll Data - most recently downloaded July 2nd, 2018
#       From: https://www.emerson.edu/communication-studies/emerson-college-polling-society/latest-polls
  file <- "./raw data/ECP_AL_11.13_0.xls"
    phone_raw <- readxl::read_excel(file, sheet =4) 
    web_raw <- readxl::read_excel(file, sheet =5)
    