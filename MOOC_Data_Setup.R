library(expss)

ESS9 <- as.data.frame(read_spss("ESS9.sav")) %>% 
          select(agea, gndr, cntry, eisced, trstprl, trstep, trstun, trstlgl, imsmetn, imdfetn,
                 imwbcnt, happy, health, frprtpl, grspfr, lrscale)

write_sav(ESS9, "ess_data.sav")
