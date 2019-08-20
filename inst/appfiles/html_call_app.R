# load library
library(eviatlas)
# this appears to work if eviatlas is installed on your computer

# load data
load("data/pilotdata.RData")

# load text in html files
start_text <- readr::read_file("html/AboutEvi.html")
about_sysmap_text <- readr::read_file("html/AboutSysMap.html")
how_works_text <- readr::read_file("html/HowEviWorks.html")
how_cite_text <- readr::read_file("html/HowCiteEvi.html")

server <- function(input, output, session){

  # # if no data are available but input$sample_or_real == 'sample', show intro text
  output$start_text <- renderPrint({
    cat(start_text)
  })
  output$about_sysmap_text <- renderPrint({
    cat(about_sysmap_text)
  })
  output$how_works_text <- renderPrint({
    cat(how_cite_text)
  })
  output$how_cite_text <- renderPrint({
    cat(how_cite_text)
  })