# Prepare Means

mean_data <- as.data.frame(t(data.frame(rep(10,23),rep(0,23))))

colnames(mean_data) <- c("agea", "gndr", "eisced","ppltrst", "pplfair", "pplhlp","trstprl", "trstep", "trstlgl","imbgeco", "imueclt", "imwbcnt","impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", "stfdem","stfeco", "stfedu", "stfhlth","lrscale")
rownames(mean_data) <- c("Max","Min")
mean_data["EU",] <- rep(0,23)
for (i in countries){
  mean_data[i,] <- rep(0,23)
}

clean_data <- ess_data %>% na.omit()
for (i in 1:23){
  mean_data["EU",i] <- weighted.mean(unlist(clean_data[variables[i]]), clean_data$dweight)
  for (j in countries){
    mean_data[j,i] <- weighted.mean(unlist(subset(clean_data, cntry == j)[variables[i]]), subset(clean_data, cntry == j)$dweight)# %>% round(0)
  }
}

mean_data <- select(mean_data, -c(agea, gndr, eisced))

mean_data$imsmetn <- 5 - mean_data$imsmetn
mean_data$imdfetn <- 5 - mean_data$imdfetn
mean_data$impcntr <- 5 - mean_data$impcntr # Invert immigration rows

mean_data$frprtpl[1:2] <- c(5,1)
mean_data$imsmetn[1:2] <- c(4,1)
mean_data$imdfetn[1:2] <- c(4,1)
mean_data$impcntr[1:2] <- c(4,1) # Set immigration and frprtpl min/max

mean_data$frprtpl <- mean_data$frprtpl-1
mean_data$imsmetn <- mean_data$imsmetn-1
mean_data$imdfetn <- mean_data$imdfetn-1
mean_data$impcntr <- mean_data$impcntr-1

mean_data["PA",] <- rep(0,21)

mean_data$cntry <- rownames(mean_data)

dummy <- mean_data[-c(1,2),]
mean_data_long <- gather(dummy, key = var, value = value, - cntry)
mean_data_long$cntry <- as.factor(mean_data_long$cntry)
mean_data_long$var <- as.factor(mean_data_long$var)
mean_data_long$id <- rep(1:20, each = 21)

colnames(mean_data) <- c("Trust in\n people",
                         "Fairness of\n people",
                         "Helpfulness\n of people",
                         "Trust in\n parliament",
                         "Trust in\n legal system",
                         "Trust in\n EP",
                         "Immigration's\n effect on economy",
                         "Immigration's effect\n on culture",
                         "Immigration's effect\n on country as a whole",
                         "Attitude towards\n immigrants from\n poorer countries\n outside of Europe",
                         "Attitude towards\n immigrants of\n the same race",
                         "Attitude towards\n immigrants of\n a different race",
                         "General\n happiness",
                         "Satisfaction with\n life in general",
                         "Political fairness\n in own country",
                         "Satisfaction\n with democracy",
                         "Satisfaction\n with economy",
                         "Satisfaction\n with education",
                         "Satisfaction\n with healthcare",
                         "Placement on\n left-right scale",
                         "cntry"
                         )

rownames(mean_data)[3] <- "All countries"
rownames(mean_data)[4:22] <- c("Austria", "Belgium", "Bulgaria", "Switzerland", "Cyprus", "Czechia", "Germany", "Estonia",
                               "Finland", "France", "United Kingdom", "Hungary", "Ireland", "Italy",
                               "Netherlands", "Norway", "Poland", "Serbia", "Slovenia")
rownames(mean_data)[23] <- "Own response"
mean_data["Own response", "cntry"] <- "Own response"
rm("i","j")
