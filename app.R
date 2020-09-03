# import libraries
library(shiny)
library(fmsb)
library(expss)
library(dplyr)
library(gridExtra)
library(rsconnect)

##########
# SERVER #
##########

server <- shinyServer(function(input, output) { #generic line initiating the SERVER 
  
  #########################
  # Data load and cleanup #
  #########################
  
  #Import data
  ess_data <- as.data.frame(read_spss("ess_data.sav"))
  
  dummy_data <- data.frame(list("Trust1" = round(runif(5, 0, 10),0),
                                "Trust2" = round(runif(5, 0, 10),0),
                                "Trust3" = round(runif(5, 0, 10),0),
                                "Trust4" = round(runif(5, 0, 10),0),
                                "Immigration1" = round(runif(5, 0, 10),0),
                                "Immigration2" = round(runif(5, 0, 10),0),
                                "Immigration3" = round(runif(5, 0, 10),0),
                                "Immigration4" = round(runif(5, 0, 10),0),
                                "Satisfaction1" = round(runif(5, 0, 10),0),
                                "Satisfaction2" = round(runif(5, 0, 10),0),
                                "Satisfaction3" = round(runif(5, 0, 10),0),
                                "Satisfaction4" = round(runif(5, 0, 10),0)),
                           row.names = c("Min", "Max", "EU_median", "Hungary_median", "Survey_Participant"))
  dummy_data[1,] <- 0
  dummy_data[2,] <- 10
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  # define any reactive elements of the app
  
  output$radar_all <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = dummy_data, 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 4, caxislabels = seq(0,10,1), cglwd=1, seg = 10,
               
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
               )
    legend("topright", legend = rownames(dummy_data[c(3,4,5),]), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$radar1 <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = dummy_data %>% select(Trust1,Trust2,Trust3,Trust4), 
                     cglcol="grey", cglty=1, axislabcol="grey20", caxislabels=seq(0,10,2), cglwd=1,
                     pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
                     seg = 5, axistype = 4)
    #legend("topright", legend = rownames(dummy_data[c(3,4,5),]), bty = "o", fill=colors_in, cex = 1)
  })
  
  output$radar2 <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = dummy_data %>% select(Immigration1,Immigration2,Immigration3,Immigration4), 
               cglcol="grey", cglty=1, axislabcol="grey20", caxislabels=seq(0,10,2), cglwd=1,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
               seg = 5, axistype = 4)
    #legend("topright", legend = rownames(dummy_data[c(3,4,5),]), bty = "o", fill=colors_in, cex = 1)
  })

  output$radar3 <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = dummy_data %>% select(Satisfaction1, Satisfaction2,Satisfaction3,Satisfaction4),
               cglcol="grey", cglty=1, axislabcol="grey20", caxislabels=seq(0,10,2), cglwd=1,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
               seg = 5, axistype = 4)
    
    legend("topright", legend = rownames(dummy_data[c(3,4,5),]), bty = "o", fill=colors_in, cex = 0.9)
  })

}) #Close the server definition






##################
# User Interface #
##################

ui <- shinyUI( #generic line initiating the UI
  
  navbarPage("MOOC App", collapsible = TRUE,
    theme = shinythemes::shinytheme("sandstone"),
    tabPanel("Radar charts",
      fluidRow(
        column(8, offset = 2, align = "center",
          h2("One radar chart"),
          plotOutput("radar_all", height =800),
          hr()
        )
      ),
      
      fluidRow(
        h2("Separate charts", align = "center"),
        column(4, align = "center",
          plotOutput("radar1")
        ),
        column(4, align = "center",
               plotOutput("radar2")
        ),
        column(4, align = "center",
               plotOutput("radar3")
        )
      )
    ),
    tabPanel("Other Data Visualisation")
  )
  
)  #Close the UI definition

##############
# Launch App #
##############

#generic line that launches the app
shinyApp(ui = ui, server = server)