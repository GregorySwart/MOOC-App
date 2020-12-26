fluidPage(
  fluidRow(
    column(12, align = "center",
           h1("Satisfaction"),
           br(),
           br()
    )
  ),
  fluidRow(
    column(10, offset = 1,
           p(textlist$radar_satisfaction1),
           hr(),
    )
  ),
  fluidRow(
    column(1),
    column(8,
           plotOutput("radar_satisfaction", height = 800, width = "auto")
    ),
    # column(1,
    #        plotOutput("Subjective_Satisfaction", height = 800, width = 90)
    # ),
    # column(1,
    #        plotOutput("Political_Satisfaction", height = 800, width = 90)
    # ),
    # column(1,
    #        plotOutput("Institutional_Satisfaction", height = 800, width = 90)
    # ),
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
           checkboxInput("EU_check_satisfaction", label = "Hide mean of all countries"),
           checkboxInput("cntry_check_satisfaction", label = "Hide selected country"),
           #checkboxInput("SU_check_satisfaction", label = "Hide survey median"),
           checkboxInput("own_check_satisfaction", label = "Hide own response", value = T),
           actionButton("redraw_satisfaction", "Update plot")),
    column(1)
  ),
  fluidRow(
    hr()
  )
)