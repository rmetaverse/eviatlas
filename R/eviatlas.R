#  function to run eviatlas locally
eviatlas <- function(
  # data, # optional dataset to display using eviatlas. Not yet implemented
  build = FALSE, # logical: should the function build an app (TRUE),
  launch = TRUE, # logical: should the function launch an app in the browser (defaults to TRUE)
  app_name = "eviatlas_app", # path to file where app should be built
    # ignored if build = FALSE
  # allow_new_data = TRUE, # logical: can the user upload new data? Not yet implemented
  max_file_size = 100
){

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
        system.file("app_files", "eviatlas_ui.R", package = "eviatlas"),
        system.file("app_files", "html_call_app.R", package = "eviatlas"),
        system.file("app_files", "eviatlas_server.R", package = "eviatlas"),
        system.file("app_files", "html_call_app_end.R", package = "eviatlas")
      )
      build_app_scripts(file_list, app_name,
        added_text = paste0("options(shiny.maxRequestSize = ", max_file_size, " * 1024^2)"),
        added_index = 3
      )
      # move dataset
      invisible(file.copy(
        from = system.file("data", "pilotdata.RData", package = "eviatlas"),
        to = paste0(app_name, "/data")
      ))
      # move html files
      html_list <- c(
        system.file("html_files", "AboutEvi.html", package = "eviatlas"),
        system.file("html_files", "AboutSysMap.html", package = "eviatlas"),
        system.file("html_files", "HowCiteEvi.html", package = "eviatlas"),
        system.file("html_files", "HowEviWorks.html", package = "eviatlas")
      )
      lapply(html_list, function(a){
        invisible(file.copy(
          from = a,
          to = paste0(app_name, "/html/")
        ))
      })

      if(launch){ # launch newly-built app
        runApp(app_name)
      }

    }else{ # i.e. if launching locally

      # ensure html files are available for display
      html_files <- c("AboutEvi.html", "AboutSysMap.html", "HowCiteEvi.html", "HowEviWorks.html")
      file_list <- lapply(html_files, function(a){
        file_location <- system.file("html_files", a, package = "eviatlas")
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
        system.file("app_files", "eviatlas_ui.R", package = "eviatlas"),
        local = TRUE
      )

      # run app locally
      print(shinyApp(
        shinyUI(ui), # imported via ui file
        shinyServer(
          function(input, output, session){
            # html files differ between app and pkg version; load correct one here
            source(
              system.file("app_files", "html_call_pkg.R", package = "eviatlas"),
              local = TRUE
            )
            # load server script
            source(
              system.file("app_files", "eviatlas_server.R", package = "eviatlas"),
              local = TRUE
            )
          }
        ) # end shinyServer
      )) # end shinyApp

    } # end if(!build)
  }
}