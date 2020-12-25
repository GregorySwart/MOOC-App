source("texts.R")

shinyUI(
  navbarPage(title = "MOOC App", id = "mooc_app", collapsible = TRUE, selected = "introduction",
    theme = shinythemes::shinytheme("sandstone"),
      {tabPanel(title = "Introduction", value = "introduction", icon = icon("chevron-circle-right"),
        fluidRow(
          column(8, offset = 2, align = "center",
            h1("Introduction", align = "center"),
            br(),
            h4(textlist$intro1, align = "center"),
            br(),
            h4(textlist$intro2, align = "center"),
            br(),
            actionButton(inputId = "end_intro", label = "Begin questionnaire")
          ),
        ),
      )}, # Introduction
    {tabPanel(title = "Data", value = "data", icon = icon("align-left"),
      p("This tabPanel is not finished yet")
    )}
  )
)