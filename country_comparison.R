prependTab(inputId = "mooc_app",
  tab = tabPanel(title = "Country Comparison", value = "country_comparison",
    fluidPage(
      fluidRow(
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
        )
      ),
      fluidRow(align = "center",
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        p("This tab is still under development.")
      )
    )
  )
)