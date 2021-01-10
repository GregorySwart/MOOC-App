prependTab(inputId = "mooc_app",
  tab = tabPanel(title = "Country Comparison", value = "country_comparison", icon = icon("flag"),
    fluidPage(
      fluidRow(align = "center",
        column(1, offset = 3, align = "center",
               br(),
               actionButton(inputId = "country_left", label = "Jump Left", icon = icon("angle-double-left"))
        ),
        column(4, align = "center",
               h1("Country Comparison", align = "center")
        ),
        column(1, align = "center",
               br(),
               actionButton(inputId = "country_right", label = "Jump Right", icon = icon("angle-double-right"))
        ),
      ),
      hr(),
      fluidRow(align = "center",
        column(8, offset = 2, align ="center",
          p(textlist$country_comparison_intro)
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
                 inputId = "country_comparison_variable", 
                 label = "Select a variable to display",
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
                   "Satisfaction" = list("General happness" = "happy",
                                         "Satisfaction with life" = "stflife",
                                         "Fair chance to participate in politics" = "frprtpl",
                                         "Satisfaction with democracy" = "stfdem",
                                         "Satisfaction with economy" = "stfeco",
                                         "Satisfaction with education system" = "stfedu",
                                         "Satisfaction with healthcare" = "stfhlth"),
                   "Other" =        list("Self placement on left-right scale" = "lrscale")
                 ),
               )
        ),
        column(8,
          plotOutput("country_comparison_plot")
        ),
      ),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br()
      )
    )
  )