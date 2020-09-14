# import libraries
source("libraries.R")

##########
# SERVER #
##########

server <- shinyServer(function(input, output, session) {
  
  #########################
  # Data load and cleanup #
  #########################
  
  #Import data
  source("functions.R")
  
  ess_data <- as.data.frame(read_spss("ess_data.sav"))
  
  countries <- ess_data$cntry %>% unique() %>% values2labels() %>% unclass()
  
  source("median_data.R")
  
  removed <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
               "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_trust <- c()
  
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
                         "Immigration_Perception" = c("imbgeco", "imeuclt", "imwbcnt"),
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
  }
  
  indicators["EU",1] <- mean(median_data["EU",]$ppltrst, 
                             median_data["EU",]$pplfair, 
                             median_data["EU",]$pplhlp)
  
  indicators["EU",2] <- mean(median_data["EU",]$trstprl, 
                             median_data["EU",]$trstep, 
                             median_data["EU",]$trstlgl)
  
  indicators["PA",1] <- mean(median_data["PA",]$ppltrst, 
                             median_data["PA",]$pplfair, 
                             median_data["PA",]$pplhlp)
  
  indicators["PA",2] <- mean(median_data["PA",]$trstprl, 
                             median_data["PA",]$trstep, 
                             median_data["PA",]$trstlgl)
  
  indicators$cntry <- rownames(indicators)
  
  ready <- c("Max", "Min", "EU", "HU", "PA")
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  
  output$radar_all <- renderPlot({
    colors_border=c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c(rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data %>% subset(cntry %nin% removed | cntry == input$cntry_radar_all) %>% select(-cntry), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == input$cntry_radar_all)), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$radar_trust <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[ready,] %>% select(ppltrst,pplfair,pplhlp,trstprl,trstep,trstlgl), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed_trust,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$radar_satisfaction <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[ready,] %>% select(happy, stflife, frprtpl, stfdem, stfeco, stfedu, stfhlth), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed_trust,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })

  output$radar_immigration <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[ready,] %>% select(imbgeco,imueclt,imwbcnt,impcntr,imsmetn,imdfetn), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed_trust,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$trust_indicators_individual <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Individual_Trust, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                           "PA" = rgb(0.7,0.5,0.1,0.9),
                           "HU" = rgb(0.8,0.2,0.5,0.9))
               ) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  output$trust_indicators_institutional <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Institutional_Trust, x = cntry), 
               fill =  list("EU" = rgb(0.2,0.5,0.5,0.9),
                            "PA" = rgb(0.7,0.5,0.1,0.9),
                            "HU" = rgb(0.8,0.2,0.5,0.9))) +
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
    
    
    output$radar_all <- renderPlot({
      
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
      
      radarchart(df = median_data %>% subset(cntry %nin% removed | cntry == selected_cntry) %>% select(-cntry), 
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
      
      legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == selected_cntry)), bty = "o", fill=colors_in, cex = 0.9)
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
            selectInput("cntry_radar_all", "Select country",
                        choices =  list("Austria (AT)" = "AT",
                                        "Belgium (BE)" = "BE", 
                                        "Bulgaria (BG)" = "BG",
                                        "Switzerland (CH)" = "CH",
                                        "Cyprus (CY)" = "CY",
                                        "Czechia (CZ)"= "CZ",
                                        "Germany (DE)" = "DE",
                                        "Estonia (EE)" = "EE",
                                        "Finland (FI)" = "FI",
                                        "France (FR)" = "FR",
                                        "United Kingdom (GB)" = "GB",
                                        "Hungary (HU)" = "HU",
                                        "Ireland (IE)" = "IE",
                                        "Italy (IT)" = "IT",
                                        "Netherlands (NL)" = "NL",
                                        "Norway (NO)" = "NO",
                                        "Poland (PL)" = "PL",
                                        "Serbia (RS)" = "RS",
                                        "Slovenia (SI)" = "SI"),
                        selected = "AT"),
            # hr(),
            checkboxInput("EU_check", label = "Hide EU median"),
            checkboxInput("cntry_check", label = "Hide country median"),
            checkboxInput("SU_check", label = "Hide survey median"),
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
              following: IMSMETN, IMDFETN, IMPCNTR scale 0 to 3, and FRPRTPL scales 0 to 4. Scores for these 
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
            actionButton("redraw_trust", "Update plot")),
          column(1)
        ),
        fluidRow(
          hr()
        )
      )}, # Trust
      {fluidPage(
        fluidRow(
          column(12, align = "center",
                 h1("Immigration"),
                 br(),
                 br()
          )
        ),
        fluidRow(
          column(10, offset = 1,
                 p("Two indicators were derived from variables dealing with immigration: Immigration 
                   Perception, and Immigration Rejection. (Immigration Racial?) Immigration Perception 
                   refers to the percieved good or bad effects immigration has in the eyes of its 
                   residents, calculated by taking the average of the varaibles imbgeco, imueclt, imwbcnt. 
                   Immigration rejection refers to the proportion of people who answered \"Allow none.\" to 
                   the question \"How many immigrants would you allow to come and live in your country from 
                   poorer countries outside of europe?\".")
          )
        ),
        fluidRow(
          column(1),
          column(6,
                 plotOutput("radar_immigration", height = 800, width = "auto")
          ),
          column(1,
                 plotOutput("immigration_perception", height = 800, width = 90)
          ),
          column(1,
                 plotOutput("immigration_rejection", height = 800, width = 90)
          ),
          column(2, align = "center",
                 selectInput("cntry_immigration", "Country (not implemented)",
                             choices = list("Hungary" = "HU", "United Kingdom" = "UK"),
                             selected = "Hungary"),
                 checkboxInput("EU_check_immigration", label = "Hide EU median"),
                 checkboxInput("HU_check_immigration", label = "Hide HU median"),
                 checkboxInput("own_check_immigration", label = "Hide own score", value = TRUE),
                 actionButton("redraw_immigration", "Update plot")),
          column(1)
        ),
        fluidRow(
          hr()
        )
      )}, # Immigration
      {fluidPage(
        fluidRow(
          column(12, align = "center",
                 h1("Satisfaction"),
                 br(),
                 br()
          )
        ),
        fluidRow(
          column(10, offset = 1,
                 p("Three satisfaction indicators were derived from the data. Subjective Satisfaction 
                   is the average value of the variables happiness and satisfaction in life. Political 
                   Satisfaction in the average value of the variables frprtpl (Political system in country 
                   allows all to participate freely and equally in politics) and satisfaction with how
                   democracy works. Institutional Satisfaction is the average of the variables stfeco 
                   (satisfaction with democracy in own country), stfedu (satistaction with education system),
                   and atfhlth (satisfaction with healthcare system). All variables have range 0-10.")
          )
        ),
        fluidRow(
          column(1),
          column(5,
                 plotOutput("radar_satisfaction", height = 800, width = "auto")
          ),
          column(1,
                 plotOutput("Subjective_Satisfaction", height = 800, width = 90)
          ),
          column(1,
                 plotOutput("Political_Satisfaction", height = 800, width = 90)
          ),
          column(1,
                 plotOutput("Institutional_Satisfaction", height = 800, width = 90)
          ),
          column(2, align = "center",
                 selectInput("cntry_satisfaction", "Country (not implemented)",
                             choices = list("Hungary" = "HU", "United Kingdom" = "UK"),
                             selected = "Hungary"),
                 checkboxInput("EU_check_satisfaction", label = "Hide EU median"),
                 checkboxInput("HU_check_satisfaction", label = "Hide HU median"),
                 checkboxInput("own_check_satisfaction", label = "Hide own score", value = TRUE),
                 actionButton("redraw_satisfaction", "Update plot")),
          column(1)
        ),
        fluidRow(
          hr()
        )
      )}  # Satisfaction
    ),
    tabPanel("Other Data Visualisation")
  )
  
)

##############
# Launch App #
##############

shinyApp(ui = ui, server = server)