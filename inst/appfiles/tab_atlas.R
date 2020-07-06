tabItem(
  tabName = "atlas",
  fluidRow(
    tabsetPanel(
      tabPanel("Configure Map",
               wellPanel(fluidRow(
                 column(2,
                        uiOutput("map_columns")
                 ),
                 column(4,
                        uiOutput("atlas_popups"),
                        uiOutput("atlas_link_popup")
                 ),
                 column(2,
                        uiOutput("atlas_filter"),
                        uiOutput("atlas_color_by"),
                        uiOutput("atlas_selectmap")
                 ),
                 column(2,
                        uiOutput("cluster_columns"),
                        conditionalPanel(condition = "input.map_cluster_select",
                                         uiOutput("cluster_size"))
                 ),
                 column(2,
                        textInput("map_title_select", "Atlas Title"),
                        conditionalPanel(condition = "input.sample_or_real != 'shapefile'", #doesn't work for shapefiles currently
                                         sliderInput("atlas_radius_select", "Point size",
                                                     min = 1, max = 8, value = 3,
                                                     ticks = F)))
               ))
      ),
      # tabPanel('Advanced Options',
      #          column(2,
      #                 textInput('atlas_opacity_select', 'Placeholder for Opacity'))),
      tabPanel('Save Map',
               wellPanel(
                 downloadButton(outputId = "savemap_interactive",
                                label = "Save Map (Interactive)"),
                 downloadButton(outputId = "savemap_png",
                                label = "Save Map (png)"),
                 downloadButton(outputId = "savemap_pdf",
                                label = "Save Map (PDF)"),
                 bsTooltip("savemap_interactive",
                           title = "Save an interactive HTML version of the map using the current display settings. This HTML map can then be easily hosted on your own website",
                           placement = "bottom", trigger = "hover"),
                 bsTooltip("savemap_png",
                           title = "Save a static version of the map using the current display settings.",
                           placement = "bottom", trigger = "hover"),
                 bsTooltip("savemap_pdf",
                           title = "Save a static version of the map using the current display settings.",
                           placement = "bottom", trigger = "hover")

               )))
  ),
  fluidRow(
    wellPanel(
      box(width = 15,
        # note: this section has been recoded for the package version of eviatlas
        tag("html",
          list(
            tag("head",
              list(
                tag("title", list('eviatlas')),
                tag("script", list(src = "https://rawgit.com/rowanwins/leaflet-easyPrint/gh-pages/dist/bundle.js"))
              )
            ),
            tag("style",
              list(type="text/css", "#map {height: calc(100vh - 240px) !important;}")
            ),
            tag("body",
              list(leaflet::leafletOutput("map"))
            )
          )
        )
      )
    )
  )
)