# import libraries
library(shiny)
library(fmsb)
library(expss)
library(dplyr)
library(gridExtra)
library(rsconnect)
library(spatstat)
library(ggplot2)


##########
# SERVER #
##########

server <- shinyServer(function(input, output, session) {
  
  #########################
  # Data load and cleanup #
  #########################
  
  #Import data
  `%nin%` <- Negate(`%in%`)
  
  ess_data <- as.data.frame(read_spss("ess_data.sav"))
  
  median_data <- as.data.frame(t(data.frame(rep(0,23),rep(10,23))))
  
  colnames(median_data) <- c("agea", "gndr", "eisced",
    "ppltrst", "pplfair", "pplhlp",
    "trstprl", "trstep", "trstlgl",
    "imbgeco", "imueclt", "imwbcnt",
    "impcntr",
    "imsmetn", "imdfetn",
    "happy", "stflife",
    "frprtpl", "stfdem",
    "stfeco", "stfedu", "stfhlth",
    "lrscale")
  
  rownames(median_data) <- c("Min","Max")
  
  median_data["EU_median",] <- rep(0,23)
  median_data["HU_median",] <- rep(0,23)
  median_data["Survey_Participant",] <- runif(23, 2,8) %>% round(0)
  
  variables <- c("agea", "gndr", "eisced", "ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
    "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
    "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")
  
  for (i in 1:23){
    median_data["EU_median",i] <- weighted.median(unlist(ess_data[variables[i]]), ess_data$dweight)
    median_data["HU_median",i] <- weighted.median(unlist(subset(ess_data, cntry == "HU")[variables[i]]), subset(ess_data, cntry == "HU")$dweight) %>% round(0)
  }
  
  median_data <- select(median_data, -c(agea, gndr, eisced))
  
  removed <- c()
  
  # {dummy_data <- data.frame(list("ppltrst" = round(runif(5, 0, 10),0),
  #                               "pplfair" = round(runif(5, 0, 10),0),
  #                               "pplhlp" = round(runif(5, 0, 10),0),
  #                               "trstprl" = round(runif(5, 0, 10),0),
  #                               "trstep" = round(runif(5, 0, 10),0),
  #                               "trstlgl" = round(runif(5, 0, 10),0),
  #                               "imbgeco" = round(runif(5, 0, 10),0),
  #                               "imueclt" = round(runif(5, 0, 10),0),
  #                               "imwbcnt" = round(runif(5, 0, 10),0),
  #                               "impcntr" = round(runif(5, 0, 10),0),
  #                               "imsmetn" = round(runif(5, 0, 10),0),
  #                               "imdfetn" = round(runif(5, 0, 10),0),
  #                               "happy" = round(runif(5, 0, 10),0),
  #                               "stflife" = round(runif(5, 0, 10),0),
  #                               "frprtpl" = round(runif(5, 0, 10),0),
  #                               "stfdem" = round(runif(5, 0, 10),0),
  #                               "stfeco" = round(runif(5, 0, 10),0),
  #                               "stfedu" = round(runif(5, 0, 10),0),
  #                               "stfhlth" = round(runif(5, 0, 10),0),
  #                               "lrscale" = round(runif(5, 0, 10),0)),
  #                          row.names = c("Min", "Max", "EU_median", "Hungary_median", "Survey_Participant"))
  # dummy_data[1,] <- 0
  # dummy_data[2,] <- 10}
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  output$radar_all <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[which(rownames(median_data) %nin% removed),], 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 4, caxislabels = seq(0,10,1), cglwd=1, seg = 10,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[c(3,4,5),]), bty = "o", fill=colors_in, cex = 0.9)
  })

  #observeEvent({input$redraw_radar})
  


  
  observeEvent(input$redraw_radar, {
    
    if (input$EU_check == T){
      removed <- removed %>% append("EU_median")
    }else if(input$EU_check == F){
      removed <- removed[removed != "EU_median"]
    }
    
    if (input$HU_check == T){
      removed <- removed %>% append("HU_median")
    }else if(input$EU_check == F){
      removed <- removed[removed != "HU_median"]
    }
    
    
    if (input$own_check == T){
      removed <- removed %>% append("Survey_Participant")
    }else if(input$own_check == F){
      removed <- removed[removed != "Survey_Participant"]
    }
    
    output$radar_all <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
      
      radarchart(df = median_data[which(rownames(median_data) %nin% removed),], 
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 4, caxislabels = seq(0,10,1), cglwd=1, seg = 10,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
      
      legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed,"Min","Max")),]), bty = "o", fill=colors_in, cex = 0.9)
    })
  })

})

##################
# User Interface #
##################

ui <- shinyUI(
  
  navbarPage("MOOC App", collapsible = TRUE,
    theme = shinythemes::shinytheme("sandstone"),
    tabPanel("Radar charts",
      fluidRow(
        column(2, align = "center",
          checkboxInput("EU_check", label = "Hide EU median"),
          checkboxInput("HU_check", label = "Hide HU median"),
          checkboxInput("own_check", label = "Hide own score"),
          actionButton("redraw_radar", "Redraw plot")
        ),
        column(8, align = "center",
          h2("One radar chart"),
          plotOutput("radar_all", height = 800),
          hr()
        )
      )
    ),
    tabPanel("Other Data Visualisation")
  )
  
)

##############
# Launch App #
##############

shinyApp(ui = ui, server = server)