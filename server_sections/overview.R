output$radar_all <<- renderPlot({
  
  colors_border=c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
  colors_in=c(rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
  
  radarchart(df = median_data %>% subset(cntry %nin% removed | cntry == "AT") %>% select(-cntry), 
             cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
             pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
  
  legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == "AT")), bty = "o", fill=colors_in, cex = 0.9)
})

observeEvent(input$redraw_radar, {
  
  if (input$EU_check == T){
    removed <- removed %>% append("EU")
  }else if(input$EU_check == F){
    removed <- removed[removed != "EU"]
  }
  
  if (input$SU_check == T){
    removed <- removed %>% append("SU")
  }else if(input$EU_check == F){
    removed <- removed[removed != "SU"]
  }
  
  if (input$own_check == T){
    removed <- removed %>% append("PA")
  }else if(input$own_check == F){
    removed <- removed[removed != "PA"]
  }
  
  if (input$cntry_check == T){
    selected_cntry <- NA
  }else if(input$cntry_check == F){
    selected_cntry <- input$cntry_radar_all
  }
  
  for (i in stat_variables){
    median_data["PA",i] <- as.numeric(input[[i]])
  }
  
  output$radar_all <- renderPlot({
    
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data %>% subset(cntry %nin% removed | cntry == selected_cntry) %>% select(-cntry), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == selected_cntry)), bty = "o", fill=colors_in, cex = 0.9)
  })
})
