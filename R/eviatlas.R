#  function to run eviatlas locally
eviatlas <- function(
  data, # optional dataset to display using eviatlas
  app_name = "eviatlas_app", # path to file where app should be built. Ignored if build = FALSE
  # allow_uploads = TRUE, # allow the user to add data
  launch = TRUE, # logical: should the function launch an app in the browser (defaults to TRUE)
  max_file_size = 100,
  # sections that exist in build_ functions, but are yet to be passed from the user
  layout # list containing entries named "tabs" and "title"
){

  if(missing(data)){
    data <- eviatlas_pilotdata
  }
  if(missing(layout)){
    layout <- list(
      tabs = c("about", "atlas", "data", "insights", "heatmap"),
      title = "eviatlas")
  }

  if (dir.exists(app_name)) {
    unlink(app_name, recursive = TRUE)
  }
  dir.create(app_name)
  dir.create(paste0(app_name, "/data"))
  # copy html and data files from the app into the relevant directories
  # build a new script containing server and ui called app.R
  # see https://shiny.rstudio.com/articles/app-formats.html

  # ui
  ui_text <- build_ui(title = layout$title, tabs = layout$tabs)

  # server and extra stuff
  file_list <- c(
    system.file("appfiles", "html_call_app.R", package = "eviatlas"),
    system.file("appfiles", "eviatlas_server.R", package = "eviatlas"),
    system.file("appfiles", "html_call_app_end.R", package = "eviatlas"))
  build_app_scripts(ui = ui_text, server_files = file_list, app_name = app_name)

  # grepl for required libraries

  # add to top of library

  # move dataset
  saveRDS(
    data,
    file = paste0("./", app_name, "/data/pilotdata.rds"))

  # if 'about' tab is requested, move required html files
  dir.create(paste0(app_name, "/html"))
  html_list <- c(
    system.file("htmlfiles", "AboutEvi.html", package = "eviatlas"),
    system.file("htmlfiles", "AboutSysMap.html", package = "eviatlas"),
    system.file("htmlfiles", "HowCiteEvi.html", package = "eviatlas"),
    system.file("htmlfiles", "HowEviWorks.html", package = "eviatlas")
  )
  invisible(lapply(html_list, function(a) {
    file.copy(from = a, to = paste0(app_name, "/html/"))}))

  if (launch) { # launch newly-built app (optional)
    shiny::runApp(app_name)
  }
}
