# DATA TAB
library(eviatlas)

# if no data are available but input$sample_or_real == 'sample', show intro text
output$start_text <- renderPrint({
  cat(file_list$start)
})
output$about_sysmap_text <- renderPrint({
  cat(file_list$about_sysmap)
})
output$how_works_text <- renderPrint({
  cat(file_list$how_works)
})
output$how_cite_text <- renderPrint({
  cat(file_list$how_cite)
})
