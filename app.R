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
  {`%nin%` <- Negate(`%in%`)
  
  ess_data <- as.data.frame(read_spss("ess_data.sav"))
  
  countries <- ess_data$cntry %>% unique() %>% values2labels() %>% unclass()
  
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
  
  median_data["EU",] <- rep(0,23)
  for (i in countries){
    median_data[i,] <- rep(0,23)
  }
  # median_data["HU",] <- rep(0,23)
  median_data["PA",] <- runif(23, 1,4) %>% round(0)
  
  variables <- c("agea", "gndr", "eisced", "ppltrst", "pplfair", "pplhlp", "trstprl", "trstep", 
    "trstlgl", "imbgeco", "imueclt", "imwbcnt", "impcntr","imsmetn", "imdfetn","happy", "stflife","frprtpl", 
    "stfdem","stfeco", "stfedu", "stfhlth", "lrscale")
  
  for (i in 1:23){
    median_data["EU",i] <- weighted.median(unlist(ess_data[variables[i]]), ess_data$dweight)
    for (j in countries){
      median_data[j,i] <- weighted.median(unlist(subset(ess_data, cntry == j)[variables[i]]), subset(ess_data, cntry == j)$dweight) %>% round(0)
    }
    median_data["HU",i] <- weighted.median(unlist(subset(ess_data, cntry == "HU")[variables[i]]), subset(ess_data, cntry == "HU")$dweight) %>% round(0)
  }
  
  median_data <- select(median_data, -c(agea, gndr, eisced))
  
  median_data$imsmetn <- 5 - median_data$imsmetn
  median_data$imdfetn <- 5 - median_data$imdfetn
  median_data$impcntr <- 5 - median_data$impcntr
  
  median_data$frprtpl[1:2] <- c(5,1)
  median_data$imsmetn[1:2] <- c(4,1)
  median_data$imdfetn[1:2] <- c(4,1)
  median_data$impcntr[1:2] <- c(4,1)
  
  median_data$frprtpl <- median_data$frprtpl-1
  median_data$imsmetn <- median_data$imsmetn-1
  median_data$imdfetn <- median_data$imdfetn-1
  median_data$impcntr <- median_data$impcntr-1
  
  removed <- c("PA")}
  
  removed_trust <- c()
  
  indicators <- data.frame(list("Individual_Trust" = c(0,0,0), 
                                "Institutional_Trust" = c(0,0,0),
                                "Immigration_perception" = c(0,0,0),
                                "Immigration_rejection" = c(0,0,0),
                                "Immigration_racial" = c(0,0,0),
                                "Subjective_Satisfaction" = c(0,0,0),
                                "Political_Satisfaction" = c(0,0,0),
                                "Institutional_Satisfaction" = c(0,0,0)),
                           row.names = c("EU", "HU", "PA"))
  
  lindicator_list <- list("Individual_Trust" = c("ppltrst", "pplfair", "pplhlp"),
                          "Institutional_Trust" = c("trstprl", "trstep", "trstlgl"),
                          "Immigration_Perception" = c("imbgeco", "imeuclt", "imwbcnt"),
                          "Immigration_Rejection" = c("impcntr"),
                          "Immigration_Racial" = c("imsmetn", "imdfetn"),
                          "Subjective_Satisfaction" = c("happy", "stflife"),
                          "Political_Satisfaction" = c("frprtpl", "stfdem"),
                          "Institutional_Satisfaction" = c("stfedu", "stfeco", "stfhlth"))

  for (i in 1:length(row.names(indicators))){
    
  }
  
  indicators["EU",1] <- mean(median_data["EU",]$ppltrst, 
                             median_data["EU",]$pplfair, 
                             median_data["EU",]$pplhlp)
  
  indicators["EU",2] <- mean(median_data["EU",]$trstprl, 
                             median_data["EU",]$trstep, 
                             median_data["EU",]$trstlgl)
  
  indicators["HU",1] <- mean(median_data["HU",]$ppltrst, 
                             median_data["HU",]$pplfair, 
                             median_data["HU",]$pplhlp)
  
  indicators["HU",2] <- mean(median_data["HU",]$trstprl, 
                             median_data["HU",]$trstep, 
                             median_data["HU",]$trstlgl)
  
  indicators["PA",1] <- mean(median_data["PA",]$ppltrst, 
                             median_data["PA",]$pplfair, 
                             median_data["PA",]$pplhlp)
  
  indicators["PA",2] <- mean(median_data["PA",]$trstprl, 
                             median_data["PA",]$trstep, 
                             median_data["PA",]$trstlgl)
  
  indicators$cntry <- c("EU","HU","PA")
  
  ready <- c("Max", "Min", "EU","HU","PA")
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  output$radar_all <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[which(rownames(median_data) %nin% removed & rownames(median_data) %in% ready),], 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$radar_trust <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[ready,] %>% select(ppltrst,pplfair,pplhlp,trstprl,trstep,trstlgl), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed_trust,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })

  output$trust_indicators_individual <- renderPlot({
    ggplot(indicators) +
      geom_col(mapping = aes(y = Individual_Trust, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9), 
                           "HU" = rgb(0.8,0.2,0.5,0.9), 
                           "Participant" = rgb(0.7,0.5,0.1,0.9))) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  output$trust_indicators_institutional <- renderPlot({
    ggplot(indicators) +
      geom_col(mapping = aes(y = Institutional_Trust, x = cntry), 
               fill =  list("EU" = rgb(0.2,0.5,0.5,0.9), 
                            "HU" = rgb(0.8,0.2,0.5,0.9), 
                            "Participant" = rgb(0.7,0.5,0.1,0.9))) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  observeEvent(input$redraw_radar, {
    
    if (input$EU_check == T){
      removed <- removed %>% append("EU")
    }else if(input$EU_check == F){
      removed <- removed[removed != "EU"]
    }
    
    if (input$HU_check == T){
      removed <- removed %>% append("HU")
    }else if(input$EU_check == F){
      removed <- removed[removed != "HU"]
    }
    
    
    if (input$own_check == T){
      removed <- removed %>% append("PA")
    }else if(input$own_check == F){
      removed <- removed[removed != "PA"]
    }
    
    output$radar_all <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
      
      radarchart(df = median_data[which(rownames(median_data) %nin% removed & rownames(median_data) %in% ready),], 
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
      
      legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
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
      {fluidPage(
        fluidRow(
          column(12, align = "center",
            h1("Overview of all variables"),
            br(),
            br()
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
            actionButton("redraw_radar", "Update plot"),
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
      )}, # Overview
      {fluidPage(
        fluidRow(
          column(12, align = "center",
            h1("Trust"),
            br(),
            br()
          )
        ),
        fluidRow(
          column(10, offset = 1,
            p("Two types of trust indicators were calculated from the variables: Individual and Institutional
              Trust. People with a high Individual Trust indicator are more likely to trust other people, 
              and people with a high Institutional Trust indicator are more likely to trust the institutions 
              that govern them.")
          )
        ),
        fluidRow(
          column(1),
          column(6,
            plotOutput("radar_trust", height = 800, width = "auto")
          ),
          column(1,
                 plotOutput("trust_indicators_individual", height = 800, width = 90)
          ),
          column(1,
                 plotOutput("trust_indicators_institutional", height = 800, width = 90)
          ),
          column(2, align = "center",
            selectInput("cntry_trust", "Country (not implemented)",
                        choices = list("Hungary" = "HU", "United Kingdom" = "UK"),
                        selected = "Hungary"),
            checkboxInput("EU_check_trust", label = "Hide EU median"),
            checkboxInput("HU_check_trust", label = "Hide HU median"),
            checkboxInput("own_check_trust", label = "Hide own score", value = TRUE),
            actionButton("redraw_radar", "Update plot")),
          column(1)
        ),
        fluidRow(
          hr()
        )
      )} # Trust
    ),
    tabPanel("Other Data Visualisation")
  )
  
)

##############
# Launch App #
##############

shinyApp(ui = ui, server = server)