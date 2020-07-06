tabItem(
  tabName = "insights",
  tabsetPanel(
    tabPanel('Plot Inputs',
      fluidRow(
       column(3, uiOutput("barplot_selector")),
       column(4, uiOutput("location_plot_selector"))
      ),
      fluidRow(
       materialSwitch(
         inputId = "barplots_filter_select",
         label = "Use filtered data:",
         value = FALSE,
         status = "primary"
       )
      )
    )
  ),
  wellPanel(
    plotOutput("plot1"),
    downloadButton("save_plot_1")
  ),
  wellPanel(
    plotOutput("plot2"),
    downloadButton("save_plot_2")
  )
)