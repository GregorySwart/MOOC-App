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
  
  median_data <- as.data.frame(t(data.frame(rep(10,23),rep(0,23))))
  
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
  
  rownames(median_data) <- c("Max","Min")
  
  median_data["EU_median",] <- rep(0,23)
  median_data["HU_median",] <- rep(0,23)
  median_data["Survey_Participant",] <- runif(23, 1,4) %>% round(0)
  
  variables <- c("agea", "gndr", "eisced", "ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
    "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
    "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")
  
  for (i in 1:23){
    median_data["EU_median",i] <- weighted.median(unlist(ess_data[variables[i]]), ess_data$dweight)
    median_data["HU_median",i] <- weighted.median(unlist(subset(ess_data, cntry == "HU")[variables[i]]), subset(ess_data, cntry == "HU")$dweight) %>% round(0)
  }
  
  median_data <- select(median_data, -c(agea, gndr, eisced))
  
  median_data$imsmetn <- 5 - median_data$imsmetn
  median_data$imdfetn <- 5 - median_data$imdfetn
  median_data$impcntr <- 5 - median_data$impcntr
  
  median_data$frprtpl[1:2] <- c(5,1)
  median_data$imsmetn[1:2] <- c(4,1)
  median_data$imdfetn[1:2] <- c(4,1)
  median_data$impcntr[1:2] <- c(4,1)
  
  removed <- c("Survey_Participant")
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  output$radar_all <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[which(rownames(median_data) %nin% removed),], 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed,"Min","Max")),]), bty = "o", fill=colors_in, cex = 0.9)
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
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
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
        column(12, align = "center",
          h1("Overview of all variables"),
          br(),
          hr()
        )
      ),
      fluidRow(
        column(1, align = "center",
          
        ),
        column(8, align = "center",
          plotOutput("radar_all", height = 800),
        ),
        column(2, align = "center",
          selectInput("cntry", "Country (not implemented)",
                      choices = list("Hungary" = "HU", "United Kingdom" = "UK"),
                      selected = "Hungary"),
          checkboxInput("EU_check", label = "Hide EU median"),
          checkboxInput("HU_check", label = "Hide HU median"),
          checkboxInput("own_check", label = "Hide own score", value = TRUE),
          actionButton("redraw_radar", "Redraw plot"),
          hr(),
          br(),
          p("On the radat plot to the left you can see the weighted median values displayed for all 
            variables measured. A high value in a variable means the participants agreed to a greater extent, 
            so a high trust score means the respondents are more trusting, and a high immigration score shows 
            greater tolerance of immigrants.", style = "align:justified"),
          br(),
          helpText("Note that most variables are scaled 0 to 10, except the four 
            following: IMSMETN, IMDFETN, IMPCNTR scale 1 to 4, and FRPRTPL scales 1 to 5. Scores for these 
            variables have been adjusted to fit on the 0 to 10 scale.")
        ),
        column(1)
      ),
      fluidRow(
        hr()
      )
    ),
    tabPanel("Other Data Visualisation")
  )
  
)

##############
# Launch App #
##############

shinyApp(ui = ui, server = server)