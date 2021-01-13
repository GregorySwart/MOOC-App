fluidPage(
  fluidRow(
    column(10, offset = 1, align = "center",
           h1("Overview of all variables"),
           br(),
           p(textlist$radar_overview1, align = "centered"),
           hr()
    )
  ),
  fluidRow(
    column(1, align = "center"),
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
                                       "Denmark (DK)" = "DK",
                                       "Estonia (EE)" = "EE",
                                       "Spain (ES)" = "ES",
                                       "Finland (FI)" = "FI",
                                       "France (FR)" = "FR",
                                       "United Kingdom (GB)" = "GB",
                                       "Croatia (HR)" = "HR",
                                       "Hungary (HU)" = "HU",
                                       "Ireland (IE)" = "IE",
                                       "Iceland (IS)" = "IS",
                                       "Italy (IT)" = "IT",
                                       "Lithuania (LT)" = "LT",
                                       "Latvia (LV)" = "LV",
                                       "Montenegro (ME)" = "ME",
                                       "Netherlands (NL)" = "NL",
                                       "Norway (NO)" = "NO",
                                       "Poland (PL)" = "PL",
                                       "Serbia (RS)" = "RS",
                                       "Sweden (SE)" = "SE",
                                       "Slovenia (SI)" = "SI",
                                       "Slovakia (SK)" = "SK"),
                       selected = "AT"
           ),
           checkboxInput("EU_check", label = "Hide mean of all countries"),
           checkboxInput("cntry_check", label = "Hide selected country"),
           checkboxInput("own_check", label = "Hide own response", value = TRUE),
           actionButton("redraw_radar", "Update plot"),
           hr(),
           p(textlist$radar_overview2, style = "align:justified"),
           br(),
           helpText(textlist$radar_overview3)
    ),
    column(1)
  ),
  fluidRow(
    hr()
  )
)
