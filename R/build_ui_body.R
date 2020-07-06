# function to build a UI body
# this needs two updates:
  # 1. ability to specify which tabs are added (also add to sidebar)
  # 2. ablity to specify css etc, prob via external pkg
build_ui_body <- function(
  tabs = c("about", "atlas", "data", "insights", "heatmap")
){

  tab_list_complete <- do.call(c, lapply(tabs, function(a){
    code_file <- paste0("tab_", tabs[i], ".R")
    return(readLines(
      system.file("appfiles", code_file, package = "eviatlas"),
      warn = FALSE))
  }))

  body <- c("  body <- shinydashboard::dashboardBody(
      tag('style', HTML('
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
        '
      )),
    tabItems(",
    tab_list_complete,
    "))")

  return(body)
}