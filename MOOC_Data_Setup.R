library(expss)
library(dplyr)
library(haven)

ESS9 <- as.data.frame(read_spss("ESS9.sav")) %>% 
          select(agea, gndr, cntry, eisced, dweight,
                 ppltrst, pplfair, pplhlp, # Individual Trust
                 trstprl, trstep, trstlgl, # Institutional Trust
                 imbgeco, imueclt, imwbcnt, # Immigration Perception
                 impcntr, # Immigration Rejection (SPECIAL)
                 imsmetn, imdfetn, # Immigration Racial (OPTIONAL)
                 happy, stflife, # Subjective Satisfaction
                 frprtpl, stfdem, # Political Satisfaction
                 stfeco, stfedu, stfhlth, # Institutional Satisfaction
                 lrscale # Left-Right Scale
                 )

write_sav(ESS9, "ess_data.sav")
