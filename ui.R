source("texts.R")

shinyUI(
  navbarPage(title = "MOOC App", id = "mooc_app", collapsible = TRUE, selected = "introduction",
    theme = shinythemes::shinytheme("sandstone"),
    {tabPanel(title = "Introduction", value = "introduction", icon = icon("play-circle"),
      shinyalert::useShinyalert(),
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
      fluidPage(
        fluidRow(
          column(8, offset = 2, align = "center",
            h1("Data and Information"),
            br(),
            p(textlist$data1),
            hr()
          ),
          column(8, offset = 2, align = "center",
            h3("Download the dataset used"),
            br(),
            p(textlist$data2, tags$a(href="https://www.europeansocialsurvey.org/", "https://www.europeansocialsurvey.org/")),
            br(),
            downloadButton(outputId = "downloadData", label = "Download .csv"),
            hr()
          ),
          column(8, offset = 2, align = "center",
            h3("Changes made to variable scaling"),
            br(),
            p(textlist$data3),
            br(),
            p(textlist$data4),
            hr()
          )
        ),
        fluidRow(
          column(8, offset = 2, align = "center",
            helpText("MOOC App 1.0 developed and designed by Gregory Swart")
          )
        )
      )
    )}
  )
)