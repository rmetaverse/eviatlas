build_ui_sidebar <- function(
  tabs = c("about", "atlas", "data", "insights", "heatmap")
){
  tab_lookup <- data.frame(
    tabName = c("about", "atlas", "data", "insights", "heatmap"),
    label = c("About Eviatlas", "Evidence Atlas", "Database", "Descriptive Plots", "Heatmap"),
    icon = c("question", "map", "database", "home", "fire"),
    stringsAsFactors = FALSE
  )

  tabs_present <- tab_lookup$tabName %in% tabs
  if(any(tabs_present)){
    tab_list <- lapply(which(tabs_present), function(a){
      info_tr <- as.list(tab_lookup[a, ])
      return(
        menuItem(info_tr$label, tabName = info_tr$tabName, icon = icon(info_tr$icon))
      )
    })
  }else{
    stop("none of the specified tabs are available")
  }
  # menuItem("About eviatlas",
  #   tabName = "about",
  #   icon = icon("question")
  # ),
  # menuItem("Evidence Atlas",
  #   tabName = "atlas",
  #   icon = icon("map")
  # ),
  # menuItem("Map Database",
  #   tabName = "data",
  #   icon = icon("database")
  # ),
  # menuItem("Descriptive Plots",
  #   tabName = "insights",
  #   icon = icon("home")
  # ),
  # menuItem("Heatmap",
  #   tabName = "heatmap",
  #   icon = icon("fire")
  # )

  sidebar <- shinydashboard::dashboardSidebar(
    sidebarMenu(id = "main_sidebar",
      tab_list
    )
  )

  return(sidebar)
}
