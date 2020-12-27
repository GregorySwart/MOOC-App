prependTab(
  inputId = "mooc_app",
  tab = {tabPanel(title = "Radar charts", value = "radar_charts", icon = icon("certificate"),
    fluidPage(
      fluidRow(
        column(10, offset = 1, align = "center",
          h1("Radar charts"),
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