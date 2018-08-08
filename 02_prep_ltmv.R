## 02 ltmv prep
## "less trust, moore verification"
## Nathan Seltzer


## Packages -------------------------------------------------------------------
library(dplyr)
library(reshape2)


## Functions ------------------------------------------------------------------
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


## Data Prep ------------------------------------------------------------------

## There are four steps for the data prep. The first three consist of creating 
##  county-district data.frames for:
##    (1) the actual/correct county-district matches
##    (2) the phone sample
##    (3) the web sample
## The final step (4) appends all of the data.frames together 


## The data.frames are constructed by first creating 2-way frequency tables of respondents
##  by county fips codes and congressional districts. The frequency tables are then
##  reshaped into long-format in which each observation is a unique county-district
##  pair -- including county-district pairs that should not have any respondents in them.
##  Next, county names and other relevant info are merged into the data.frames. A
##  binary variable for "any_respondent" is created from the "number_of_respondents"
##  variable. The data.frames are finally appended in a combined data.frame.



### (1) ACTUAL CORRECT COUNTY-DISTRICT MATCHES --------------------------------

  actual_table <- al_districts %>%
                  mutate(`1` = X1, 
                         `2` = X2, 
                         `3` = X3, 
                         `4` = X4, 
                         `5` = X5, 
                         `6` = X6, 
                         `7` = X7) %>%
                  select(county, `1`, `2`, `3`, `4`, `5`, `6`, `7`)
  actual_table[is.na(actual_table)] <- 0   

# Actual Data - county obs should be clustered in certain congressional districts
  head(actual_table)
  
  actual_df <- melt(actual_table, id.vars = "county",
                   variable.name = "district",
                   value.name = "number_of_respondents")  %>%
                mutate(any_respondent = factor(ifelse(number_of_respondents >= 1, 1, 0))) %>%
                left_join(al_fips2, by=c("county")) %>%
                mutate(`Actual Match` = ifelse(any_respondent == 1, 1, NA))
  actual_df$sample <- " Actual County-District \n Matches"
  
  actual_slim <- select(actual_df, county, `Actual Match`)  
  

### (2) PHONE SAMPLE ----------------------------------------------------------
  phone_table <- as.data.frame.matrix(table(phone_raw$county, phone_raw$usc)) %>%
                  mutate(county = as.numeric(rownames(.))) %>%
                  left_join(al_fips, by = "county")%>%
                  select( -state, -statfip, -county_name) #don't need these at the moment
  phone_table[is.na(phone_table)] <- 0
  phone_table <- left_join(al_fips2, phone_table, by = "county") %>%
                  select(-state, -statfip, -county_name)
  phone_table[is.na(phone_table)] <- 0


  # Phone Data - notice how obs are clustered in congressional districts
  head(phone_table)
  
  phone_df <- melt(phone_table, id.vars = "county", 
                  variable.name = "district",
                  value.name = "number_of_respondents")  %>%
              mutate(any_respondents = factor(ifelse(number_of_respondents >= 1, 1, 0))) %>%
              left_join(al_fips2, by=c("county"))  %>%
              mutate(`Any Respondents?` = ifelse(any_respondents == 1, "Yes", "No")) 
  phone_df$sample <- "IVR Sample\n(N=628)"
  

### (3) WEB SAMPLE ------------------------------------------------------------
  #pre-processing
  web_clean <- data.frame( county=web_raw[27], distric=web_raw[28])
  names(web_clean) # check that these are correct
  names(web_clean)[1] <- "county"
  names(web_clean)[2] <- "district"
  
  web_table <- as.data.frame.matrix(table(web_clean$county, web_clean$district)) %>%
                mutate(county = as.numeric(rownames(.)))
  web_table <- left_join(al_fips2, web_table, by = "county") %>%
                select(-state, -statfip, -county_name)
  web_table[is.na(web_table)] <- 0
  
  # Web Data - notice how obs *are not* clustered in congressional districts
  head(web_table)
  
  web_df <- melt(web_table, id.vars = "county", 
                variable.name = "district",
                value.name = "number_of_respondents")  %>%
            mutate(any_respondents = factor(ifelse(number_of_respondents >= 1, 1, 0))) %>%
            left_join(al_fips2, by=c("county"))  %>%
            mutate(`Any Respondents?` = ifelse(any_respondents == 1, "Yes", "No"))
  web_df$sample <- "Internet Sample\n(N=324)"
  


## (4) Assemble full dataset --------------------------------------------------

comb <-  bind_rows(phone_df, web_df) %>%
          mutate(`Any Respondents?` = ifelse(any_respondents == 1, "Yes", "No"),
                 sample = factor(sample, levels = c("IVR Sample\n(N=628)",
                                                    "Internet Sample\n(N=324)")))
