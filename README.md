# eviatlas

eviatlas is an R package for visualising the datasets produced by systematic maps. It is the package version of the EviAtlas app, which you can access at <a href="https://estech.shinyapps.io/eviatlas/">https://estech.shinyapps.io/eviatlas/</a>.

eviatlas was produced as part of the  <a href="https://www.eshackathon.org">Evidence Synthesis Hackathon</a> series. It was created by and for the open-source research community. Pull requests and suggestions for future improvements are welcome.

You can download it using the following code:
``` r
# install.packages("devtools")
devtools::install_github("mjwestgate/eviatlas")
```

## Usage
This package has only one function, called eviatlas. In default mode, it launches the eviatlas app in the browser, running locally on your machine:
``` r
eviatlas()
```

Alternatively, you can use eviatlas to build an app that you can launch yourself, or push to a server such as <a href="https://www.shinyapps.io">shinyapps.io</a>:
``` r
eviatlas(build = TRUE) # builds and launches by default

# change the app name from the default of "eviatlas_app"
eviatlas(build = TRUE, app_name = "my_app")

# build but not launch
eviatlas(build = TRUE, launch = FALSE, app_name = "my_app")
runApp("my_app") # launch the new app manually
# install.packages("rsconnect") # to push to shinyapps.io
# ?deployApp

# run with no output of any kind
eviatlas(build = FALSE, launch = FALSE) # returns a message, but no output
```

By default, eviatlas accepts file sizes up to 100 MB, but you can increase (or decrease) this using the 'max_file_size' argument:
``` r
eviatlas(max_file_size = 200)
```

## Further development
The eviatlas function is intended to take two further arguments:
- 'data' will allow users to add their own data to the app from the command line.
- 'allow_new_data' will allow users to disable the upload function, meaning that users could deploy eviatlas apps for a specific project.

These features should be available soon.

### Dependencies
dplyr, stringr, DT, ggplot2, leaflet, htmltools, htmlwidgets, shiny, shinydashboard, shinyWidgets, viridis, mapview, leafem, RColorBrewer, shinyBS

## Citation
If you use eviatlas in your work, please cite it as follows:

Haddaway NR, Feierman A, Grainger M, Gray C, Tanriver-Ayder E, Dhaubanjar S, Westgate M. <i>eviatlas: a tool for visualising evidence synthesis databases</i>. Environmental Evidence. 2019; 8:22. <a href="https://doi.org/10.1186/s13750-019-0167-1">https://doi.org/10.1186/s13750-019-0167-1</a>