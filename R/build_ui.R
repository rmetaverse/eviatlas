build_ui <- function(
  title = "eviatlas",
  tabs = c("about", "atlas", "data", "insights", "heatmap")
){
  c(
    "shinydashboard::dashboardPage(
      header = shinydashboard::dashboardHeader(title = title),
      sidebar = ",
      build_ui_sidebar(tabs = tabs),
      ", body = ",
      build_ui_body(tabs = tabs),
    ")"
  )
}