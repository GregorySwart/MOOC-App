`%nin%` <- Negate(`%in%`)

ess_slider <- function(ID, label, text = "", min = 0, max = 10, value = 0){
  fluidRow(
    column(3, offset = 1,
           sliderInput(inputId = ID, label = label,
                       min = min, max = max, value = value,
           )
    ),
    column(7,
           br(),
           br(),
           p(text)
    )
  )
}

ess_selector <- function(ID, label, text = "", choices, selected){
  fluidRow(
    column(3, offset = 1,
           selectInput(inputId = ID, label = label,
                       choices = choices,
                       selected = selected
           )
    ),
    column(7,
           br(),
           p(text)
    )
  )
}
