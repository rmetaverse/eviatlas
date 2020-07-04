draw_heatmap <- function(idata, selcols, axis_txt_lim = 60) {

  # if  df is a shapefile, remove geometry column
  if (any(class(idata) == "sf")) {
    idata <- sf::st_drop_geometry(idata)
  }

  # Convert columns to factors to allow for categorical classification for both numeric and character data -------
  tmp <- as.data.frame(sapply(idata[selcols], function(x) as.factor(x)))
  tmp <- as.data.frame(stats::xtabs(~ tmp[[1]] + tmp[[2]]))
  colnames(tmp) <- c("listone", "listtwo", "n")

  # Plot Heatmap
  ggplot2::ggplot(
    tmp,
    aes_string(
      x = "listone",
      y = "listtwo",
      fill = "n",
      label = "n"
    )
  ) +
    ggplot2::geom_tile(alpha = 0.3, color = "grey60") +
    ggplot2::geom_text() +
    viridis::scale_fill_viridis() +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      panel.grid = element_blank(),
      text = ggplot2::element_text(size = 14),
      axis.title = ggplot2::element_text(size = 16),
      title = ggplot2::element_text(size = 18)
    ) +
    ggplot2::xlab(paste0(selcols[1])) +
    ggplot2::ylab(paste0(selcols[2])) +
    ggplot2::labs(fill = "Count") +
    # Limit axis text to a certain number of characters, so that long text doesn't ruin the chart display
    ggplot2::scale_x_discrete(labels = function(x) substr(x, 1, axis_txt_lim)) +
    ggplot2::scale_y_discrete(labels = function(x) substr(x, 1, axis_txt_lim)) +
    ggplot2::ggtitle(
      "Study Heatmap",
      subtitle = paste(selcols[2], "by", selcols[1])
    )

  # heatmap
}
