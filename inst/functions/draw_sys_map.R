# Map the studies included in a systematic review.

sys_map <- function(studies_data) {

  basemap <- leaflet::leaflet(studies_data,
    options = leaflet::leafletOptions(minZoom = 2)) %>%
    leaflet::addTiles(layerId = "atlas_basemap")

  return(basemap)
}

sys_map_shapefile <- function(shp, popups = "") {

  leaflet::leaflet(shp) %>%
    leaflet::addTiles(layerId = "atlas_basemap") %>%
    leafem::addFeatures(data = shp,
      group = 'atlas_shapefile',
      fillColor = "green",
      fillOpacity = 0.5,
      color = "black",
      weight = 2,
      popup = ~popups)
}

