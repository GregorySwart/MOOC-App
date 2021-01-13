prependTab(inputId = "mooc_app",
  tab = {tabPanel("Histograms", icon = icon("chart-bar"), value = "histograms",
    fluidPage(
      fluidRow(
        column(1, offset = 3, align = "center",
          br(),
          actionButton(inputId = "histograms_left", label = "Jump Left", icon = icon("angle-double-left"))
        ),
        column(4, align = "center",
          h1("Histograms", align = "center")
        ),
        column(1, align = "center",
          br(),
          actionButton(inputId = "histograms_right", label = "Jump Right", icon = icon("angle-double-right"))
        )
      ),
      hr(),
      fluidRow(
        column(8, offset = 2, align = "center",
          p(textlist$histograms_intro)
        )
      ),
      fluidRow(
        column(10, offset = 1,
          hr()
        )
      ),
      fluidRow(
        column(2, offset = 1, align = "center",
          selectInput("histvar", label = "Select variable", 
          choices = list("Trust" =        list("Trust in people" = "ppltrst",
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
                         "Other" =        list("Self placement on left-right scale" = "lrscale"))
          ),
          selectInput("histdata", label = "Select country",
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
          plotOutput("svyhist")
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