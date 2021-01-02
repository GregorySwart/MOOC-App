prependTab(inputId = "mooc_app",
    tab = tabPanel(title = "Map Drawer", value = "map_drawer",
      fluidPage(
        fluidRow(
          column(1, offset = 3, align = "center",
                 br(),
                 actionButton(inputId = "map_left", label = "Jump Left", icon = icon("angle-double-left"))
          ),
          column(4, align = "center",
                 h1("Map Drawer", align = "center")
          ),
          column(1, align = "center",
                 br(),
                 #actionButton(inputId = "map_right", label = "Jump Right", icon = icon("angle-double-right"))
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