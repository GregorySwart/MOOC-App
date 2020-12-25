prependTab(
  inputId = "mooc_app",
  tab = tabPanel(title = "Radar charts", value = "radar_charts", icon = icon("certificate"),
         fluidPage(
           fluidRow(
             column(10, offset = 1, align = "center",
                    h1("Radar charts"),
                    br(),
                    p(textlist$radar_intro),
                    br()
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
                                 checkboxInput("EU_check", label = "Hide mean of all countries"),
                                 checkboxInput("cntry_check", label = "Hide selected country"),
                                 checkboxInput("own_check", label = "Hide own response", value = TRUE),
                                 actionButton("redraw_radar", "Update plot"),
                                 hr(),
                                 p(textlist$radar_overview1, style = "align:justified"),
                                 br(),
                                 helpText(textlist$radar_overview2)
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
         
         
         
           )
)