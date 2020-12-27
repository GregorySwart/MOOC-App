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
                                      plotOutput("svybar", height = 550)
                               )
                             )
                           )
           )})