\name{eviatlas}
\alias{eviatlas}
\title{Run a shiny app for visualising systematic map databases}
\description{Goes here
}
\usage{
eviatlas(build = FALSE, launch = TRUE,
  app_name = "eviatlas_app", max_file_size = 100)
}
\arguments{
  \item{build}{logical: Should the function build an app? Defaults to TRUE.}
  \item{launch}{logical: Should the function launch an app in the browser? Defaults to TRUE.}
  \item{app_name}{character giving the name of app to be build. Ignored if build == FALSE.}
  \item{max_file_size}{Optional argument to set the maximum file size (in MB) that the app will accept.}
}
\value{
This function launches an app in the users' browser. Optionally can also build that app in the working directory.
}
\examples{
  library(eviatlas)
  # default is launch a local version without building
  eviatlas()

  # build and launch the app
  eviatlas(build = TRUE)

  # change the app name from the default of "eviatlas_app"
  eviatlas(build = TRUE, app_name = "my_app")

  # build but not launch
  eviatlas(build = TRUE, launch = FALSE, app_name = "my_app")
  runApp("my_app") # launch the new app manually

  # run with no output of any kind
  eviatlas(build = FALSE, launch = FALSE) # returns a message, but no output
}
