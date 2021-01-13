fluidPage(
  fluidRow(
    column(12, align = "center",
           h1("Immigration"),
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
    column(2, align = "center",
           selectInput("cntry_immigration", "Select country",
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
                       selected = "AT"),
           checkboxInput("EU_check_immigration", label = "Hide mean of all countries"),
           checkboxInput("cntry_check_immigration", label = "Hide selected country"),
           checkboxInput("own_check_immigration", label = "Hide own response", value = T),
           actionButton("redraw_immigration", "Update plot")),
    column(1)
  ),
  fluidRow(
    hr()
  )
)