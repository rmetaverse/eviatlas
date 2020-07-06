# function to build a UI body
# this needs two updates:
  # 1. ability to specify which tabs are added (also add to sidebar)
  # 2. ablity to specify css etc, prob via external pkg
build_ui_body <- function(
  tabs = c("about", "atlas", "data", "insights", "heatmap")
){

  tab_list_complete <- lapply(tabs, function(a){
    code_file <- paste0("tab_", a, ".R")
    return(source(
      system.file("appfiles", code_file, package = "eviatlas"),
      local = TRUE
    )[[1]])
  })

  # tab_list_complete <- list(
  #   source(system.file("appfiles", "tab_about.R", package = "eviatlas"), local = TRUE)[[1]],
  #   source(system.file("appfiles", "tab_atlas.R", package = "eviatlas"), local = TRUE)[[1]],
  #   source(system.file("appfiles", "tab_data.R", package = "eviatlas"), local = TRUE)[[1]],
  #   source(system.file("appfiles", "tab_insights.R", package = "eviatlas"), local = TRUE)[[1]],
  #   source(system.file("appfiles", "tab_heatmap.R", package = "eviatlas"), local = TRUE)[[1]]
  # )

  body <- shinydashboard::dashboardBody(
    tag("style", HTML("
      .right-side {
      background-color: #dbf0ee;
      }
      .skin-blue .main-header .logo {
      background-color: #4FB3A9;
      color: #ffffff;
      }
      .skin-blue .main-header .logo:hover {
      background-color: #2d6c66;
      }
      .skin-blue .main-header .navbar {
      background-color: #4FB3A9;
      }
      .skin-blue .main-header .sidebar-toggle {
      background-color: #2d6c66;
      }
      "
    )),
    do.call(tabItems, tab_list_complete)
  )

  return(body)
}