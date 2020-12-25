shinyUI(
  navbarPage(title = "MOOC App", id = "mooc_app", collapsible = TRUE, selected = "introduction",
             theme = shinythemes::shinytheme("sandstone"),
             {tabPanel(title = "Introduction", value = "introduction", icon = icon("chevron-circle-right"),
                       fluidRow(
                         column(8, offset = 2, align = "center",
                                h1("Introduction", align = "center"),
                                br(),
                                h4("Welcome to the MOOC (Massive Online Open Course) App for the Centre for Social Sciences. 
              The aim of this web app is to help visualise European attitudes towards a number of issues, 
              using data from the ninth wave of the European Social Survey (ESS9). The three main categories 
              are Trust, Immigration and Satisfaction. After answering some survey questions you will be 
              able to compare your own answers to answers given by general respondents.", align = "center"),
                                br(),
                                h4("Click on the button below to start the survey.", align = "center"),
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