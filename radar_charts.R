prependTab(
  inputId = "mooc_app",
  tab = {tabPanel(title = "Radar charts", value = "radar_charts", icon = icon("certificate"),
    fluidPage(
      fluidRow(
        column(12, offset = 0, align = "center",
          fluidRow(align = "center",
            column(1, offset = 3),
            column(4, align = "center",
              h1("Radar charts"), align = "center"
            ),
            column(1, align = "center",
              br(),
              actionButton(inputId = "radar_right", label = "Jump Right", icon = icon("angle-double-right"))
            )
          ),
          hr(),
          p(textlist$radar_intro),
          br()
        )
      ),
      tabsetPanel(
        tabPanel("Overview",
          {source("radar_overview.R")}, # Overview
        ),
        tabPanel("Trust",
          {source("radar_trust.R")}, # Trust
        ),
        tabPanel("Immigration",
          {source("radar_immigration.R")}, # Immigration
        ),
        tabPanel("Satisfaction",
          {source("radar_satisfaction.R")}  # Satisfaction
        )
      )
    ),
  )} # Radar Charts
)