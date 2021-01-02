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
          p(textlist$circular_intro),
          hr()
        )
      ),
      fluidRow(
        column(2, offset = 1,
          selectInput("bardata", label = "Please select reference data frame",
            choices = list( "Austria (AT)" = "AT",
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
      ),
      fluidRow(
        column(12, align = "center",
          br(),
          br(),
          br(),
          br(),
          br(),
          br(),
        )
      )
    )
  )}
)