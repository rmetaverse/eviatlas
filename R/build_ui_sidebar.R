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
      result <- paste0(
        "menuItem('",
        info_tr$label,
        "', tabName = '",
        info_tr$tabName,
        "', icon = icon('",
        info_tr$icon,
        "'))"
      )
      if(a != max(which(tabs_present))){
        result <- paste0(result, ",")
      }
      return(result)
    })
  }else{
    stop("none of the specified tabs are available")
  }

  return(c("shinydashboard::dashboardSidebar(
    sidebarMenu(id = 'main_sidebar',",
    unlist(tab_list),
    "))"))
}
