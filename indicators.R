indicators <- data.frame(list("Individual_Trust" = c(0,0), 
                              "Institutional_Trust" = c(0,0),
                              "Immigration_perception" = c(0,0),
                              "Immigration_rejection" = c(0,0),
                              "Immigration_racial" = c(0,0),
                              "Subjective_Satisfaction" = c(0,0),
                              "Political_Satisfaction" = c(0,0),
                              "Institutional_Satisfaction" = c(0,0)),
                         row.names = c("EU", "PA"))

indicator_list <- list("Individual_Trust" = c("ppltrst", "pplfair", "pplhlp"),
                       "Institutional_Trust" = c("trstprl", "trstep", "trstlgl"),
                       "Immigration_Perception" = c("imbgeco", "imeuclt", "imwbcnt"),
                       "Immigration_Rejection" = c("impcntr"),
                       "Immigration_Racial" = c("imsmetn", "imdfetn"),
                       "Subjective_Satisfaction" = c("happy", "stflife"),
                       "Political_Satisfaction" = c("frprtpl", "stfdem"),
                       "Institutional_Satisfaction" = c("stfedu", "stfeco", "stfhlth"))

for (i in 1:length(countries)){
  indicators[countries[i],1] <- mean(median_data[countries[i],]$ppltrst, 
                                     median_data[countries[i],]$pplfair, 
                                     median_data[countries[i],]$pplhlp)
  indicators[countries[i],2] <- mean(median_data[countries[i],]$trstprl, 
                                     median_data[countries[i],]$trstep, 
                                     median_data[countries[i],]$trstlgl)
}

indicators["EU",1] <- mean(median_data["EU",]$ppltrst, 
                           median_data["EU",]$pplfair, 
                           median_data["EU",]$pplhlp)

indicators["EU",2] <- mean(median_data["EU",]$trstprl, 
                           median_data["EU",]$trstep, 
                           median_data["EU",]$trstlgl)

indicators["PA",1] <- mean(median_data["PA",]$ppltrst, 
                           median_data["PA",]$pplfair, 
                           median_data["PA",]$pplhlp)

indicators["PA",2] <- mean(median_data["PA",]$trstprl, 
                           median_data["PA",]$trstep, 
                           median_data["PA",]$trstlgl)

indicators$cntry <- rownames(indicators)