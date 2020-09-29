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
    br(),
    h4(label, align = "center"),
    column(7, offset = 1,
           br(),
           p(text, align = "right")
    ),
    column(3, offset = 0,
           selectInput(inputId = ID, label = "",
                       choices = choices,
                       selected = selected
           )
    )
  )
}
