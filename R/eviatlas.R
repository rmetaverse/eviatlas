#' Run a shiny app for visualising systematic map databases
#'
#' eviatlas allows users to create a suite of visualisations from a database of
#' studies, including Evidence Atlases (interactive geographical maps showing
#' studies and their details over space), Heat Maps (cross tabulations of
#' categorical variables that highlight clusters and gaps in the evidence),
#' descriptive plots that help to visualise the evidence base (e.g. the number
#' of publications per year), and human-readable databases that are easily
#' filterable.
#'
#' @param data An optional data.frame to display using \code{eviatlas}
#' @param name character giving the name of app to be built
#' @return This function builds an app in the working directory.
#' @examples
#'   \dontrun{eviatlas()}
#'
#' @export eviatlas

eviatlas <- function(
  data, # defaults to pilotdata.RData
  name = "eviatlas_app"
  # options # list of settings - not yet implemented
){
  # set defaults, errors etc
  no_data <- missing(data)
  if(no_data){data <- eviatlas_pilotdata}

  options <- list(
    allow_uploads = !no_data,
    upload_max = 100,
    tabs = c("about", "atlas", "data", "insightplots", "heatmap"))
  # note: 'atlas' was formerly 'home'
  # note: this is ignored for now as we are still in testing

  # build app structure
  if (dir.exists(name)) {
    unlink(name, recursive = TRUE)
  }
  dir.create(name)
  dir.create(paste0(name, "/data"))
  saveRDS(data, file = paste0("./", name, "/data/pilotdata.rds"))

  # move required html files for 'about' tab
  dir.create(paste0(name, "/html"))
  html_list <- c(
    system.file("html_files", "AboutEvi.html", package = "eviatlas"),
    system.file("html_files", "AboutSysMap.html", package = "eviatlas"),
    system.file("html_files", "HowCiteEvi.html", package = "eviatlas"),
    system.file("html_files", "HowEviWorks.html", package = "eviatlas"))
  invisible(lapply(html_list, function(a) {
    file.copy(from = a, to = paste0(name, "/html/"))}))

  # construct app.R script
  files <- c(
    system.file("app_scripts", "ui.R", package = "eviatlas"),
    system.file("app_scripts", "server.R", package = "eviatlas"))
  result <- do.call(c, lapply(files, function(a){readLines(a, warn = FALSE)}))

  # search app.R script to work out which of the following are needed:
    # internal functions (draw_heatmap etc)
    # packages (preceeded by ::)
  # add required functions and libraries to the top of the file

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
  import_funs <- unlist(lapply(internal_funs$function_name, function(a){any(grepl(a, result))}))
  import_scripts <- sort(unique(internal_funs$script[import_funs]))
  script_list <- lapply(import_scripts, function(a){
    readLines(system.file("functions", a, package = "eviatlas"), warn = FALSE)
  })
  result <- c(do.call(c, script_list), result, "shinyApp(ui, server)")

  # then add packages
  # this order is enforced so that package calls within internal functions are included
  package_lookup <- grepl("\\s[[:alnum:]]+::", result)
  if(any(package_lookup)){
    detections <- which(package_lookup)
    package_list <- lapply(detections, function(a){
      regex_tr <- gregexpr("\\s[[:alnum:]]+::", result[[a]])[[1]]
      package_tr <- substr(result[a],
        regex_tr + 1,
        regex_tr + attr(regex_tr, "match.length") - 3)
      return(package_tr)})
    # detect unique packages, including core packages shiny and shinydashboard
    packages_unique <- sort(unique(c(unlist(package_list), "shiny", "shinydashboard")))
    # remove base packages
    packages_unique <- packages_unique[!(packages_unique %in% c("utils", "grDevices"))]
    # convert to usable text
    package_text <- paste0("library(", packages_unique, ")")
    result <- c(package_text, result)
  }

  # export to app.R
  utils::write.table(
    result,
    paste0(name, "/app.R"),
    sep = "\n",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE)

}
