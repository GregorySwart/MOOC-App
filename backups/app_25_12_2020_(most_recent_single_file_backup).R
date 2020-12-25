# import libraries

##########
# SERVER #
##########

server <- shinyServer(
  function(input, output, session) {
  
  #########################
  # Data load and cleanup #
  #########################
  
  source("libraries.R")
  source("functions.R")
  ess_data <<- as.data.frame(read_spss("ess_data.sav"))
  hardcode <- TRUE
  
  #Import data
  
  countries <<- ess_data$cntry %>% unique() %>% values2labels() %>% unclass()
  
  source("median_data.R")
  
  removed <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
               "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_trust <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                     "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_immigration <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                     "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  removed_satisfaction <- c("PA", "AT", "BE", "BG", "CH", "CY", "CZ", "DE", "EE", "FI", 
                     "FR", "GB", "HU", "IE", "IT", "NL", "NO", "PL", "RS", "SI")
  
  source("indicators.R")
  
  ready <- c("Max", "Min", "EU", "HU", "SU", "PA")
  ready_var <- c("Max", "Min", "EU", "HU", "SU")
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  {
    # BUTTON: Remove intro and add trust
    observeEvent(input$end_intro, once = TRUE, {
      insertTab(inputId = "mooc_app", target = "data",
                 tab = {
                   tabPanel(title = "Survey - Trust", value = "survey_trust", icon = icon("thumbs-up"),
                    fluidPage(
                      fluidRow(
                        column(10, offset = 1, align = "center",
                        h1("Trust", align = "center"),
                        ess_selector(ID = "ppltrst", label = "1. Trust in people",
                          choices = c("Please select..." = NA,0:10),
                          selected = "Please select...",
                          text = "Generally speaking, would you say that most people can be trusted, or that you can't 
                            be too careful in dealing with people? Please tell us on a score of 0 to 10, where 0 
                            means you can't be too careful and 10 means that most people can be trusted."),
                        ess_selector(ID = "pplfair", label = "2. Fairness of people",
                          choices = c("Please select..." = NA,0:10),
                          selected = "Please select...",
                          text = "Do you think that most people would try to take advantage of you if they got the 
                            chance, or would they try to be fair? Here 0 means people would try to take advantage of 
                            you and 10 means most people try to be fair."),
                        ess_selector(ID = "pplhlp", label = "3. Helpfulness of people",
                          choices = c("Please select..." = NA,0:10),
                          selected = "Select...",
                          text = "Would you say that most of the time people try to be helpful or that they are 
                            mostly looking out for themselves? Here 0 means most people are just looking 
                            out for themselves, while 10 means they are mostly helpful."),
                        ess_selector(ID = "trstprl", label = "4. Trust in parliament",
                          choices = c("Please select..." = NA,0:10),
                          selected = "Select...",
                          text = "Please tell us on a score of 0-10 how much you personally trust 
                            your country's parliament. 0 means you do not trust the institution at all, and 10 
                            means you have complete trust."),
                        ess_selector(ID = "trstlgl", label = "5. Trust in legal system",
                          choices = c("Please select..." = NA,0:10),
                          selected = "Select...",
                          text = "Please tell us on a score of 0-10 how much you personally trust 
                          your country's legal system. 0 means you do not trust the institution at all, and 10 
                          means you have complete trust."),
                        ess_selector(ID = "trstep", label = "6. Trust in European Parliament",
                          choices = c("Please select..." = NA,0:10),
                          selected = "Select...",
                          text = "Please tell us on a score of 0-10 how much you personally trust 
                          the European Parliament. 0 means you do not trust the institution at all, and 10 
                          means you have complete trust."),
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
    
  {
    # BUTTON: remove trust and add immigration
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
                                          text = "Would you say it is generally bad or good for your country's economy that 
                         people come to live here from other countries? (0 = bad for the economy, 10 = good 
                         for the economy)"),
                             ess_selector(ID = "imueclt", label = "8.Effect on culture",
                                          choices = c("Please select..." = NA,0:10),
                                          selected = "Please select...",
                                          text = "Would you say that your country's cultural life is generally undermined or 
                         enriched by people coming to live here from other countries? (0 = cultural life 
                         undermined, 10 = cultural life enriched)"),
                             ess_selector(ID = "imwbcnt", label = "9. Effect on country as a whole",
                                          choices = c("Please select..." = NA,0:10),
                                          selected = "Please select...",
                                          text = "Is your country made a worse or a better place to live by people coming to 
                         live here from other countries? (0 = Worse place to live, 10 = Better place to live)"),
                             
                             ess_selector(ID = "impcntr",
                                          label = "10. From poorer countries outside of Europe",
                                          choices = c("Please select..." = NA,
                                                      "Allow many to come and live here (3)" = 3,
                                                      "Allow some (2)" = 2,
                                                      "Allow a few (1)" = 1,
                                                      "Allow none (0)" = 0),
                                          text = "To what extent do you think your country should allow people from poorer countries 
                       outside of Europe to come and live here?",
                                          selected = "Please Select"),
                             ess_selector(ID = "imsmetn",
                                          label = "11. Immigrants of the same race",
                                          choices = c("Please select..." = NA,
                                                      "Allow many to come and live here (3)" = 3,
                                                      "Allow some (2)" = 2,
                                                      "Allow a few (1)" = 1,
                                                      "Allow none (0)" = 0),
                                          text = "To what extent do you think your country should allow people of the same race or 
                       ethnic group as most inhabitants to come and live here?",
                                          selected = "Please select"),
                             ess_selector(ID = "imdfetn",
                                          label = "12. Immigrants of a different race",
                                          choices = c("Please select..." = NA,
                                                      "Allow many to come and live here (3)" = 3,
                                                      "Allow some (2)" = 2,
                                                      "Allow a few (1)" = 1,
                                                      "Allow none (0)" = 0),
                                          text = "To what extent do you think your country should allow people of a different race or 
                       ethnic group as most inhabitants to come and live here?",
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
      }else{
        updateActionButton(inputId = "end_trust", session = session, 
                           label = "Please answer all of the questions to continue")
      }
    })
  } # Survey - Trust
  
  {
    # BUTTON: remove immigration and add satisfaction
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
                                                          text = "Taking all things together, how happy would you say you are? 
                       (0 = Extremely unhappy, 10 = Extremely happy)"),
                                             ess_selector(ID = "stflife", label = "14. Satisfaction with life in general",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "All things considered, how satisfied are you with your life as a whole nowadays? 
                       Please answer the slider to the left, where 0 means extremely dissatisfied and 10 means 
                       extremely satisfied."),
                                             ess_selector(ID = "frprtpl", label = "15. Political fairness",
                                                          choices = c("Please select..." = NA,0:5),
                                                          selected = "Please select...",
                                                          text = "How much would you say that the political system in country ensures that 
                       everyone has a fair chance to participate in politics? 
                       (0 = Not at all, 4 = A great deal)"),
                                             ess_selector(ID = "stfdem", label = "16. Satisfaction with democracy",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole, how satisfied are you with the way democracy works in your country? 
                       (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             ess_selector(ID = "stfeco", label = "17. Satisfaction with economy",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole how satisfied are you with the present state of the economy in your 
                       country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             ess_selector(ID = "stfedu", label = "18. Satisfaction with education",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole how satisfied are you with the present state of the education system 
                       in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
                                             ess_selector(ID = "stfhlth", label = "19. Satisfaction with healthcare",
                                                          choices = c("Please select..." = NA,0:10),
                                                          selected = "Please select...",
                                                          text = "On the whole how satisfied are you with the present state of the healthcare system 
                       in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
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
  
  {
    # BUTTON: remove Satisfaction and add Left Right Scale
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
                                                   text = "In politics people sometimes talk of 'left' and 'right'. Using this slider, where 
                       would you place yourself on this scale, where 0 means the left and 10 means the right?"),
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
  
  {
    # BUTTON: remove lrscale tab and add graphics
    observeEvent(input$submit_survey, once = FALSE, {
    state <- TRUE
    if(input$lrscale %nin% 0:10){state <- FALSE}
    if(hardcode == TRUE){state <- TRUE} # hard code to true to save time when testing
    if(state == TRUE){
      prependTab(inputId = "mooc_app", 
                 tab = {tabPanel("Histograms", icon = icon("chart-bar"),
                                 fluidPage(
                                   fluidRow(h1("Histograms of the survey data", align = "center")),
                                   hr(),
                                   fluidRow(
                                     column(8, offset = 2,
                                            p("In this section you can see the distribution of answers for each country by variable. The vertical 
                blue line shows your response. If this is missing, you haven't completed the survey section."),
                                            br(),
                                            helpText("PLAN: add survey and EU average as vertical lines as well. Add \"All countries\" button."),
                                            hr(),
                                     )
                                   ),
                                   fluidRow(
                                     column(2, offset = 1,
                                            selectInput("histvar", label = "please select a variable to display", 
                                                        choices = list("Trust" =        list("Trust in people" = "ppltrst",
                                                                                             "Fairness of people" = "pplfair",
                                                                                             "Helpfulness of people" = "pplhlp",
                                                                                             "Trust in own country's parliament" = "trstprl",
                                                                                             "Trust in European Parliament" = "trstep",
                                                                                             "Trust in own country's legal system" = "trstlgl"),
                                                                       "Immigration" =  list("Immigration perception (economic)" = "imbgeco",
                                                                                             "Immigration perception (cultural)" = "imueclt",
                                                                                             "Immigration perception (better/worse)" = "imwbcnt",
                                                                                             "Immigration attitude (poorer countries outside of Europe)" = "impcntr",
                                                                                             "Immigration attitude (same race)" = "imsmetn",
                                                                                             "Immigration attitude (different race)" = "imdfetn"),
                                                                       "Satisfaction" = list("General happness" = "happy",
                                                                                             "Satisfaction with life" = "stflife",
                                                                                             "Fair chance to participate in politics" = "frprtpl",
                                                                                             "Satisfaction with democracy" = "stfdem",
                                                                                             "Satisfaction with economy" = "stfeco",
                                                                                             "Satisfaction with education system" = "stfedu",
                                                                                             "Satisfaction with healthcare" = "stfhlth"),
                                                                       "Other" =        list("Self placement on left-right scale" = "lrscale"))
                                            ),
                                            selectInput("histdata", label = "Please select reference data frame",
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
                                                                       "Slovenia (SI)" = "SI")
                                            )
                                     ),
                                     column(6,
                                            plotOutput("svyhist")
                                     )
                                   )
                                 )
                 )}, # Histograms
                 session = session)
      prependTab(inputId = "mooc_app",
                 tab = {tabPanel("Circular bar charts",  icon = icon("adjust"),
                                 fluidPage(
                                   fluidRow(h1("Circular bar charts of the survey data", align = "center")),
                                   hr(),
                                   fluidRow(
                                     column(8, offset = 2,
                                            p("In this section you can see the mean response to each question, by country. The Variables are 
                grouped into three categories: Immigration, Trust, and Satisfaction. Self placement was added to 
                the latter to avoid having a gorup with only one variable in it."),
                                            br(),
                                            helpText("PLAN: Replace variable codes with better text, improve labeling and add dynamic title."),
                                            hr()
                                     )
                                   ),
                                   fluidRow(
                                     column(2, offset = 1,
                                            # selectInput("barvar", label = "please select a variable to display", 
                                            #             choices = list("Trust" =        list("Trust in people" = "ppltrst",
                                            #                                                  "Fairness of people" = "pplfair",
                                            #                                                  "Helpfulness of people" = "pplhlp",
                                            #                                                  "Trust in own country's parliament" = "trstprl",
                                            #                                                  "Trust in European Parliament" = "trstep",
                                            #                                                  "Trust in own country's legal system" = "trstlgl"),
                                            #                            "Immigration" =  list("Immigration perception (economic)" = "imbgeco",
                                            #                                                  "Immigration perception (cultural)" = "imueclt",
                                            #                                                  "Immigration perception (better/worse)" = "imwbcnt",
                                            #                                                  "Immigration attitude (poorer countries outside of Europe)" = "impcntr",
                                            #                                                  "Immigration attitude (same race)" = "imsmetn",
                                            #                                                  "Immigration attitude (different race)" = "imdfetn"),
                                            #                            "Satisfaction" = list("General happness" = "happy",
                                            #                                                  "Satisfaction with life" = "stflife",
                                            #                                                  "Fair chance to participate in politics" = "frprtpl",
                                            #                                                  "Satisfaction with democracy" = "stfdem",
                                            #                                                  "Satisfaction with economy" = "stfeco",
                                            #                                                  "Satisfaction with education system" = "stfedu",
                                            #                                                  "Satisfaction with healthcare" = "stfhlth"),
                                            #                            "Other" =        list("Self placement on left-right scale" = "lrscale"))
                                            # ),
                                            selectInput("bardata", label = "Please select reference data frame",
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
                                                                       "Slovenia (SI)" = "SI")
                                            )
                                     ),
                                     column(6,
                                            plotOutput("svybar", height = 800)
                                     )
                                   )
                                 )
                 )}, # Circular Bar Charts
                 session = session)
      prependTab(inputId = "mooc_app", 
                tab = {tabPanel(title = "Radar charts", value = "radar_charts", icon = icon("certificate"),
                               fluidPage(
                                 fluidRow(
                                   column(10, offset = 1, align = "center",
                                          h1("Radar charts"),
                                          br(),
                                          p("Radar chart explanation and legend goes here"),
                                   )
                                 ),
                                 tabsetPanel(
                                  tabPanel("Overview",
                                           {fluidPage(
                                             fluidRow(
                                               column(10, offset = 1, align = "center",
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
                                                      p("On the radar plot to the left you can see the weighted median values displayed for all 
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
                                  ),
                                  tabPanel("Trust",
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
                                                      checkboxInput("SU_check_trust", label = "Hide survey median"),
                                                      checkboxInput("own_check_trust", label = "Hide own score", value = TRUE),
                                                      actionButton("redraw_trust", "Update plot")),
                                               column(1)
                                             ),
                                             fluidRow(
                                               hr()
                                             )
                                           )}, # Trust
                                  ),
                                  tabPanel("Immigration",
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
                                                      selectInput("cntry_immigration", "Country",
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
                                                      checkboxInput("EU_check_immigration", label = "Hide EU median"),
                                                      checkboxInput("cntry_check_immigration", label = "Hide country median"),
                                                      checkboxInput("SU_check_immigration", label = "Hide survey median"),
                                                      checkboxInput("own_check_immigration", label = "Hide own score", value = T),
                                                      actionButton("redraw_immigration", "Update plot")),
                                               column(1)
                                             ),
                                             fluidRow(
                                               hr()
                                             )
                                           )}, # Immigration
                                  ),
                                  tabPanel("Satisfaction",
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
                                                      selectInput("cntry_satisfaction", "Select country",
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
                                                      checkboxInput("EU_check_satisfaction", label = "Hide EU median"),
                                                      checkboxInput("cntry_check_satisfaction", label = "Hide country median"),
                                                      checkboxInput("SU_check_satisfaction", label = "Hide survey median"),
                                                      checkboxInput("own_check_satisfaction", label = "Hide own score", value = T),
                                                      actionButton("redraw_satisfaction", "Update plot")),
                                               column(1)
                                             ),
                                             fluidRow(
                                               hr()
                                             )
                                           )}  # Satisfaction
                                  )
                                )
                              ),
                               
                               
                               
                               
                )},
                session = session)
      updateNavbarPage(session = session, inputId = "mooc_app",
                       selected = "radar_charts")
      removeTab(inputId = "mooc_app",
                target = "survey_lrscale",
                session = session)
    }else{
      updateActionButton(session = session,
                         inputId = "submit_survey",
                         label = "Please answer all of the questions to continue")
    }
  })
  
  } # Survey - Left Right Scale
  
  
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
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9), "SU" = rgb(0.4,0.7,0.9,0.7) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4), rgb(0.4,0.7,0.9,0.3)  )
    
    radarchart(df = median_data %>% subset(cntry %nin% removed_trust | cntry == "AT") %>% select(-cntry) %>% select(pplfair,pplhlp,trstprl,trstep,trstlgl,ppltrst), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed_trust,"Max","Min") | cntry == "AT")), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  observeEvent(input$redraw_trust, {
    
    if (input$EU_check_trust == T){
      removed_trust <- removed_trust %>% append("EU")
    }else if(input$EU_check_trust == F){
      removed_trust <- removed_trust[removed_trust != "EU"]
    }
    
    if (input$SU_check_trust == T){
      removed_trust <- removed_trust %>% append("SU")
    }else if(input$SU_check_trust == F){
      removed_trust <- removed_trust[removed_trust != "SU"]
    }
    
    if (input$own_check_trust == T){
      removed_trust <- removed_trust %>% append("PA")
    }else if(input$own_check_trust == F){
      removed_trust <- removed_trust[removed_trust != "PA"]
    }
    
    if (input$cntry_check_trust == T){
      selected_cntry_trust <- NA
    }else if(input$cntry_check_trust == F){
      selected_cntry_trust <- input$cntry_trust
    }
    
    for (i in stat_variables){
      median_data["PA",i] <- as.numeric(input[[i]])
    }
    
    output$radar_trust <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9), "SU" = rgb(0.4,0.7,0.9,0.7) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4), rgb(0.4,0.7,0.9,0.3)  )
      
      radarchart(df = median_data %>% subset(cntry %nin% removed_trust | cntry == selected_cntry_trust) %>% select(-cntry) %>% select(pplfair,pplhlp,trstprl,trstep,trstlgl,ppltrst), 
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
      
      legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed_trust,"Max","Min") | cntry == selected_cntry_trust)), bty = "o", fill=colors_in, cex = 0.9)
    })
    
    output$trust_indicators_individual <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU","PA") | cntry == selected_cntry_trust)) +
        geom_col(mapping = aes(y = Individual_Trust, x = cntry), 
                 fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                             "PA" = rgb(0.7,0.5,0.1,0.9),
                             "CO" = rgb(0.8,0.2,0.5,0.9),
                             "SU" = rgb(0.4,0.7,0.9,0.9))
        ) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
    })
    
    output$trust_indicators_institutional <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU","PA") | cntry == selected_cntry_trust)) +
        geom_col(mapping = aes(y = Institutional_Trust, x = cntry), 
                 fill =  list("EU" = rgb(0.2,0.5,0.5,0.9),
                              "PA" = rgb(0.7,0.5,0.1,0.9),
                              "CO" = rgb(0.8,0.2,0.5,0.9),
                              "SU" = rgb(0.4,0.7,0.9,0.9))) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
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
  
  
  {
  output$radar_immigration <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9), "SU" = rgb(0.4,0.7,0.9,0.7) )
    colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
    
    radarchart(df = median_data[ready,] %>% select(imbgeco,imueclt,imwbcnt,impcntr,imsmetn,imdfetn), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed_trust,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$immigration_perception <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Immigration_perception, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                           "PA" = rgb(0.7,0.5,0.1,0.9),
                           "AT" = rgb(0.8,0.2,0.5,0.9),
                           "SU" = rgb(0.4,0.7,0.9,0.9))
      ) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  output$immigration_rejection <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready_var),]) +
      geom_col(mapping = aes(y = Immigration_rejection, x = cntry), 
               fill =  list("EU" = rgb(0.2,0.5,0.5,0.9),
                            "AT" = rgb(0.8,0.2,0.5,0.9),
                            "SU" = rgb(0.4,0.7,0.9,0.9))) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  observeEvent(input$redraw_immigration, {
    
    if (input$EU_check_immigration == T){
      removed_immigration <- removed_immigration %>% append("EU")
    }else if(input$EU_check_trust == F){
      removed_immmigration <- removed_immigration[removed_immigration != "EU"]
    }
    
    if (input$SU_check_immigration == T){
      removed_immigration <- removed_immigration %>% append("SU")
    }else if(input$SU_check_immigration == F){
      removed_immigration <- removed_immigration[removed_immigration != "SU"]
    }
    
    if (input$own_check_immigration == T){
      removed_immigration <- removed_immigration %>% append("PA")
    }else if(input$own_check_immigration == F){
      removed_immigration <- removed_immigration[removed_immigration != "PA"]
    }
    
    if (input$cntry_check_immigration == T){
      selected_cntry_immigration <- NA
    }else if(input$cntry_check_immigration == F){
      selected_cntry_immigration <- input$cntry_immigration
    }
    
    for (i in stat_variables){
      median_data["PA",i] <- as.numeric(input[[i]])
    }
    
    output$radar_immigration <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9), "SU" = rgb(0.4,0.7,0.9,0.7) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )

      radarchart(df = median_data %>% subset(cntry %nin% removed_immigration | cntry == selected_cntry_immigration) %>% select(-cntry) %>% select(imbgeco,imueclt,imwbcnt,impcntr,imsmetn,imdfetn),
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)

      legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed_immigration,"Max","Min") | cntry == selected_cntry_immigration)), bty = "o", fill=colors_in, cex = 0.9)
    })
    
    output$immigration_perception <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU","PA") | cntry == selected_cntry_immigration)) +
        geom_col(mapping = aes(y = Immigration_perception, x = cntry),
                 fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                             "PA" = rgb(0.7,0.5,0.1,0.9),
                             "CO" = rgb(0.8,0.2,0.5,0.9),
                             "SU" = rgb(0.4,0.7,0.9,0.9))
        ) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
    })

    output$immigration_rejection <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU") | cntry == selected_cntry_immigration)) +
        geom_col(mapping = aes(y = Immigration_rejection, x = cntry),
                 fill =  list("EU" = rgb(0.2,0.5,0.5,0.9),
                              "CO" = rgb(0.8,0.2,0.5,0.9),
                              "SU" = rgb(0.4,0.7,0.9,0.9))) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
    })
    
  })
  } # Immigration
  
  
  {
  output$radar_satisfaction <- renderPlot({
    colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9), rgb(0.7,0.5,0.1,0.9), rgb(0.4,0.7,0.9,0.7) )
    colors_in =   c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4), rgb(0.7,0.5,0.1,0.4), rgb(0.4,0.7,0.9,0.3)  )
    
    radarchart(df = median_data[ready,] %>% select(happy, stflife, frprtpl, stfdem, stfeco, stfedu, stfhlth), 
               cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
               pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)
    
    legend("topright", legend = rownames(median_data[which(rownames(median_data) %nin% c(removed_satisfaction,"Min","Max") & rownames(median_data) %in% ready),]), bty = "o", fill=colors_in, cex = 0.9)
  })
  
  output$Subjective_Satisfaction <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Subjective_Satisfaction, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                           "PA" = rgb(0.7,0.5,0.1,0.9),
                           "HU" = rgb(0.8,0.2,0.5,0.9),
                           "SU" = rgb(0.4,0.7,0.9,0.9))
      ) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
    
  output$Political_Satisfaction <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Political_Satisfaction, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                           "PA" = rgb(0.7,0.5,0.1,0.9),
                           "HU" = rgb(0.8,0.2,0.5,0.9),
                           "SU" = rgb(0.4,0.7,0.9,0.9))
      ) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  output$Institutional_Satisfaction <- renderPlot({
    ggplot(indicators[which(rownames(indicators) %in% ready),]) +
      geom_col(mapping = aes(y = Institutional_Satisfaction, x = cntry), 
               fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                           "PA" = rgb(0.7,0.5,0.1,0.9),
                           "HU" = rgb(0.8,0.2,0.5,0.9),
                           "SU" = rgb(0.4,0.7,0.9,0.9))
      ) +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()) +
      scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
  })
  
  observeEvent(input$redraw_satisfaction, {

    if (input$EU_check_satisfaction == T){
      removed_satisfaction <- removed_satisfaction %>% append("EU")
    }else if(input$EU_check_satisfaction == F){
      removed_satisfaction <- removed_satisfaction[removed_satisfaction != "EU"]
    }

    if (input$SU_check_satisfaction == T){
      removed_satisfaction <- removed_satisfaction %>% append("SU")
    }else if(input$SU_check_satisfaction == F){
      removed_satisfaction <- removed_satisfaction[removed_satisfaction != "SU"]
    }

    if (input$own_check_satisfaction == T){
      removed_satisfaction <- removed_satisfaction %>% append("PA")
    }else if(input$own_check_satisfaction == F){
      removed_satisfaction <- removed_satisfaction[removed_satisfaction != "PA"]
    }

    if (input$cntry_check_satisfaction == T){
      selected_cntry_satisfaction <- NA
    }else if(input$cntry_check_satisfaction == F){
      selected_cntry_satisfaction <- input$cntry_satisfaction
    }

    for (i in stat_variables){
      median_data["PA",i] <- as.numeric(input[[i]])
    }

    output$radar_satisfaction <- renderPlot({
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )

    radarchart(df = median_data %>% subset(cntry %nin% removed_satisfaction | cntry == selected_cntry_satisfaction) %>% select(-cntry) %>% select(imbgeco,imueclt,imwbcnt,impcntr,imdfetn,imsmetn),
                 cglcol="grey", cglty=1, axislabcol="grey20", axistype = 5, caxislabels = c(0,2,4,6,8,NA), cglwd=1, seg = 5,
                 pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1)

      legend("topright", legend = rownames(median_data %>% subset(cntry %nin% c(removed_satisfaction,"Max","Min") | cntry == selected_cntry_satisfaction)), bty = "o", fill=colors_in, cex = 0.9)
    })
    
    output$Subjective_Satisfaction <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU","PA") | cntry == selected_cntry_satisfaction)) +
        geom_col(mapping = aes(y = Subjective_Satisfaction, x = cntry), 
                 fill = list("EU" = rgb(0.2,0.5,0.5,0.9),
                             "PA" = rgb(0.7,0.5,0.1,0.9),
                             "CO" = rgb(0.8,0.2,0.5,0.9),
                             "SU" = rgb(0.4,0.7,0.9,0.9))
        ) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
    })
    
    output$Political_Satisfaction <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU","PA") | cntry == selected_cntry_satisfaction)) +
        geom_col(mapping = aes(y = Political_Satisfaction, x = cntry), 
                 fill =  list("EU" = rgb(0.2,0.5,0.5,0.9),
                              "PA" = rgb(0.7,0.5,0.1,0.9),
                              "CO" = rgb(0.8,0.2,0.5,0.9),
                              "SU" = rgb(0.4,0.7,0.9,0.9))) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
    })
    
    
    output$Institutional_Satisfaction <- renderPlot({
      ggplot(indicators %>% subset(cntry %in% c("EU","SU","PA") | cntry == selected_cntry_satisfaction)) +
        geom_col(mapping = aes(y = Institutional_Satisfaction, x = cntry), 
                 fill =  list("EU" = rgb(0.2,0.5,0.5,0.9),
                              "PA" = rgb(0.7,0.5,0.1,0.9),
                              "CO" = rgb(0.8,0.2,0.5,0.9),
                              "SU" = rgb(0.4,0.7,0.9,0.9))) +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))
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
  })
  
  
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
    
    p1 <- ggplot(my_data, aes(x=as.factor(id), y=value, fill = group)) +
      geom_bar(stat="identity", alpha = 0.7, width=0.6) +
      # Add a val=100/75/50/25 lines. I do it at the beginning to make sur barplots are OVER it.
      geom_segment(data=grid_data, aes(x = end, y = 8, xend = start, yend = 8), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      geom_segment(data=grid_data, aes(x = end, y = 6, xend = start, yend = 6), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      geom_segment(data=grid_data, aes(x = end, y = 4, xend = start, yend = 4), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      geom_segment(data=grid_data, aes(x = end, y = 2, xend = start, yend = 2), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
      
      # Add text showing the value of each 100/75/50/25 lines
      annotate("text", x = rep(max(my_data$id),4), y = c(2, 4, 6, 8), label = c("2", "4", "6", "8") , color="grey", size=3 , angle=0, fontface="bold", hjust=1) +
      ylim(-5,10) +
      theme_minimal() +
      theme(
        legend.position = c(0.8,0.8),
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-1,4), "cm")
      ) +
      coord_polar(start = 0) +
      geom_text(data=my_label_data, aes(x=id, y=value+0.5, label=var, hjust=hjust), color="black", 
                fontface="bold",alpha=0.6, size=4, angle= my_label_data$angle, inherit.aes = FALSE ) +
      geom_segment(data=base_data, aes(x = start, y = -1, xend = end, yend = -1), colour = "black", 
                   alpha=0.8, size=1.5 , inherit.aes = FALSE )
    # geom_text(data=base_data, aes(x = title, y = -1.8, label=group), hjust=c(1,1,0), 
    #           colour = "black", alpha=0.8, size=4, fontface="bold", inherit.aes = FALSE)
    
    
    p1
  })
}
)

