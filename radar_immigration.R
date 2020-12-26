fluidPage(
  fluidRow(
    column(12, align = "center",
           h1("Immigration"),
           br(),
           br()
    )
  ),
  fluidRow(
    column(10, offset = 1,
           p(textlist$radar_immigration1),
           hr(),
    )
  ),
  fluidRow(
    column(1),
    column(8,
           plotOutput("radar_immigration", height = 800, width = "auto")
    ),
    # column(1,
    #        plotOutput("immigration_perception", height = 800, width = 90)
    # ),
    # column(1,
    #        plotOutput("immigration_rejection", height = 800, width = 90)
    # ),
    column(2, align = "center",
           selectInput("cntry_immigration", "Select country",
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
           #checkboxInput("SU_check_immigration", label = "Hide survey median"),
           checkboxInput("own_check_immigration", label = "Hide own score", value = T),
           actionButton("redraw_immigration", "Update plot")),
    column(1)
  ),
  fluidRow(
    hr()
  )
)