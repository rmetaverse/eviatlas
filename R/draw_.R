#' Create bar plot with distribution of studies over the region from lat/long info
#'
#' @param df Input dataframe
#' @param location_column Column with location information (preferably country-level or higher)
#' @return Returns a bar plot object showing counts of literature in systematic review for each location
#'
#' @author Sanita Dhaubanjar
#' @name draw_
#' @keywords SystematicReview
#'
#' @export

draw_barchart <- function(df, location_column, axis_txt_lim = 60) {

  # if df is a shapefile, remove geometry column
  if (any(class(df) == "sf")) {
    df <- sf::st_drop_geometry(df)
  }

  # Count per locations --------
  location_counts <- as.data.frame(table(df[location_column])) # table() tabulates frequency
  colnames(location_counts) <- c(location_column, "n")

  # Plot bar chart
  barchart <- ggplot2::ggplot(location_counts, aes_string(
    x = colnames(location_counts[1]),
    y = colnames(location_counts[2]),
    label = colnames(location_counts[2])
  )) +
    ggplot2::geom_bar(alpha = 0.9, stat = "identity", fill = "light green") +
    ggplot2::scale_x_discrete(labels = function(x) substr(x, 1, axis_txt_lim)) +
    ggplot2::geom_text(aes(), size = 3, nudge_y = 10) +
    ggplot2::labs(y = "# Studies") +
    ggplot2::ggtitle(paste(location_column, "frequency")) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.line = element_line(colour = "black"),
      panel.background = element_blank(),
      plot.title = element_text(hjust = .5),
      text = ggplot2::element_text(size = 14)
    )

  # Rotate xaxis label if too many
  if (nrow(location_counts) > 15) {
    barchart <- barchart + ggplot2::theme(
      axis.text.x = element_text(angle = 45, hjust = 0.95, size = 11)
    )
  }

  return(barchart)
}


#' Create heatmap from dataset
#'
#' Feed in a dataset and a plot of the correct type
#'
#' @param idata Input dataframe
#' @param selcols Numeric vector of column indices
#' @param verbose Comments
#'
#' @return Returns a heatmap object showing number of literature under different categories in user specified \code{selcols}
#'
#' @author Ezgi Tanriver-Ayder and Sanita Dhaubanjar
#' @name draw_
#' @export

draw_heatmap <- function(idata, selcols, axis_txt_lim = 60) {

  # if  df is a shapefile, remove geometry column
  if (any(class(idata) == "sf")) {
    idata <- sf::st_drop_geometry(idata)
  }


  # Convert columns to factors to allow for categorical classification for both numeric and character data -------
  tmp <- as.data.frame(sapply(idata[selcols], function(x) as.factor(x)))


  # Plot Heatmap ------
  heatmap <- tmp %>%
    dplyr::rename(listone = colnames(tmp[1]), listtwo = colnames(tmp[2])) %>%
    dplyr::count(listone, listtwo) %>%
    tidyr::complete(listone, listtwo, fill = list(n = 0)) %>%
    ggplot2::ggplot(aes(x = listone, y = listtwo, fill = n, label = n)) +
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
    ggplot2::ggtitle("Study Heatmap", subtitle = paste(selcols[2], "by", selcols[1]))

  return(heatmap)
}


#' Create Histogram from dataset
#' @name draw_
draw_histogram <- function(idata, hist_col, axis_txt_lim = 60) {
  UseMethod("draw_histogram", object = idata[hist_col][[1]])
}

draw_histogram.default <- function(idata, hist_col, axis_txt_lim = 60) {
  histogram <- ggplot2::ggplot(idata, aes_string(x = hist_col)) +
    ggplot2::geom_bar(
      alpha = 0.9,
      stat = "count",
      fill = "dodger blue"
    ) +
    ggplot2::labs(y = "Studies") +
    ggplot2::scale_x_discrete(
      name = paste(hist_col), labels = function(x) substr(x, 1, axis_txt_lim)
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.line = ggplot2::element_line(colour = "black"),
      panel.background = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(hjust = .5),
      text = ggplot2::element_text(size = 13)
    )

  # Rotate xaxis label if too many categories
  if (dplyr::n_distinct(idata[hist_col]) > 15) {
    histogram <- histogram + ggplot2::theme(
      axis.text.x = element_text(angle = 40, hjust = 0.95, size = 12)
    )
  }
  return(histogram)
}

draw_histogram.numeric <- function(idata, hist_col, axis_txt_lim = 60) {
  ggplot2::ggplot(idata, aes_string(x = hist_col)) +
    ggplot2::geom_bar(
      alpha = 0.9,
      stat = "count",
      fill = "dodger blue"
    ) +
    ggplot2::labs(y = "Studies") +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.line = ggplot2::element_line(colour = "black"),
      panel.background = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(hjust = .5),
      text = ggplot2::element_text(size = 13)
    )
}


# Map the studies included in a systematic review.

sys_map <- function(studies_data) {
  basemap <- leaflet::leaflet(studies_data,
    options = leaflet::leafletOptions(minZoom = 2)
  ) %>%
    leaflet::addTiles(layerId = "atlas_basemap")

  return(basemap)
}

sys_map_shapefile <- function(shp, popups = "") {
  leaflet::leaflet(shp) %>%
    leaflet::addTiles(layerId = "atlas_basemap") %>%
    leafem::addFeatures(
      data = shp,
      group = "atlas_shapefile",
      fillColor = "green",
      fillOpacity = 0.5,
      color = "black",
      weight = 2,
      popup = ~popups
    )
}
