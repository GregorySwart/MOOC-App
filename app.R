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
  
  ess_data <<- as.data.frame(read_spss("ess_data.sav"))
  
  countries <<- ess_data$cntry %>% unique() %>% values2labels() %>% unclass()
  
  source("median_data.R")
  
  removed <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
               "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_trust <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                     "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  source("indicators.R")
  
  ready <- c("Max", "Min", "EU", "HU", "SU", "PA")
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  {observeEvent(input$submit_survey, once = TRUE, {
    # command to add a row to database on server
    updateActionButton(session = session,
                       inputId = "submit_survey",
                       label = "Thank you! Your answers have been submitted.")
  })} # Survey
  
  {
  output$radar_all <- renderPlot({
    
    colors_border=c("EU" = rgb(0.2,0.5,0.5,0.9), "HU" = rgb(0.8,0.2,0.5,0.9) , "PA" = rgb(0.7,0.5,0.1,0.9), "SU" = rgb(0.4,0.7,0.9,0.7) )
    colors_in=c(rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4), rgb(0.4,0.7,0.9,0.3) )
    
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
      
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9), rgb(0.4,0.7,0.9,0.9))
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4), rgb(0.4,0.7,0.9,0.4) )
      
      radarchart(df = median_data %>% subset(cntry %nin% removed | cntry == selected_cntry) %>% select(-cntry), 
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), cglwd=1, seg = 10,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
      
      legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == selected_cntry)), bty = "o", fill=colors_in, cex = 0.9)
    })
  })
  } # Overview
  
  {
  output$radar_trust <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data %>% subset(cntry %nin% removed_trust | cntry == "AT") %>% select(-cntry) %>% select(pplfair,pplhlp,trstprl,trstep,trstlgl,ppltrst), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed_trust,"Max","Min") | cntry == "AT")), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  observeEvent(input$redraw_trust, {
    
    if (input$EU_check_trust == T){
      removed_trust <- removed_trust %>% append("EU")
    }else if(input$EU_check == F){
      removed_trust <- removed_trust[removed_trust != "EU"]
    }
    
    if (input$SU_check_trust == T){
      removed_trust <- removed_trust %>% append("SU")
    }else if(input$EU_check == F){
      removed_trust <- removed_trust[removed_trust != "SU"]
    }
    
    if (input$own_check_trust == T){
      removed_trust <- removed_trust %>% append("PA")
    }else if(input$own_check_trust == F){
      removed_trust <- removed_trust[removed_trust != "PA"]
    }
    
    if (input$cntry_check_trust == T){
      selected_cntry_trust <- NA
    }else if(input$cntry_check == F){
      selected_cntry_trust <- input$cntry_trust
    }
    
    for (i in stat_variables){
      median_data["PA",i] <- as.numeric(input[[i]])
    }
    
    output$radar_trust <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
      
      radarchart(df = median_data %>% subset(cntry %nin% removed_trust | cntry == selected_cntry_trust) %>% select(-cntry) %>% select(pplfair,pplhlp,trstprl,trstep,trstlgl,ppltrst), 
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
      
      legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed_trust,"Max","Min") | cntry == selected_cntry_trust)), bty = "o", fill=colors_in, cex = 0.9)
    })
  
  })
    
  output$trust_indicators_individual <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Individual_Trust, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                           "PA" = rgb(0.7,0.5,0.1,0.9),
                           "HU" = rgb(0.8,0.2,0.5,0.9),
                           "SU" = rgb(0.4,0.7,0.9,0.9))
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
                            "HU" = rgb(0.8,0.2,0.5,0.9),
                            "SU" = rgb(0.4,0.7,0.9,0.9))) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  } # Trust
  
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

})

##################
# User Interface #
##################

