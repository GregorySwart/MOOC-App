tabPanel("Survey",
         {fluidPage(
           h1("Demographics", align = "center"),
           p("Reactive demographics comparison is not yet implemented.", align = "center"),
           br(),
           br(),
           ess_slider(ID = "agea", label = "Age",
                      text = "Please enter your age in years."),
           ess_selector(ID = "gndr",
                        label = "Gender",
                        choices = c("Female", "Male", "Other"),
                        text = "Please select your gender.",
                        selected = "Female"),
           ess_selector(ID = "eisced",
                        label = "Please select your education level",
                        choices = c("ES-ISCED I , less than lower secondary" = 1,
                                    "ES-ISCED II, lower secondary" = 2,
                                    "ES-ISCED IIIb, lower tier upper secondary" = 3,
                                    "ES-ISCED IIIa, upper tier upper secondary" = 4,
                                    "ES-ISCED IV, advanced vocational, sub-degree" = 5,
                                    "ES-ISCED V1, lower tertiary education, BA level" = 6,
                                    "ES-ISCED V2, higher tertiary education, >= MA level" = 7),
                        text = "Please select your highest achieved education level.",
                        selected = 1),
           fluidRow(
             h1("Trust", align = "center"),
             br(),
             br(),
             br(),
             ess_slider(ID = "ppltrst", label = "Trust in people",
                        text = "Generally speaking, would you say that most people can be trusted, or that you can't 
                            be too careful in dealing with people? Please tell us on a score of 0 to 10, where 0 
                            means you can't be too careful and 10 means that most people can be trusted."),
             ess_slider(ID = "pplfair", label = "Fairness of people",
                        text = "Do you think that most people would try to take advantage of you if they got the 
                             chance, or would they try to be fair? Here 0 means people would try to take advantage of 
                             you and 10 means most people try to be fair."),
             ess_slider(ID = "pplhlp", label = "Helpfulness of people",
                        text = "Would you say that most of the time people try to be helpful or that they are 
                             mostly looking out for themselves? Here 0 means most people are just looking 
                             out for themselves, while 10 means they are mostly helpful."),
             ess_slider(ID = "trstprl", label = "Trust in parliament",
                        text = "Please tell us on a score of 0-10 how much you personally trust 
                             your country's parliament. 0 means you do not trust the institution at all, and 10 
                             means you have complete trust."),
             ess_slider(ID = "trstlgl", label = "Trust in legal system",
                        text = "Please tell us on a score of 0-10 how much you personally trust 
                     your country's legal system. 0 means you do not trust the institution at all, and 10 
                     means you have complete trust."),
             ess_slider(ID = "trstep", label = "Trust in European Parliament",
                        text = "Please tell us on a score of 0-10 how much you personally trust 
                     the European Parliament. 0 means you do not trust the institution at all, and 10 
                     means you have complete trust.")
           ),
           fluidRow(
             h1("Immigration attitudes", align = "center"),
             br(),
             br(),
             br(),
             
             ess_slider(ID = "imbgeco", label = "Effect on economy",
                        text = "Would you say it is generally bad or good for your country's economy that 
                     people come to live here from other countries? (0 = bad for the economy, 10 = good 
                     for the economy)"),
             ess_slider(ID = "imueclt", label = "Effect on culture",
                        text = "Would you say that your country's cultural life is generally undermined or 
                     enriched by people coming to live here from other countries? (0 = cultural life 
                     undermined, 10 = cultural life enriched)"),
             ess_slider(ID = "imwbcnt", label = "Effect on country as a whole",
                        text = "Is your country made a worse or a better place to live by people coming to 
                     live here from other countries? (0 = Worse place to live, 10 = Better place to live)"),
             
             ess_selector(ID = "impcntr",
                          label = "From poorer countries outside of Europe",
                          choices = c("Allow many to come and live here (3)" = 3,
                                      "Allow some (2)" = 2,
                                      "Allow a few (1)" = 1,
                                      "Allow none (0)" = 0),
                          text = "To what extent do you think your country should allow people from poorer countries 
                   outside of Europe to come and live here?",
                          selected = 0),
             ess_selector(ID = "imsmetn",
                          label = "Immigrants of the same race",
                          choices = c("Allow many to come and live here (3)" = 3,
                                      "Allow some (2)" = 2,
                                      "Allow a few (1)" = 1,
                                      "Allow none (0)" = 0),
                          text = "To what extent do you think your country should allow people of the same race or 
                   ethnic group as most inhabitants to come and live here?",
                          selected = 0),
             ess_selector(ID = "imdfetn",
                          label = "Immigrants of a different race",
                          choices = c("Allow many to come and live here (3)" = 3,
                                      "Allow some (2)" = 2,
                                      "Allow a few (1)" = 1,
                                      "Allow none (0)" = 0),
                          text = "To what extent do you think your country should allow people of a different race or 
                   ethnic group as most inhabitants to come and live here?",
                          selected = 0)
           ),
           fluidRow(
             h1("Satisfaction", align = "center"),
             br(),
             br(),
             br(),
             ess_slider(ID = "happy", label = "General happiness",
                        text = "Taking all things together, how happy would you say you are? 
                     (0 = Extremely unhappy, 10 = Extremely happy)"),
             ess_slider(ID = "stflife", label = "Satisfaction with life in general",
                        text = "All things considered, how satisfied are you with your life as a whole nowadays? 
                     Please answer the slider to the left, where 0 means extremely dissatisfied and 10 means 
                     extremely satisfied."),
             ess_slider(ID = "frprtpl", label = "Political fairness", max = 4,
                        text = "How much would you say that the political system in country ensures that 
                     everyone has a fair chance to participate in politics? 
                     (0 = Not at all, 4 = A great deal)"),
             ess_slider(ID = "stfdem", label = "Satisfaction with democracy",
                        text = "On the whole, how satisfied are you with the way democracy works in your country? 
                     (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
             ess_slider(ID = "stfeco", label = "Satisfaction with economy",
                        text = "On the whole how satisfied are you with the present state of the economy in your 
                     country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
             ess_slider(ID = "stfedu", label = "Satisfaction with education",
                        text = "On the whole how satisfied are you with the present state of the education system 
                     in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
             ess_slider(ID = "stfhlth", label = "Satisfaction with healthcare",
                        text = "On the whole how satisfied are you with the present state of the healthcare system 
                     in your country? (0 = Extremely dissatisfied, 10 = Extremely satisfied)"),
             br(),
             h3("Placement on political scale", align = "center"),
             br(),
             ess_slider(ID = "lrscale", label = "Placement on left-right scale",
                        text = "In politics people sometimes talk of 'left' and 'right'. Using this slider, where 
                     would you place yourself on this scale, where 0 means the left and 10 means the right?"),
             column(3, offset = 1,
                    # sliderInput("lrscale", label = "Placement on left-right scale",
                    #             min = 0, max = 10, value = 0,
                    # )
             )
           ),
           fluidRow(align = "center",
                    actionButton("submit_survey", label = "Submit responses"),
                    br(),
                    br(),
                    br(),
                    br()
           ),
           fluidRow(
             column(4, offset = 4,
                    h4("Please note", align = "center"),
                    p("To view your results in comparison to other survey participants, the EU population 
              and various countries' populations, you will have to uncheck the \"Hide own responses\" 
              checkbox, and update the plots in the \"Radar charts\" tab.", align = "center"),
                    br(),
                    br(),
                    br(),
                    br()
             )
           )
         )} # Survey
)