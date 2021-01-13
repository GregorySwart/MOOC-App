prependTab(inputId = "mooc_app",
    tab = tabPanel(title = "Map Drawer", value = "map_drawer", icon = icon("globe-europe"),
      fluidPage(
        fluidRow(
          column(1, offset = 3, align = "center",
            br(),
            actionButton(inputId = "map_left", label = "Jump Left", icon = icon("angle-double-left"))
          ),
          column(4, align = "center",
            h1("Map Drawer", align = "center")
          ),
          column(1, align = "center",
            br(),
          ),
        ),
        hr(),
        fluidRow(
          column(8, offset = 2, align = "center",
            p(textlist$map_intro)
          )
        ),
        fluidRow(
          column(10, offset = 1,
            hr()
          )
        ),
        fluidRow(align = "center",
          column(2, offset = 1,
                 selectInput(
                   inputId = "map_var",
                   label = "Select variable",
                   choices = list(
                     "Trust" =        list("Trust in people" = "ppltrst",
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
                     "Satisfaction" = list("General happiness" = "happy",
                                           "Satisfaction with life" = "stflife",
                                           "Fair chance to participate in politics" = "frprtpl",
                                           "Satisfaction with democracy" = "stfdem",
                                           "Satisfaction with economy" = "stfeco",
                                           "Satisfaction with education system" = "stfedu",
                                           "Satisfaction with healthcare" = "stfhlth"),
                     "Other" =        list("Self placement on left-right scale" = "lrscale")
                   )
                 ),
                 textOutput("map_own_response")
          ),
          column(8,
            plotOutput("map", height = 600)
          )
        ),
        br(),
        br(),
        br(),
        br(),
        br()
      )
    )
  )