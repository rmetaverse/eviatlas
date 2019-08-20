# run app locally
print(shinyApp(
  shinyUI(ui), # imported via ui file
  shinyServer(
    function(input, output, session){
      # html files differ between app and pkg version; load correct one here
      source(
        system.file("appfiles", "html_call_pkg.R", package = "eviatlas"),
        local = TRUE
      )
      # load server script
      source(
        system.file("appfiles", "eviatlas_server.R", package = "eviatlas"),
        local = TRUE
      )
    }
  ) # end shinyServer
)) # end shinyApp