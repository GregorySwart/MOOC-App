# Prepare Medians

# median_data <- as.data.frame(t(data.frame(rep(10,23),rep(0,23))))
# 
# colnames(median_data) <- c("agea", "gndr", "eisced","ppltrst", "pplfair", "pplhlp","trstprl", "trstep", "trstlgl","imbgeco", "imueclt", "imwbcnt","impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", "stfdem","stfeco", "stfedu", "stfhlth","lrscale")
# rownames(median_data) <- c("Max","Min")
# median_data["EU",] <- rep(0,23)
# 
# for (i in countries){
#   median_data[i,] <- rep(0,23)
# }
# 
# variables <- c("agea", "gndr", "eisced", "ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
#                "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
#                "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")
# 
# stat_variables <- c("ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
#                "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
#                "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")
# 
# trust_variables <- c("ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", "trstlgl")
# 
# immigration_variables <- c("imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn")
# 
# satisfaction_variables <- c("happy", "stflife","frprtpl", "stfdem","stfeco", "stfedu", "stfhlth")
# 
# for (i in 1:23){
#   median_data["EU",i] <- weighted.median(unlist(ess_data[variables[i]]), ess_data$dweight)
#   for (j in countries){
#     median_data[j,i] <- weighted.median(unlist(subset(ess_data, cntry == j)[variables[i]]), subset(ess_data, cntry == j)$dweight) %>% round(0)
#   }
# }
# 
# median_data <- select(median_data, -c(agea, gndr, eisced))
# 
# median_data$imsmetn <- 5 - median_data$imsmetn
# median_data$imdfetn <- 5 - median_data$imdfetn
# median_data$impcntr <- 5 - median_data$impcntr # Invert immigration rows
# 
# median_data$frprtpl[1:2] <- c(5,1)
# median_data$imsmetn[1:2] <- c(4,1)
# median_data$imdfetn[1:2] <- c(4,1)
# median_data$impcntr[1:2] <- c(4,1) # Set immigration and frprtpl min/max
# 
# median_data$frprtpl <- median_data$frprtpl-1
# median_data$imsmetn <- median_data$imsmetn-1
# median_data$imdfetn <- median_data$imdfetn-1
# median_data$impcntr <- median_data$impcntr-1
# 
# median_data["PA",] <- rep(0,23)
# median_data["SU",] <- rep(0,23)
# 
# median_data$cntry <- rownames(median_data)



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
mean_data["SU",] <- rep(0,21)

mean_data$cntry <- rownames(mean_data)

dummy <- mean_data[-c(1,2),]
mean_data_long <- gather(dummy, key = var, value = value, - cntry)
mean_data_long$cntry <- as.factor(mean_data_long$cntry)
mean_data_long$var <- as.factor(mean_data_long$var)
mean_data_long$id <- rep(1:20, each = 22)

rm("i","j")
