median_data <- as.data.frame(t(data.frame(rep(10,23),rep(0,23))))

colnames(median_data) <- c("agea", "gndr", "eisced","ppltrst", "pplfair", "pplhlp","trstprl", "trstep", "trstlgl","imbgeco", "imueclt", "imwbcnt","impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", "stfdem","stfeco", "stfedu", "stfhlth","lrscale")
rownames(median_data) <- c("Max","Min")
median_data["EU",] <- rep(0,23)

for (i in countries){
  median_data[i,] <- rep(0,23)
}
median_data["PA",] <- runif(23, 0,10) %>% round(0)
median_data["PA","imsmetn"] <- runif(1,1,4) %>% round(0)
median_data["PA","imdfetn"] <- runif(1,1,4) %>% round(0)
median_data["PA","impcntr"] <- runif(1,1,4) %>% round(0)
median_data["PA","frprtpl"] <- runif(1,1,5) %>% round(0)

median_data["SU",] <- runif(23, 0,10) %>% round(0)
median_data["SU","imsmetn"] <- runif(1,1,4) %>% round(0)
median_data["SU","imdfetn"] <- runif(1,1,4) %>% round(0)
median_data["SU","impcntr"] <- runif(1,1,4) %>% round(0)
median_data["SU","frprtpl"] <- runif(1,1,5) %>% round(0)

variables <- c("agea", "gndr", "eisced", "ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
               "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
               "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")

stat_variables <- c("ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
               "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
               "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")

for (i in 1:23){
  median_data["EU",i] <- weighted.median(unlist(ess_data[variables[i]]), ess_data$dweight)
  for (j in countries){
    median_data[j,i] <- weighted.median(unlist(subset(ess_data, cntry == j)[variables[i]]), subset(ess_data, cntry == j)$dweight) %>% round(0)
  }
}

median_data <- select(median_data, -c(agea, gndr, eisced))

median_data$imsmetn <- 5 - median_data$imsmetn
median_data$imdfetn <- 5 - median_data$imdfetn
median_data$impcntr <- 5 - median_data$impcntr # Invert immigration rows

median_data$frprtpl[1:2] <- c(5,1)
median_data$imsmetn[1:2] <- c(4,1)
median_data$imdfetn[1:2] <- c(4,1)
median_data$impcntr[1:2] <- c(4,1) # Set immigration and frprtpl min/max

median_data$frprtpl <- median_data$frprtpl-1
median_data$imsmetn <- median_data$imsmetn-1
median_data$imdfetn <- median_data$imdfetn-1
median_data$impcntr <- median_data$impcntr-1

# for (i in stat_variables){
#   median_data["PA",i] <- input[i]
# }

median_data$cntry <- rownames(median_data)