ui <- shinyUI(
  
  navbarPage("MOOC App", collapsible = TRUE,
    theme = shinythemes::shinytheme("sandstone"),
    tabPanel("Survey",
      {fluidPage(
        h1("Demographics", align = "center"),
        p("Reactive demographics comparison is not yet implemented.", align = "center"),
        br(),
        br(),
        ess_slider(ID = "agea", label = "Age",
                   text = "Please enter your age in years."),
        ess_selector(ID = "gndr",
                     label = "Gender",
                     choices = c("Female", "Male", "Other"),
                     text = "Please select your gender.",
                     selected = "Female"),
        ess_selector(ID = "eisced",
                     label = "Please select your education level",
                      choices = c("ES-ISCED I , less than lower secondary" = 1,
                                  "ES-ISCED II, lower secondary" = 2,
                                  "ES-ISCED IIIb, lower tier upper secondary" = 3,
                                  "ES-ISCED IIIa, upper tier upper secondary" = 4,
                                  "ES-ISCED IV, advanced vocational, sub-degree" = 5,
                                  "ES-ISCED V1, lower tertiary education, BA level" = 6,
                                  "ES-ISCED V2, higher tertiary education, >= MA level" = 7),
                     text = "Please select your highest achieved education level.",
                     selected = 1),
        fluidRow(
          h1("Trust", align = "center"),
          br(),
          br(),
          br(),
          ess_slider(ID = "ppltrst", label = "Trust in people",
                     text = "Generally speaking, would you say that most people can be trusted, or that you can't 
                            be too careful in dealing with people? Please tell us on a score of 0 to 10, where 0 
                            means you can't be too careful and 10 means that most people can be trusted."),
          ess_slider(ID = "pplfair", label = "Fairness of people",
                     text = "Do you think that most people would try to take advantage of you if they got the 
                             chance, or would they try to be fair? Here 0 means people would try to take advantage of 
                             you and 10 means most people try to be fair."),
          ess_slider(ID = "pplhlp", label = "Helpfulness of people",
                     text = "Would you say that most of the time people try to be helpful or that they are 
                             mostly looking out for themselves? Here 0 means most people are just looking 
                             out for themselves, while 10 means they are mostly helpful."),
          ess_slider(ID = "trstprl", label = "Trust in parliament",
                     text = "Please tell us on a score of 0-10 how much you personally trust 
                             your country's parliament. 0 means you do not trust the institution at all, and 10 
                             means you have complete trust."),
          ess_slider(ID = "trstlgl", label = "Trust in legal system",
                     text = "Please tell us on a score of 0-10 how much you personally trust 
                     your country's legal system. 0 means you do not trust the institution at all, and 10 
                     means you have complete trust."),
          ess_slider(ID = "trstep", label = "Trust in European Parliament",
                     text = "Please tell us on a score of 0-10 how much you personally trust 
                     the European Parliament. 0 means you do not trust the institution at all, and 10 
                     means you have complete trust.")
        ),
        fluidRow(
          h1("Immigration attitudes", align = "center"),
          br(),
          br(),
          br(),
          
          ess_slider(ID = "imbgeco", label = "Effect on economy",
                     text = "Would you say it is generally bad or good for your country's economy that 
                     people come to live here from other countries? (0 = bad for the economy, 10 = good 
                     for the economy)"),
          ess_slider(ID = "imueclt", label = "Effect on culture",
                     text = "Would you say that your country's cultural life is generally undermined or 
                     enriched by people coming to live here from other countries? (0 = cultural life 
                     undermined, 10 = cultural life enriched)"),
          ess_slider(ID = "imwbcnt", label = "Effect on country as a whole",
                     text = "Is your country made a worse or a better place to live by people coming to 
                     live here from other countries? (0 = Worse place to live, 10 = Better place to live)"),
        
        ess_selector(ID = "impcntr",
                     label = "From poorer countries outside of Europe",
                     choices = c("Allow many to come and live here (3)" = 3,
                                 "Allow some (2)" = 2,
                                 "Allow a few (1)" = 1,
                                 "Allow none (0)" = 0),
                     text = "To what extent do you think your country should allow people from poorer countries 
                   outside of Europe to come and live here?",
                     selected = 0),
        ess_selector(ID = "imsmetn",
                     label = "Immigrants of the same race",
                     choices = c("Allow many to come and live here (3)" = 3,
                                 "Allow some (2)" = 2,
                                 "Allow a few (1)" = 1,
                                 "Allow none (0)" = 0),
                     text = "To what extent do you think your country should allow people of the same race or 
                   ethnic group as most inhabitants to come and live here?",
                     selected = 0),
        ess_selector(ID = "imdfetn",
                     label = "Immigrants of a different race",
                     choices = c("Allow many to come and live here (3)" = 3,
                                 "Allow some (2)" = 2,
                                 "Allow a few (1)" = 1,
                                 "Allow none (0)" = 0),
                     text = "To what extent do you think your country should allow people of a different race or 
                   ethnic group as most inhabitants to come and live here?",
                     selected = 0)
        ),
        fluidRow(
          h1("Satisfaction", align = "center"),
          br(),
          br(),
          br(),
          ess_slider(ID = "happy", label = "General happiness",
                     text = "Taking all things together, how happy would you say you are? 
                     (0 = Extremely unhappy, 10 = Extremely happy)"),
          ess_slider(ID = "stflife", label = "Satisfaction with life in general",
                     text = "All things considered, how satisfied are you with your life as a whole nowadays? 
                     Please answer the slider to the left, where 0 means extremely dissatisfied and 10 means 
                     extremely satisfied."),
          ess_slider(ID = "frprtpl", label = "Political fairness", max = 4,
                     text = "How much would you say that the political system in country ensures that 
                     everyone has a fair chance to participate in politics? 
                     (0 = Not at all, 4 = A great deal)"),
          ess_slider(ID = "stfdem", label = "Satisfaction with democracy",
                     text = "On the whole, how satisfied are you with the way democracy works in your country? 
                     (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
          ess_slider(ID = "stfeco", label = "Satisfaction with economy",
                     text = "On the whole how satisfied are you with the present state of the economy in your 
                     country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
          ess_slider(ID = "stfedu", label = "Satisfaction with education",
                     text = "On the whole how satisfied are you with the present state of the education system 
                     in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
          ess_slider(ID = "stfhlth", label = "Satisfaction with healthcare",
                     text = "On the whole how satisfied are you with the present state of the healthcare system 
                     in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
          br(),
          h3("Placement on political scale", align = "center"),
          br(),
          ess_slider(ID = "lrscale", label = "Placement on left-right scale",
                     text = "In politics people sometimes talk of 'left' and 'right'. Using this slider, where 
                     would you place yourself on this scale, where 0 means the left and 10 means the right?"),
          column(3, offset = 1,
            # sliderInput("lrscale", label = "Placement on left-right scale",
            #             min = 0, max = 10, value = 0,
            # )
          )
        ),
        fluidRow(align = "center",
          actionButton("submit_survey", label = "Submit responses"),
          br(),
          br(),
          br(),
          br()
        ),
        fluidRow(
          column(4, offset = 4,
            h4("Please note", align = "center"),
            p("To view your results in comparison to other survey participants, the EU population 
              and various countries' populations, you will have to uncheck the \"Hide own responses\" 
              checkbox, and update the plots in the \"Radar charts\" tab.", align = "center"),
            br(),
            br(),
            br(),
            br()
          )
        )
      )} # Survey
    ),
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
            selectInput("cntry_trust", "Select country",
                        choices = list("Austria (AT)" = "AT",
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
            checkboxInput("EU_check_trust", label = "Hide EU median"),
            checkboxInput("cntry_check_trust", label = "Hide country median"),
            checkboxInput("SU_check_trust", label = "Hide SU median"),
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
    tabPanel("Circular bar charts")
  )
  
)

##############
# Launch App #
##############

shinyApp(ui = ui, server = server)