tabItem(
  tabName = "heatmap",
  fluidRow(uiOutput("heatmap_selector")),
  fluidRow(
    materialSwitch(
      inputId = "heatmap_filter_select",
      label = "Use filtered data:",
      value = FALSE,
      status = "primary"
    )
  ),
  fluidRow(
    wellPanel(
      plotOutput("heatmap", width = "100%", height = "75vh"),
      downloadButton("save_heatmap")
    )
  )
)