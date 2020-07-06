# import scripts and create file
build_app_scripts <- function(
  ui,
  server_files,
  app_name,
  added_text,
  added_index
) {
  script_list <- lapply(server_files, function(a) {
    scan(a,
      what = "character",
      sep = "\n",
      quiet = TRUE
    )
  })
  if(!missing(added_text)) {
    index_seq <- seq_len(added_index - 1)
    script_list <- c(
      script_list[index_seq],
      added_text,
      script_list[added_index:length(script_list)]
    )
  }
  script_vector <- c(ui, do.call(c, script_list))

  # find package names
  grepl("[[:alpha:]]::", script_vector)

  # write
  utils::write.table(
    script_vector,
    paste0(app_name, "/app.R"),
    sep = "\n",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )
}
