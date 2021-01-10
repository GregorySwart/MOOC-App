function(input, output, session) {
  
  #=======================#
  # Data load and cleanup #
  #=======================#
  
  hardcode <- TRUE # set this to TRUE when testing to skip through the questionnaire
  
  source("libraries.R") # load in libraries
  source("texts.R")
  source("functions.R") # define %nin%, ess_selector, ess_slider functions
  source("labels.R")
  
  #Import data
  ess_data <<- as.data.frame(read_spss("ess_data.sav"))
  countries <<- ess_data$cntry %>% unique() %>% values2labels() %>% unclass()
  
  variables <<- colnames(ess_data)[5:25]
  
  source("median_data.R")
  
  removed <- c("Own response", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
               "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_trust <- c("Own response", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                     "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_immigration <- c("Own response", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                           "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_satisfaction <- c("Own response", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                            "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  ready <- c("Max", "Min", "EU", "HU", "SU", "PA")
  ready_var <- c("Max", "Min", "EU", "HU", "SU")
  
  #Clean data
  
  #===========#
  # Reactives #
  #===========#
  
  # BUTTON: Remove intro and add trust
  {
    observeEvent(input$end_intro, once = TRUE, {
      insertTab(
        inputId = "mooc_app", target = "data",
          tab = {
            tabPanel(title = "Survey - Trust", value = "survey_trust", icon = icon("thumbs-up"),
              fluidPage(
                fluidRow(
                  column(10, offset = 1, align = "center",
                    h1("Trust", align = "center"),
                    ess_selector(ID = "ppltrst", label = "1. Trust in people",
                     choices = c("Please select..." = NA,0:10),
                     selected = "Please select...",
                    text = "Generally speaking, would you say that most people can be trusted, or that you can't be too careful in dealing with people? Please tell us on a score of 0 to 10, where 0 means you can't be too careful and 10 means that most people can be trusted."),
                    ess_selector(ID = "pplfair", label = "2. Fairness of people",
                      choices = c("Please select..." = NA,0:10),
                      selected = "Please select...",
                      text = "Do you think that most people would try to take advantage of you if they got the chance, or would they try to be fair? Here 0 means people would try to take advantage of you and 10 means most people try to be fair."),
                      ess_selector(ID = "pplhlp", label = "3. Helpfulness of people",
                        choices = c("Please select..." = NA,0:10),
                        selected = "Select...",
                        text = "Would you say that most of the time people try to be helpful or that they are mostly looking out for themselves? Here 0 means most people are just looking out for themselves, while 10 means they are mostly helpful."),
                      ess_selector(ID = "trstprl", label = "4. Trust in parliament",
                        choices = c("Please select..." = NA,0:10),
                        selected = "Select...",
                        text = "Please tell us on a score of 0-10 how much you personally trust your country's parliament. 0 means you do not trust the institution at all, and 10 means you have complete trust."),
                      ess_selector(ID = "trstlgl", label = "5. Trust in legal system",
                        choices = c("Please select..." = NA,0:10),
                        selected = "Select...",
                        text = "Please tell us on a score of 0-10 how much you personally trust your country's legal system. 0 means you do not trust the institution at all, and 10 means you have complete trust."),
                      ess_selector(ID = "trstep", label = "6. Trust in European Parliament",
                       choices = c("Please select..." = NA,0:10),
                       selected = "Select...",
                       text = "Please tell us on a score of 0-10 how much you personally trust the European Parliament. 0 means you do not trust the institution at all, and 10 means you have complete trust."),
                      br(),
                      actionButton(inputId = "end_trust", label = "Submit answers and continue"),
                      br(),
                      hr(),
                      br()
                 )
               )
            )
          )
        } # survey_trust tab
      )
      removeTab(inputId = "mooc_app",
                target = "introduction",
                session = session)
      #updateNavbarPage(inputId = "mooc_app", session = session, selected = "survey_trust")
    })
  } # Introduction
  
  # BUTTON: remove trust and add immigration
  {
    observeEvent(input$end_trust, once = FALSE, {
      state <- TRUE
      for (i in trust_variables){
        if(input[[i]] %nin% 0:10){state <- FALSE}
      }
      if(hardcode == TRUE){state <- TRUE} # Hardcode TRUE for testing
      if(state == TRUE){
        insertTab(inputId = "mooc_app",
                  target = "data",
                  tab = {tabPanel(title = "Survey - Immigration", value = "survey_immigration", icon = icon("users"),
                                  fluidPage(
                                    column(10, offset = 1, align = "center",
                                           fluidRow(
                                             h1("Immigration attitudes", align = "center"),
                                             ess_selector(ID = "imbgeco", label = "7. Effect on economy",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "Would you say it is generally bad or good for your country's economy that people come to live here from other countries? (0 = bad for the economy, 10 = good for the economy)"),
                                             ess_selector(ID = "imueclt", label = "8.Effect on culture",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "Would you say that your country's cultural life is generally undermined or enriched by people coming to live here from other countries? (0 = cultural life undermined, 10 = cultural life enriched)"),
                                             ess_selector(ID = "imwbcnt", label = "9. Effect on country as a whole",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "Is your country made a worse or a better place to live by people coming to live here from other countries? (0 = Worse place to live, 10 = Better place to live)"),
                                             
                                             ess_selector(ID = "impcntr",
                                                          label = "10. From poorer countries outside of Europe",
                                                          choices = c("Please select..." = NA,
                                                                      "Allow many to come and live here (3)" = 3,
                                                                      "Allow some (2)" = 2,
                                                                      "Allow a few (1)" = 1,
                                                                      "Allow none (0)" = 0),
                                                          text = "To what extent do you think your country should allow people from poorer countries outside of Europe to come and live here?",
                                                          selected = "Please Select"),
                                             ess_selector(ID = "imsmetn",
                                                          label = "11. Immigrants of the same race",
                                                          choices = c("Please select..." = NA,
                                                                      "Allow many to come and live here (3)" = 3,
                                                                      "Allow some (2)" = 2,
                                                                      "Allow a few (1)" = 1,
                                                                      "Allow none (0)" = 0),
                                                          text = "To what extent do you think your country should allow people of the same race or ethnic group as most inhabitants to come and live here?",
                                                          selected = "Please select"),
                                             ess_selector(ID = "imdfetn",
                                                          label = "12. Immigrants of a different race",
                                                          choices = c("Please select..." = NA,
                                                                      "Allow many to come and live here (3)" = 3,
                                                                      "Allow some (2)" = 2,
                                                                      "Allow a few (1)" = 1,
                                                                      "Allow none (0)" = 0),
                                                          text = "To what extent do you think your country should allow people of a different race or ethnic group as most inhabitants to come and live here?",
                                                          selected = "Please select..."),
                                             br(),
                                             actionButton(inputId = "end_immigration", label = "Submit answers and continue"),
                                             br(),
                                             hr(),
                                             br()
                                           ),
                                    )
                                  )
                  )}, # survey_immigration tab
        )
        removeTab(inputId = "mooc_app",
                  target = "survey_trust",
                  session = session)
        shinyalert(
          title = "Adjusted Scales",
          text = "Some variable scalings have been adjusted for consistency. See specifics in the \"Data\" tab on the top right. Affected variables are numbers 10, 11, 12 and 15.",
          size = "s", 
          closeOnEsc = TRUE,
          closeOnClickOutside = TRUE,
          html = FALSE,
          type = "info",
          showConfirmButton = TRUE,
          showCancelButton = FALSE,
          confirmButtonText = "OK",
          confirmButtonCol = "#808080",
          timer = 0,
          imageUrl = "",
          animation = FALSE
        )
      }else{
        updateActionButton(inputId = "end_trust", session = session, 
                           label = "Please answer all of the questions to continue")
      }
    })
  } # Survey - Trust
  
  # BUTTON: remove immigration and add satisfaction
  {
    observeEvent(input$end_immigration, once = FALSE, {
      state <- TRUE
      for (i in immigration_variables){
        if(input[[i]] %nin% 0:10){state <- FALSE}
      }
      if(hardcode == TRUE){state <- TRUE} # Hardcode for testing
      if(state == TRUE){
        insertTab(inputId = "mooc_app",
                  target = "data",
                  tab = {tabPanel(title = "Survey - Satisfaction", value = "survey_satisfaction", icon = icon("smile"),
                                  fluidPage(
                                    fluidRow(
                                      column(10, offset = 1, align = "center",
                                             h1("Satisfaction", align = "center"),
                                             ess_selector(ID = "happy", label = "13. General happiness",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "Taking all things together, how happy would you say you are? (0 = Extremely unhappy, 10 = Extremely happy)"),
                                             ess_selector(ID = "stflife", label = "14. Satisfaction with life in general",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "All things considered, how satisfied are you with your life as a whole nowadays? Please answer the slider to the left, where 0 means extremely dissatisfied and 10 means extremely satisfied."),
                                             ess_selector(ID = "frprtpl", label = "15. Political fairness",
                                                          choices = c("Please select..." = NA,0:5),
                                                          selected = "Please select...",
                                                          text = "How much would you say that the political system in country ensures that everyone has a fair chance to participate in politics? (0 = Not at all, 4 = A great deal)"),
                                             ess_selector(ID = "stfdem", label = "16. Satisfaction with democracy",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole, how satisfied are you with the way democracy works in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             ess_selector(ID = "stfeco", label = "17. Satisfaction with economy",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole how satisfied are you with the present state of the economy in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             ess_selector(ID = "stfedu", label = "18. Satisfaction with education",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole how satisfied are you with the present state of the education system in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             ess_selector(ID = "stfhlth", label = "19. Satisfaction with healthcare",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole how satisfied are you with the present state of the healthcare system in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             br(),
                                             actionButton(inputId = "end_satisfaction", label = "Submit answers and continue"),
                                             br(),
                                             hr(),
                                             br()
                                      )
                                    ),
                                  )
                  )}, # survey_satisfaction tab
        )
        removeTab(inputId = "mooc_app",
                  target = "survey_immigration",
                  session = session)
        #updateNavbarPage(inputId = "mooc_app", session = session, selected = "survey_satisfaction")
      }else{
        updateActionButton(inputId = "end_immigration", session = session, 
                           label = "Please answer all of the questions to continue")
      }
    })
  } # Survey - Immigration
  
  # BUTTON: remove Satisfaction and add Left Right Scale
  {
    observeEvent(input$end_satisfaction, once = FALSE, {
      state <- TRUE
      for (i in satisfaction_variables){
        if(input[[i]] %nin% 0:10){state <- FALSE}
      }
      if(hardcode == TRUE){state <- TRUE} # Hardcode for testing
      if(state == TRUE){
        prependTab(inputId = "mooc_app",
                   tab = {tabPanel(title = "Survey - Left-Right Scale", value = "survey_lrscale", icon = icon("exchange-alt"),
                                   fluidPage(
                                     fluidRow(
                                       br(),
                                       h3("Placement on political scale", align = "center"),
                                       br(),
                                       ess_selector(ID = "lrscale", label = "20. Placement on left-right scale",
                                                    choices = c("Please select..." = NA,0:10),
                                                    selected = "Please select...",
                                                    text = "In politics people sometimes talk of 'left' and 'right'. Using this slider, where would you place yourself on this scale, where 0 means the left and 10 means the right?"),
                                       hr(),
                                       br(),
                                       br()
                                     ),
                                     fluidRow(align = "center",
                                              actionButton("submit_survey", label = "Submit responses and view results"),
                                              br(),
                                              br(),
                                              br(),
                                              br()
                                     ),
                                     br(),
                                     br(),
                                     br(),
                                     br(),
                                     br()
                                   )
                   )}, # survey_lrscale tab
        )
        removeTab(inputId = "mooc_app",
                  target = "survey_satisfaction",
                  session = session)
        #updateNavbarPage(inputId = "mooc_app", session = session, selected = "survey_lrscale")
      }else{
        updateActionButton(inputId = "end_satisfaction", session = session, 
                           label = "Please answer all of the questions to continue")
        
      }
    })
  } # Survey - Satisfaction
  
  # BUTTON: remove lrscale tab and add RADAR CHARTS, CIRCULAR BAR CHARTS and HISTOGRAMS
  {
    observeEvent(input$submit_survey, once = FALSE, {
      state <- TRUE
      if(input$lrscale %nin% 0:10){state <- FALSE}
      if(hardcode == TRUE){state <- TRUE} # hard code to true to save time when testing
      if(state == TRUE){
        source("map_drawer.R")
        source("country_comparison.R")
        source("histograms.R") # HISTOGRAMS
        source("circular_bar_charts.R") # CIRCULAR BAR CHARTS
        source("radar_charts.R") # RADAR CHARTS
        updateNavbarPage(session = session, inputId = "mooc_app",
                         selected = "radar_charts")
        removeTab(inputId = "mooc_app",
                  target = "survey_lrscale")
        for (i in 1:length(stat_variables)){
          mean_data["Own response", i] <<- as.numeric(input[[stat_variables[i]]])
        }
        if(hardcode == TRUE){ # simulate responses when answers are left blank for testing
          for (i in 1:length(stat_variables)){
            if(is.na(mean_data["Own response", i]) == TRUE){
              mean_data["Own response", i] <<- runif(1, 0, 3) %>% round(0)
            }
          }
        }
      }else{
        updateActionButton(session = session,
                           inputId = "submit_survey",
                           label = "Please answer all of the questions to continue")
      }
    })
    
  } # Survey - Left Right Scale
  
  
  {
    output$radar_all <- renderPlot({
      
      colors_border = c("EU" = rgb(0.2,0.5,0.5,0.9), 
                        "HU" = rgb(0.8,0.2,0.5,0.9), 
                        "PA" = rgb(0.7,0.5,0.1,0.9))
      
      colors_in = c(rgb(0.2,0.5,0.5,0.4), 
                    rgb(0.8,0.2,0.5,0.4), 
                    rgb(0.7,0.5,0.1,0.4))
      
      radarchart(df = mean_data %>% subset(cntry %nin% removed | cntry == "AT") %>% select(-cntry),
                 cglcol="grey",
                 cglty=1,
                 axislabcol="grey20",
                 axistype = 5,
                 caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), 
                 cglwd=1,
                 seg = 10,
                 pcol=colors_border,
                 pfcol=colors_in,
                 plwd=4,
                 plty=1)
      
      legend("topright",
             legend = rownames(mean_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == "AT")), 
             bty = "o", fill=colors_in, cex = 0.9)
    })
    
    observeEvent(input$redraw_radar, {
      
      if (input$EU_check == T){
        removed <- removed %>% append("EU")
      }else if(input$EU_check == F){
        removed <- removed[removed != "EU"]
      }
      
      if (input$own_check == T){
        removed <- removed %>% append("Own response")
      }else if(input$own_check == F){
        removed <- removed[removed != "Own response"]
      }
      
      if (input$cntry_check == T){
        selected_cntry <- NA
      }else if(input$cntry_check == F){
        selected_cntry <- input$cntry_radar_all
      }
      
      output$radar_all <- renderPlot({
        
        colors_border = c(rgb(0.2,0.5,0.5,0.9), 
                          rgb(0.8,0.2,0.5,0.9), 
                          rgb(0.7,0.5,0.1,0.9))
        
        colors_in = c(rgb(0.2,0.5,0.5,0.4), 
                      rgb(0.8,0.2,0.5,0.4), 
                      rgb(0.7,0.5,0.1,0.4))
        
        radarchart(df = mean_data %>% subset(cntry %nin% removed | cntry == selected_cntry) %>% select(-cntry), 
                   cglcol="grey", 
                   cglty=1, 
                   axislabcol="grey20", 
                   axistype = 5, 
                   caxislabels = c(0,NA,2,NA,4,NA,6,NA,8,NA,NA), 
                   cglwd=1, 
                   seg = 10,
                   pcol=colors_border, 
                   pfcol=colors_in, 
                   plwd=4, 
                   plty=1)
        
        legend("topright",
               legend = rownames(mean_data %>% subset(cntry %nin% c(removed,"Max","Min") | cntry == selected_cntry)),
               bty = "o", fill=colors_in, cex = 0.9)
      })
    })
  } # Overview
  
  
  {
    output$radar_trust <- renderPlot({
      colors_border=c(rgb(0.2,0.5,0.5,0.9), 
                      rgb(0.8,0.2,0.5,0.9), 
                      rgb(0.7,0.5,0.1,0.9))
      
      colors_in = c(rgb(0.2,0.5,0.5,0.4),
                    rgb(0.8,0.2,0.5,0.4),
                    rgb(0.7,0.5,0.1,0.4))
      
      radarchart(df = {mean_data %>% subset(cntry %nin% removed_trust | cntry == "AT") %>%
                   select(-cntry)}[,1:6], # %>% select(pplfair,pplhlp,trstprl,trstep,trstlgl,ppltrst), 
                 cglcol="grey",
                 cglty=1,
                 axislabcol="grey20",
                 axistype = 5,
                 caxislabels = c(0,2,4,6,8,NA),
                 cglwd = 1,
                 seg = 5,
                 pcol = colors_border, 
                 pfcol = colors_in, 
                 plwd = 4, 
                 plty = 1)
      
      legend("topright",
             legend = rownames(mean_data %>% 
                                 subset(cntry %nin% c(removed_trust,"Max","Min") | cntry == "AT")),
             bty = "o",
             fill=colors_in,
             cex = 0.9)
    })
    
    observeEvent(input$redraw_trust, {
      
      if (input$EU_check_trust == T){
        removed_trust <- removed_trust %>% append("EU")
      }else if(input$EU_check_trust == F){
        removed_trust <- removed_trust[removed_trust != "EU"]
      }
      
      if (input$own_check_trust == T){
        removed_trust <- removed_trust %>% append("Own response")
      }else if(input$own_check_trust == F){
        removed_trust <- removed_trust[removed_trust != "Own response"]
      }
      
      if (input$cntry_check_trust == T){
        selected_cntry_trust <- NA
      }else if(input$cntry_check_trust == F){
        selected_cntry_trust <- input$cntry_trust
      }
      
      output$radar_trust <- renderPlot({
        colors_border = c(rgb(0.2,0.5,0.5,0.9),
                          rgb(0.8,0.2,0.5,0.9),
                          rgb(0.7,0.5,0.1,0.9))
        
        colors_in=c( rgb(0.2,0.5,0.5,0.4),
                     rgb(0.8,0.2,0.5,0.4), 
                     rgb(0.7,0.5,0.1,0.4))
        
        radarchart(df = {mean_data %>% subset(cntry %nin% removed_trust | cntry == selected_cntry_trust) %>% 
                     select(-cntry)}[,1:6], # %>% select(pplfair,pplhlp,trstprl,trstep,trstlgl,ppltrst), 
                   cglcol="grey",
                   cglty=1,
                   axislabcol="grey20",
                   axistype = 5,
                   caxislabels = c(0,2,4,6,8,NA),
                   cglwd=1,
                   seg = 5,
                   pcol=colors_border,
                   pfcol=colors_in,
                   plwd=4,
                   plty=1)
        
        legend("topright",
               legend = rownames(mean_data %>%
                                   subset(cntry %nin% c(removed_trust,"Max","Min") | cntry == selected_cntry_trust)),
               bty = "o",
               fill=colors_in,
               cex = 0.9)
      })
    })
  } # Trust
  
  
  {
    output$radar_immigration <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9),
                       rgb(0.8,0.2,0.5,0.9),
                       rgb(0.7,0.5,0.1,0.9))
      
      colors_in=c(rgb(0.2,0.5,0.5,0.4),
                  rgb(0.8,0.2,0.5,0.4),
                  rgb(0.7,0.5,0.1,0.4))
      
      radarchart(df = {mean_data %>% subset(cntry %nin% removed_immigration | cntry == "AT") %>%
                   select(-cntry)}[,7:12], # %>% select(imbgeco,imueclt,imwbcnt,impcntr,imsmetn,imdfetn),
                 cglcol="grey",
                 cglty=1,
                 axislabcol="grey20",
                 axistype = 5,
                 caxislabels = c(0,2,4,6,8,NA),
                 cglwd=1,
                 seg = 5,
                 pcol=colors_border,
                 pfcol=colors_in,
                 plwd=4, 
                 plty=1)
      
      legend("topright",
             legend = rownames(mean_data %>%
                                 subset(cntry %nin% c(removed_immigration,"Max","Min") | cntry == "AT")),
             bty = "o",
             fill = colors_in,
             cex = 0.9)
    })
    
    observeEvent(input$redraw_immigration, {
      
      if (input$EU_check_immigration == T){
        removed_immigration <- removed_immigration %>% append("EU")
      }else if(input$EU_check_trust == F){
        removed_immmigration <- removed_immigration[removed_immigration != "EU"]
      }
      
      if (input$own_check_immigration == T){
        removed_immigration <- removed_immigration %>% append("Own response")
      }else if(input$own_check_immigration == F){
        removed_immigration <- removed_immigration[removed_immigration != "Own response"]
      }
      
      if (input$cntry_check_immigration == T){
        selected_cntry_immigration <- NA
      }else if(input$cntry_check_immigration == F){
        selected_cntry_immigration <- input$cntry_immigration
      }
      
      # for (i in stat_variables){
      #   mean_data["PA",i] <- as.numeric(input[[i]])
      # }
      
      output$radar_immigration <- renderPlot({
        colors_border=c(rgb(0.2,0.5,0.5,0.9),
                        rgb(0.8,0.2,0.5,0.9),
                        rgb(0.7,0.5,0.1,0.9))
        
        colors_in=c(rgb(0.2,0.5,0.5,0.4),
                    rgb(0.8,0.2,0.5,0.4),
                    rgb(0.7,0.5,0.1,0.4))
        
        radarchart(df = {mean_data %>% subset(cntry %nin% removed_immigration | cntry == selected_cntry_immigration) %>% 
                          select(-cntry)}[,7:12], # %>% select(imbgeco,imueclt,imwbcnt,impcntr,imsmetn,imdfetn),
                   cglcol="grey",
                   cglty=1,
                   axislabcol="grey20",
                   axistype = 5,
                   caxislabels = c(0,2,4,6,8,NA),
                   cglwd=1,
                   seg = 5,
                   pcol=colors_border,
                   pfcol=colors_in,
                   plwd=4,
                   plty=1)
        
        legend("topright",
               legend = rownames(mean_data %>%
                 subset(cntry %nin% c(removed_immigration,"Max","Min") | cntry == selected_cntry_immigration)),
               bty = "o",
               fill=colors_in,
               cex = 0.9)
      })
    })
  } # Immigration
  
  
  {
    output$radar_satisfaction <- renderPlot({
      colors_border = c(rgb(0.2,0.5,0.5,0.9),
                        rgb(0.8,0.2,0.5,0.9),
                        rgb(0.7,0.5,0.1,0.9))
      
      colors_in = c(rgb(0.2,0.5,0.5,0.4),
                    rgb(0.8,0.2,0.5,0.4),
                    rgb(0.7,0.5,0.1,0.4))
      
      radarchart(df = {mean_data %>% subset(cntry %nin% removed_satisfaction | cntry == "AT") %>%
                    select(-cntry)}[,13:19], # %>% select(happy, stflife, frprtpl, stfdem, stfeco, stfedu, stfhlth),
                 cglcol="grey",
                 cglty=1,
                 axislabcol="grey20",
                 axistype = 5,
                 caxislabels = c(0,2,4,6,8,NA),
                 cglwd=1,
                 seg = 5,
                 pcol=colors_border,
                 pfcol=colors_in,
                 plwd=4,
                 plty=1)
      
      legend("topright",
             legend = rownames(mean_data %>%
                                 subset(cntry %nin% c(removed_satisfaction,"Max","Min") | cntry == "AT")),
             bty = "o",
             fill=colors_in,
             cex = 0.9)
    })
    
    observeEvent(input$redraw_satisfaction, {
      
      if (input$EU_check_satisfaction == T){
        removed_satisfaction <- removed_satisfaction %>% append("EU")
      }else if(input$EU_check_satisfaction == F){
        removed_satisfaction <- removed_satisfaction[removed_satisfaction != "EU"]
      }
      
      if (input$own_check_satisfaction == T){
        removed_satisfaction <- removed_satisfaction %>% append("Own response")
      }else if(input$own_check_satisfaction == F){
        removed_satisfaction <- removed_satisfaction[removed_satisfaction != "Own response"]
      }
      
      if (input$cntry_check_satisfaction == T){
        selected_cntry_satisfaction <- NA
      }else if(input$cntry_check_satisfaction == F){
        selected_cntry_satisfaction <- input$cntry_satisfaction
      }
      
      output$radar_satisfaction <- renderPlot({
        colors_border = c(rgb(0.2,0.5,0.5,0.9),
                          rgb(0.8,0.2,0.5,0.9),
                          rgb(0.7,0.5,0.1,0.9))
        
        colors_in=c(rgb(0.2,0.5,0.5,0.4),
                    rgb(0.8,0.2,0.5,0.4),
                    rgb(0.7,0.5,0.1,0.4))
        
        radarchart(df = {mean_data %>% 
                          subset(cntry %nin% removed_satisfaction | cntry == selected_cntry_satisfaction) %>% 
            select(-cntry)}[,13:19], # %>% select(happy, stflife, frprtpl, stfdem, stfeco, stfedu, stfhlth),
            cglcol="grey",
            cglty=1,
            axislabcol="grey20",
            axistype = 5,
            caxislabels = c(0,2,4,6,8,NA),
            cglwd=1,
            seg = 5,
            pcol=colors_border,
            pfcol=colors_in,
            plwd=4,
            plty=1)
        
        legend("topright",
               legend = rownames(mean_data %>%
                 subset(cntry %nin% c(removed_satisfaction,"Max","Min") | cntry == selected_cntry_satisfaction)),
               bty = "o",
               fill=colors_in,
               cex = 0.9)
      })
    })
  } # Satisfaction
  
  
  output$svyhist <- renderPlot({
    var <- input$histvar
    hdata <- input$histdata
    score <- as.numeric(input[[var]])
    
    ggplot(ess_data %>% subset(cntry %in% hdata)) +
      geom_histogram(aes(x = .data[[var]]), binwidth = 0.25, center = 0, fill = "grey50", col = "red4", size = 1) +
      geom_vline(xintercept = score, col = "blue", lwd = 2) +
      scale_x_continuous(breaks = seq(0, 10, by = 1)) +
      ylab("Number of responses") + 
      xlab(expss::recode(var, 
                         "ppltrst" ~ "Trust in people",
                         "pplfair" ~ "Fairness of people",
                         "pplhlp" ~ "Helpfulness of people",
                         "trstprl" ~ "Trust in own country's parliament",
                         "trstep" ~ "Trust in European Parliament",
                         "trstlgl" ~ "Trust in own country's legal system",
                         "imbgeco" ~ "Immigration perception (economic)",
                         "imueclt" ~ "Immigration perception (cultural)",
                         "imwbcnt" ~ "Don't know",
                         "impcntr" ~ "Immigration attitude (poorer countries outside of Europe)",
                         "imsmetn" ~ "Immigration attitude (same race)",
                         "imdfetn" ~ "Immigration attitude (different race)",
                         "happy"   ~ "General happness",
                         "stflife" ~ "Satisfaction with life",
                         "frprtpl" ~ "Don't know",
                         "stfdem"  ~ "Satisfaction with democracy",
                         "stfeco"  ~ "Satisfaction with economy",
                         "stfedu"  ~ "Satisfaction with education system",
                         "stfhlth" ~ "Satisfaction with healthcare",
                         "lrscale" ~ "Self placement on left-right scale"))
  }) # Histograms tab
  
  
  output$svybar <- renderPlot({
    bdata <- input$bardata
    
    my_data <- mean_data_long %>% subset(cntry == bdata) %>% select(-cntry)
    my_data <- my_data[, c(3, 1, 2)]
    my_data$var <- as.character(my_data$var)
    rownames(my_data) <- 1:20
    my_data$group <- c(rep("Trust", 6),rep("Immigration", 6), rep("Satisfaction & Politics", 8))
    
    empty_bar <- 5
    to_add <- data.frame( matrix(NA, empty_bar*length(unique(my_data$group)), ncol(my_data)) )
    colnames(to_add) <- colnames(my_data)
    to_add$group <- rep(levels(as.factor(my_data$group)), each=empty_bar)
    my_data <- rbind(my_data, to_add)
    my_data <- my_data %>% arrange(group)
    my_data$id <- seq(1, nrow(my_data))
    
    # Adjust variables which have different scaling
    my_data[4,"value"]  <- 3.33 * my_data[4,"value"]
    my_data[5,"value"]  <- 3.33 * my_data[5,"value"]
    my_data[6,"value"]  <- 3.33 * my_data[6,"value"]
    my_data[14,"value"] <- 2.5  * my_data[14,"value"]
    
    my_label_data <- my_data
    nbar <- nrow(my_label_data)
    my_angle <-  90 - 360 * (my_label_data$id-0.5) /nbar
    my_label_data$hjust<-ifelse( my_angle < -90, 1, 0)
    my_label_data$angle<-ifelse(my_angle < -90, my_angle+180, my_angle)
    
    # prepare a data frame for base lines
    base_data <- my_data %>% 
      group_by(group) %>% 
      summarize(start=min(id), end=max(id) - empty_bar) %>% 
      rowwise() %>% 
      mutate(title=mean(c(start, end)))
    
    # prepare a data frame for grid (scales)
    grid_data <- base_data
    grid_data$end <- grid_data$end[ c( nrow(grid_data), 1:nrow(grid_data)-1)] + 1
    grid_data$start <- grid_data$start - 1
    grid_data[1,2] <- 31
    grid_data[1,3] <- 34
    #grid_data <- grid_data[-1,]
    
    my_data$source <- "country"
    
    own_data <- my_data
    own_data$source <- "self"
    
    for (i in 1:3){
      own_data[i,"value"] <- input[[immigration_variables[i]]] %>% as.numeric()
    }
    
    for (i in 4:6){
      own_data[i,"value"] <- 3.33 * (input[[immigration_variables[i]]] %>% as.numeric())
    }
    
    for (i in 1:6){
      own_data[i + 24,"value"] <- input[[trust_variables[i]]] %>% as.numeric()
    }
    
    for (i in 1:7){
      own_data[i + 11,"value"] <- input[[satisfaction_variables[i]]] %>% as.numeric()
    }
    
    own_data[14,"value"] <- 2.5 * (input$frprtpl %>% as.numeric())
    own_data[19,"value"] <- input$lrscale %>% as.numeric()
    
    my_data1 <- rbind(my_data, own_data)
    
    for (i in 1:6){
      my_label_data[i,3] <- max(my_data1[which(my_data1$var == immigration_variables[i]),3])
    }
    
    for (i in 1:6){
      my_label_data[i + 24,3] <- max(my_data1[which(my_data1$var == trust_variables[i]),3])
    }
    
    for (i in 1:7){
      my_label_data[i + 11,3] <- max(my_data1[which(my_data1$var == satisfaction_variables[i]),3])
    }
    
    my_label_data[19,"value"] <- max(my_data1[which(my_data1$var == "lrscale"),3])
    
    p1 <- ggplot(my_data1, aes(x=as.factor(id), y=value, fill = source, color = group)) +
      geom_bar(stat="identity", alpha = 0.7, width=0.6, position = "dodge", size = 1.1) +
      # Add a val=100/75/50/25 lines. I do it at the beginning to make sure barplots are OVER it.
      geom_segment(data=grid_data, aes(x = end, y = 8, xend = start, yend = 8), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      geom_segment(data=grid_data, aes(x = end, y = 6, xend = start, yend = 6), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      geom_segment(data=grid_data, aes(x = end, y = 4, xend = start, yend = 4), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      geom_segment(data=grid_data, aes(x = end, y = 2, xend = start, yend = 2), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      
      # Add text showing the value of each 100/75/50/25 lines
      annotate("text", x = rep(max(my_data$id),4), y = c(2, 4, 6, 8), label = c("2", "4", "6", "8") , color="grey20", size=3 , angle=0, fontface="bold", hjust=1) +
      ylim(-5,11) +
      theme_minimal() +
      theme(
        legend.position = c(0.1,0.8),
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-1,4), "cm"),
        legend.title = 
      ) +
      coord_polar(start = 0) +
      geom_text(data=my_label_data, aes(x=id, y=value+0.5, label=var, hjust=hjust), color="black", 
                fontface="bold",alpha=0.6, size=4, angle= my_label_data$angle, inherit.aes = FALSE ) +
      geom_segment(data=base_data, aes(x = start, y = -1, xend = end, yend = -1), colour = "black", 
                   alpha=0.8, size=1.5 , inherit.aes = FALSE )
    
    p1
  }) # Circular barplots tab
  
  output$country_comparison_plot <- renderPlot({
    variable <- input$country_comparison_variable
    
    data <- mean_data_long[which(mean_data_long$cntry %nin% c("PA", "EU")),]
    data$cntry <- as.character(data$cntry)
    
    ggplot(data = subset(data, var == variable), mapping = aes(x = reorder(cntry, value), y = value, fill = cntry)) +
      geom_col() + 
      geom_flag(y = 0, aes(country = tolower(cntry)), size = 10) +
      scale_fill_manual(values = list("AT" = "#646C64",
                                      "BE" = "#74C19C", 
                                      "BG" = "#715865",
                                      "CH" = "#9D8572",
                                      "CY" = "#E6C65A",
                                      "CZ" = "#B06E20",
                                      "DE" = "#B4B4B4",
                                      "EE" = "#CF765E",
                                      "FI" = "#824914",
                                      "FR" = "#0F1BBB",
                                      "GB" = "#D20404",
                                      "HU" = "#BB4646",
                                      "IE" = "#067F02",
                                      "IT" = "#84A259",
                                      "NL" = "#F56414",
                                      "NO" = "#AAAAD2",
                                      "PL" = "#961717",
                                      "RS" = "#71623D",
                                      "SI" = "#93985E")) +
      
      scale_y_continuous(
        breaks = seq(0, variable_limits[[input$country_comparison_variable]][2], by = 1),
        limits = variable_limits[[input$country_comparison_variable]]) +
      theme(legend.position = "none",
            plot.title = element_text(hjust = 0.5)) +
      ggtitle(variable_questions[[input$country_comparison_variable]]) +
      xlab("Country") +
      ylab("Mean value of responses") 
    # +
    #   ylim(variable_limits[[input$country_comparison_variable]])
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("ESS9_data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(ess_data, file)
    }
  )
  
  # Left and Right Jump Buttons
  {
    observeEvent(input$radar_right, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "circular_bar_charts"
      )
    })
    
    observeEvent(input$circular_left, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "radar_charts"
      )
    })
    
    observeEvent(input$circular_right, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "histograms"
      )
    })
    
    observeEvent(input$histograms_left, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "circular_bar_charts"
      )
    })
    
    observeEvent(input$histograms_right, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "country_comparison"
      )
    })
    
    observeEvent(input$country_left, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "histograms"
      )
    })
    
    observeEvent(input$country_right, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "map_drawer"
      )
    })
    
    observeEvent(input$map_left, {
      updateTabsetPanel(
        session = session,
        inputId = "mooc_app",
        selected = "country_comparison"
      )
    })
  }
}