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
  name = "eviatlas_app",
  data # defaults to pilotdata.RData
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
  dir.create(paste0(name, "/R"))
  dir.create(paste0(name, "/html"))
  dir.create(paste0(name, "/data"))
  saveRDS(data, file = paste0("./", name, "/data/pilotdata.rds"))

  # move required html files for 'about' tab
  html_list <- c(
    system.file("html_files", "AboutEvi.html", package = "eviatlas"),
    system.file("html_files", "AboutSysMap.html", package = "eviatlas"),
    system.file("html_files", "HowCiteEvi.html", package = "eviatlas"),
    system.file("html_files", "HowEviWorks.html", package = "eviatlas"))
  invisible(lapply(html_list, function(a) {
    file.copy(from = a, to = paste0(name, "/html/"))}))

  # move server.R and ui.R into place
  file.copy(
    from = system.file("app_scripts", "server.R", package = "eviatlas"),
    to = name)
  file.copy(
    from = system.file("app_scripts", "ui.R", package = "eviatlas"),
    to = name)

  # construct server.R script
  # files <- c(
  #   system.file("app_scripts", "ui_upgrade_test.R", package = "eviatlas"),
  #   system.file("app_scripts", "server_upgrade_test.R", package = "eviatlas"))
  # result <- do.call(c, lapply(files, function(a){readLines(a, warn = FALSE)}))
  result <- readLines(
    system.file("app_scripts", "server.R", package = "eviatlas"),
    warn = FALSE)

  # search app.R script to work out which internal functions (draw_heatmap etc) are needed
  # result <- c(
  #   detect_internal_functions(result),
  #   result,
  #   "shinyApp(ui, server)")
  # New method: add required .R files
  add_internal_functions(result, name)

  # search for package names (i.e. preceeding ::) and
  # add required functions and libraries to the top of the file
  # this order is enforced so that package calls within internal functions are included
  result <- c(detect_packages(name), result)

  # export to app.R
  utils::write.table(
    result,
    paste0(name, "/server.R"),
    sep = "\n",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE)

}
