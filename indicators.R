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
                       "Immigration_Perception" = c("imbgeco", "imueclt", "imwbcnt"),
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
  indicators[countries[i],3] <- mean(median_data[countries[i],]$imbgeco, 
                                     median_data[countries[i],]$imueclt, 
                                     median_data[countries[i],]$imwbcnt)
  
  indicators[countries[i],4] <- 
    nrow(ess_data %>% subset(cntry == countries[i] & impcntr == 4)) / 
    nrow(ess_data %>% subset(cntry == countries[i])) * 10
  
  indicators[countries[i],5] <- 0
  
  indicators[countries[i],6] <- mean(median_data[countries[i],]$happy, 
                                     median_data[countries[i],]$stflife)
  
  indicators[countries[i],7] <- mean(median_data[countries[i],]$frprtpl, 
                                     median_data[countries[i],]$stfdem)
  
  indicators[countries[i],8] <- mean(median_data[countries[i],]$stfedu, 
                                     median_data[countries[i],]$stfeco, 
                                     median_data[countries[i],]$stfhlth)
}

# indicators["EU",1] <- mean(median_data["EU",]$ppltrst, 
#                            median_data["EU",]$pplfair, 
#                            median_data["EU",]$pplhlp)
# 
# indicators["EU",2] <- mean(median_data["EU",]$trstprl, 
#                            median_data["EU",]$trstep, 
#                            median_data["EU",]$trstlgl)
# 
# indicators["PA",1] <- mean(median_data["PA",]$ppltrst, 
#                            median_data["PA",]$pplfair, 
#                            median_data["PA",]$pplhlp)
# 
# indicators["PA",2] <- mean(median_data["PA",]$trstprl, 
#                            median_data["PA",]$trstep, 
#                            median_data["PA",]$trstlgl)
# 
# indicators["SU",1] <- mean(median_data["SU",]$ppltrst, 
#                            median_data["SU",]$pplfair, 
#                            median_data["SU",]$pplhlp)
# 
# indicators["SU",2] <- mean(median_data["SU",]$trstprl, 
#                            median_data["SU",]$trstep, 
#                            median_data["SU",]$trstlgl)


for (i in c("EU","PA","SU")){
  indicators[i,1] <- mean(median_data[i,]$ppltrst, 
                          median_data[i,]$pplfair, 
                          median_data[i,]$pplhlp)
  
  indicators[i,2] <- mean(median_data[i,]$trstprl, 
                          median_data[i,]$trstep, 
                          median_data[i,]$trstlgl)
  
  indicators[i,3] <- mean(median_data[i,]$imbgeco, 
                          median_data[i,]$imueclt, 
                          median_data[i,]$imwbcnt)
  
  indicators[i,4] <- 0
  
  indicators[i,5] <- 0
  
  indicators[i,6] <- mean(median_data[i,]$happy, 
                          median_data[i,]$stflife)
  
  indicators[i,7] <- mean(median_data[i,]$frprtpl, 
                          median_data[i,]$stfdem)
  
  indicators[i,3] <- mean(median_data[i,]$stfedu, 
                          median_data[i,]$stfeco, 
                          median_data[i,]$stfhlth)
}

indicators["SU", "Institutional_Satisfaction"] <- 5

indicators$cntry <- rownames(indicators)