# function to determine which eviatlas functions are used in a shiny app script
detect_internal_functions <- function(data){
  # first get and add internal functions
  internal_funs <- data.frame(
    function_name = c("get_latitude_cols", "get_longitude_cols",
      "get_histogram_viable_columns", "get_link_cols",
      "sys_map_shapefile", "sys_map",
      "draw_barchart", "draw_heatmap", "draw_histogram"),
    script = c(
      rep("get_col_attributes.R", 4),
      rep("draw_sys_map.R", 2),
      "draw_barchart.R", "draw_heatmap.R", "draw_histogram.R"),
    stringsAsFactors = FALSE)

  # search data for these functions
  import_funs <- unlist(lapply(internal_funs$function_name, function(a){any(grepl(a, data))}))
  import_scripts <- sort(unique(internal_funs$script[import_funs]))
  # option 1: import whole function into app.R (works, but longhand)
  # script_list <- lapply(import_scripts, function(a){
  #   readLines(system.file("functions", a, package = "eviatlas"), warn = FALSE)
  # })
  # option 2: source those scripts instead
  script_list <- lapply(import_scripts, function(a){
    paste0("source('",
      system.file("functions", a, package = "eviatlas"),
      "')")
  })
  return(c(
    "# load internal eviatlas functions",
    unlist(script_list),
    ""
  ))
}

# function to detect which packages are used in a shiny app script
detect_packages <- function(data){
  package_lookup <- grepl("\\s[[:alnum:]]+::", data)
  if(any(package_lookup)){
    detections <- which(package_lookup)
    package_list <- lapply(detections, function(a){
      regex_tr <- gregexpr("\\s[[:alnum:]]+::", data[[a]])[[1]]
      package_tr <- substr(data[a],
        regex_tr + 1,
        regex_tr + attr(regex_tr, "match.length") - 3)
      return(package_tr)})
    # detect unique packages, including core packages shiny and shinydashboard
    packages_unique <- sort(unique(c(unlist(package_list), "shiny", "shinydashboard")))
    # remove base packages
    packages_unique <- packages_unique[!(packages_unique %in% c("utils", "grDevices"))]
    # convert to usable text
    package_text <- c(
      "# load packages",
      paste0("library(", packages_unique, ")"),
      "")
    return(package_text)
  }else{
    return("")
  }
}