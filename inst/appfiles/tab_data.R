tabItem(
  tabName = "data",
  fluidRow(
    #dynamic filter
    column(width = 12,
      wellPanel(
       # select first filter column from fields vector
       uiOutput("filter1eval"),
       # reference a uiOutput that will offer values for first column
       uiOutput("filter1choice"),
       # offer a checkbox to allow user to select a second filter
       checkboxInput("filter2req", "Add second filter?"),
       # set further conditional panels to appear in the same fashion
       conditionalPanel(condition = 'input.filter2req',
                               uiOutput("filter2eval"),
                               uiOutput("filter2choice"),
                               checkboxInput("filter3req",
                                                    "Add third filter?")),
       conditionalPanel(condition = 'input.filter3req &
                             input.filter2req',
                               shiny::uiOutput("filter3eval"),
                               shiny::uiOutput("filter3choice")),
       uiOutput("go_button"),
       materialSwitch(
         inputId = "mapdatabase_filter_select",
         label = "Use filtered data:",
         value = FALSE,
         status = "primary"
       ),
       downloadButton('download_filtered', 'Download Filtered Data')
      )
    )
  ),
  fluidRow(
    column(12, DT::dataTableOutput("filtered_table"))
  )
)