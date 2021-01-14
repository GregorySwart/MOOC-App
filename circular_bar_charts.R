prependTab(inputId = "mooc_app",
  tab = {tabPanel("Circular bar charts",  icon = icon("adjust"), value = "circular_bar_charts",
    fluidPage(
      fluidRow(align = "center",
        column(1, offset = 3, align = "center",
               br(),
          actionButton(inputId = "circular_left", label = "Jump Left", icon = icon("angle-double-left"))
        ),
        column(4, align = "center",
          h1("Circular bar charts", align = "center")
        ),
        column(1, align = "center",
               br(),
          actionButton(inputId = "circular_right", label = "Jump Right", icon = icon("angle-double-right"))
        )
      ),
      hr(),
      fluidRow(
        column(8, offset = 2, align = "center",
          p(textlist$circular_intro)
        )
      ),
      fluidRow(
        column(10, offset = 1,
          hr()
        )
      ),
      fluidRow(
        column(2, offset = 1, align = "center",
          selectInput("bardata", label = "Select country",
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
                                      "Slovakia (SK)" = "SK")
          )
        ),
        column(8,
          plotOutput("svybar", height = 700)
        )
      ),
      fluidRow(
        column(10, offset = 1,
          hr(),
          br(),
          br(),
          br()
        )
      )
    )
  )}
)