##################
# User Interface #
##################

ui <- shinyUI(
  navbarPage(title = "MOOC App", id = "mooc_app", collapsible = TRUE, selected = "introduction",
    theme = shinythemes::shinytheme("sandstone"),
      {tabPanel(title = "Introduction", value = "introduction", icon = icon("chevron-circle-right"),
        fluidRow(
          column(8, offset = 2, align = "center",
            h1("Introduction", align = "center"),
            br(),
            h4("Welcome to the MOOC (Massive Online Open Course) App for the Centre for Social Sciences. 
              The aim of this web app is to help visualise European attitudes towards a number of issues, 
              using data from the ninth wave of the European Social Survey (ESS9). The three main categories 
              are Trust, Immigration and Satisfaction. After answering some survey questions you will be 
              able to compare your own answers to answers given by general respondents.", align = "center"),
            br(),
            h4("Click on the button below to start the survey.", align = "center"),
            br(),
            actionButton(inputId = "end_intro", label = "Begin questionnaire")
         ),
        ),
      )}, # Introduction
      
      
      
      
      
      
    {tabPanel(title = "Data", value = "data", icon = icon("align-left"),
      p("This tabPanel is not finished yet")
    )}
  )
  
)

##############
# Launch App #
##############

shinyApp(ui = ui, server = server)