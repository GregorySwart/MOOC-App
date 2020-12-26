fluidPage(
  fluidRow(
    column(12, align = "center",
           h1("Trust"),
           br()
    )
  ),
  fluidRow(
    column(10, offset = 1,
           p(textlist$radar_trust1),
           hr()
    )
  ),
  fluidRow(
    column(1),
    column(8,
           plotOutput("radar_trust", height = 800, width = "auto")
    ),
    # column(1,
    #        plotOutput("trust_indicators_individual", height = 800, width = 90)
    # ),
    # column(1,
    #        plotOutput("trust_indicators_institutional", height = 800, width = 90)
    # ),
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
           #checkboxInput("SU_check_trust", label = "Hide survey median"),
           checkboxInput("own_check_trust", label = "Hide own score", value = TRUE),
           actionButton("redraw_trust", "Update plot")),
    column(1)
  ),
  fluidRow(
    hr()
  )
)