#  function to run eviatlas locally
eviatlas <- function(
  data, # optional dataset to display using eviatlas
  build = FALSE, # logical: should the function build an app (TRUE),
  launch = TRUE, # logical: should the function launch an app in the browser (defaults to TRUE)
  app_name = "eviatlas_app", # path to file where app should be built. Ignored if build = FALSE
  max_file_size = 100
){

  if(!missing(data)){
    eviatlas_pilotdata <- data
  }

  if(!build & !launch){
    message("eviatlas hasn't done anything, because build and launch are both FALSE")
  }else{

    # build a new app if requested
    if(build){

      # app_name <- "newapp" # FOR TESTING ONLY!!!
      if(dir.exists(app_name)){
        unlink(app_name, recursive = TRUE)
      }
      dir.create(app_name)
      dir.create(paste0(app_name, "/html"))
      dir.create(paste0(app_name, "/data"))
      # copy html and data files from the app into the relevant directories
      # build a new script containing server and ui called app.R
      # see https://shiny.rstudio.com/articles/app-formats.html
      file_list <- c(
        system.file("appfiles", "eviatlas_ui.R", package = "eviatlas"),
        system.file("appfiles", "html_call_app.R", package = "eviatlas"),
        system.file("appfiles", "eviatlas_server.R", package = "eviatlas"),
        system.file("appfiles", "html_call_app_end.R", package = "eviatlas")
      )
      build_app_scripts(file_list, app_name,
        added_text = paste0("options(shiny.maxRequestSize = ", max_file_size, " * 1024^2)"),
        added_index = 3
      )

      # move dataset
      if(missing(data)){
        invisible(file.copy(
          from = system.file("data", "pilotdata.RData", package = "eviatlas"),
          to = paste0(app_name, "/data")
        ))
      }else{
        save(
          eviatlas_pilotdata,
          file = paste0("./", app_name, "/data/pilotdata.RData"))
      }

      # move html files
      html_list <- c(
        system.file("htmlfiles", "AboutEvi.html", package = "eviatlas"),
        system.file("htmlfiles", "AboutSysMap.html", package = "eviatlas"),
        system.file("htmlfiles", "HowCiteEvi.html", package = "eviatlas"),
        system.file("htmlfiles", "HowEviWorks.html", package = "eviatlas")
      )
      lapply(html_list, function(a){
        invisible(file.copy(
          from = a,
          to = paste0(app_name, "/html/")
        ))
      })

      if(launch){ # launch newly-built app
        shiny::runApp(app_name)
      }

    }else{ # i.e. if launching locally

      # ensure html files are available for display
      htmlfiles <- c("AboutEvi.html", "AboutSysMap.html", "HowCiteEvi.html", "HowEviWorks.html")
      file_list <- lapply(htmlfiles, function(a){
        file_location <- system.file("htmlfiles", a, package = "eviatlas")
        return(readr::read_file(file_location))
      })
      names(file_list) <- c("start", "about_sysmap", "how_cite", "how_works")

      # set file size
      if(!missing(max_file_size)){
        initial_file_size <- options("shiny.maxRequestSize")
        options(shiny.maxRequestSize = max_file_size * 1024^2)
        on.exit(options(initial_file_size))
      }

      # get ui code
      source(
        system.file("appfiles", "eviatlas_ui.R", package = "eviatlas"),
        local = TRUE
      )

      # run app locally
      source(
        system.file("appfiles", "run_app_locally.R", package = "eviatlas"),
        local = TRUE
      )

    } # end if(!build)
  }
}