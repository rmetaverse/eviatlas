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
#' @param title label to be shown in the app header
#' @param data optional data.frame to replace the default dataset
#' @param launch logical - should the app be launched once built? Defaults to TRUE
#' @return This function builds an app in the working directory.
#' @examples
#'
#' \dontrun{
#' eviatlas()
#' shiny::runApp("eviatlas_app")
#' }
#'
#' @export eviatlas

eviatlas <- function(
   name = "eviatlas_app",
   title = "eviatlas", # defaults to 'eviatlas'
   # style = "shiny", # shiny or shinydashboard - not operational
   # theme = "spacelab", - not operational
   data, # defaults to pilotdata.RData
   launch = TRUE
   # options # list of settings - not yet implemented
) {
  # set defaults, errors etc
  no_data <- missing(data)
  if (no_data) {
    data <- eviatlas_pilotdata
  }

  options <- list(
    allow_uploads = !no_data,
    upload_max = 100,
    tabs = c("about", "atlas", "data", "insightplots", "heatmap")
  )
  # note: 'atlas' was formerly 'home'
  # note: this is ignored for now as we are still in testing

  # build app structure
  if (dir.exists(name)) {
    unlink(name, recursive = TRUE)
  }
  dir.create(name)
  # dir.create(paste0(name, "/R"))
  dir.create(paste0(name, "/html"))
  dir.create(paste0(name, "/data"))
  saveRDS(data, file = paste0("./", name, "/data/pilotdata.rds"))

  # move required html files for 'about' tab
  html_list <- c(
    system.file("html_files", "AboutEvi.html", package = "eviatlas"),
    system.file("html_files", "AboutSysMap.html", package = "eviatlas"),
    system.file("html_files", "HowCiteEvi.html", package = "eviatlas"),
    system.file("html_files", "HowEviWorks.html", package = "eviatlas")
  )
  invisible(lapply(html_list, function(a) {
    file.copy(from = a, to = paste0(name, "/html/"))
  }))

  # move server.R
  file.copy(
    from = system.file("app_scripts", "server.R", package = "eviatlas"),
    to = name
  )

  # build ui.R
  # import
  ui <- readLines(
    system.file("app_scripts", "ui.R", package = "eviatlas"),
    warn = FALSE
  )
  # save ui
  utils::write.table(
    gsub(
      "paste_user_title_here",
      paste0("'", title, "'"),
      ui
    ), # update app title
    paste0(name, "/ui.R"),
    sep = "\n",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )

  if(launch){shiny::runApp(name)}

}