## ui.R ##
library(shinydashboard)

easyprint_js_file <- "https://rawgit.com/rowanwins/leaflet-easyPrint/gh-pages/dist/bundle.js"

sidebar <- shinydashboard::dashboardSidebar(

  sidebarMenu(id = "main_sidebar",
    menuItem("About eviatlas", tabName = "about",
             icon = icon("question")),
    menuItem("Evidence Atlas", tabName = "home",
             icon = icon("map")),
    menuItem("Map Database", tabName = "data",
             icon = icon("database")),
    menuItem("Descriptive Plots", tabName = "insightplots",
             icon = icon("home")),
    menuItem("Heatmap", tabName = "heatmap",
             icon = icon("fire")),
    menuItem("View Code",
             href = "https://github.com/rmetaverse/eviatlas",
             icon = icon("github"))
  )
)

# note: this section has been recoded for the package version of eviatlas
home <- tag("html",
  list(
    tag("head",
      list(
        tag("title", list('eviatlas')),
        tag("script", list(src=easyprint_js_file))
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

body <- shinydashboard::dashboardBody(
  tag("style", HTML("
    .right-side {
    background-color: #dbf0ee;
    }
    .skin-blue .main-header .logo {
    background-color: #4FB3A9;
    color: #ffffff;
    }
    .skin-blue .main-header .logo:hover {
    background-color: #2d6c66;
    }
    .skin-blue .main-header .navbar {
    background-color: #4FB3A9;
    }
    .skin-blue .main-header .sidebar-toggle {
    background-color: #2d6c66;
    }
    "
  )),
  tabItems(
    tabItem(tabName = "about",
            fluidRow(
              mainPanel(wellPanel(
                tabsetPanel(
                  tabPanel(title = 'About eviatlas', htmlOutput("start_text")),
                  tabPanel(title = 'About systematic maps', htmlOutput("about_sysmap_text")),
                  tabPanel(title = 'How to use eviatlas', htmlOutput("how_works_text")),
                  tabPanel(title = 'How to cite eviatlas', htmlOutput("how_cite_text"))
                )),
                wellPanel(tabsetPanel(
                  tabPanel(title = 'Data Attributes', htmlOutput("uploaded_attributes"),
                           tableOutput("data_summary"))
                ))
              ),
              #Sidebar panel for inputs
              sidebarPanel(
                tabsetPanel(
                  tabPanel(
                    title = "Upload Data",
                    radioButtons(
                      "sample_or_real",
                      label = h4("Which Data to Use?"),
                      choices = list(
                        "Sample Data" = "sample",
                        "Upload from .csv format (spreadsheet)" = "user",
                        "Upload from .shp format (shapefile)" = "shapefile"
                      ),
                      selected = "user"
                    ),
                    bsTooltip("sample_or_real",
                              title = "Select whether you want to try eviatlas using the sample data from a recent systematic map, or whether you wish to upload your own data in the correct format",
                              placement = "left",
                              trigger = "hover"
                    ),
                    conditionalPanel(
                      condition = "input.sample_or_real == 'user'",

                      # Input: Select a file ----
                      fluidRow(
                        fileInput(
                          "sysmapdata_upload",
                          label = "Choose CSV File",
                          multiple = FALSE,
                          accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv"),
                          placeholder = "Systematic Map Data (100 MB Limit)"
                        )),

                      fluidRow(
                        column(12,
                               wellPanel(
                               h5(strong("CSV Properties")),
                               # Input: Checkbox if file has header ----
                               checkboxInput("header", "Header row?", TRUE),

                               selectInput("upload_encoding",
                                           label = "Select File Encoding",
                                           choices = list("Default" = "",
                                                          "UTF-8",
                                                          "latin1",
                                                          "mac"),
                                           selected = ""
                               ),
                               # Input: Select separator ----
                               selectInput("sep",
                                            "Field Separator",
                                            choices = c(
                                              ",",
                                              ";",
                                              Tab = "\t",
                                              '|'
                                            ),
                                            selected = ","
                               ),
                               # Input: Select quotes ----
                               selectInput(
                                 "quote",
                                 "Quote Delimiter",
                                 choices = c(
                                   None = "",
                                   '"',
                                   "'"
                                 ),
                                 selected = '"'
                               ))))
                    )),
                  conditionalPanel(condition = "input.sample_or_real == 'shapefile'",
                                   fluidRow(column(
                                     12,
                                     fileInput(
                                       'shape',
                                       'Select all files associated with the shapefile (.shp, .dbf, .sbn, .sbx, .shx, .cpg, .prj)',
                                       multiple = TRUE,
                                       accept = c('.shp', '.dbf', '.sbn', '.sbx', '.shx', '.prj', '.cpg'),
                                       placeholder = "Select All Data Files At Once"
                                     )
                                   ))
                  )
                )
              ))
    ),

    tabItem(tabName = "home",
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
                box(width = 15, home)
              )
            )
    ),

    tabItem(
      tabName = "data",
      fluidRow(
        #dynamic filter
        column(width = 12,
               wellPanel(
                 # select first filter column from fields vector
                 uiOutput("filter1eval"),
                 # reference a uiOutput that will offer values for first column
                 uiOutput("filter1choice"),
                 # offer a checkbox to allow user to select a second filter
                 checkboxInput("filter2req", "Add second filter?"),
                 # set further conditional panels to appear in the same fashion
                 conditionalPanel(condition = 'input.filter2req',
                                         uiOutput("filter2eval"),
                                         uiOutput("filter2choice"),
                                         checkboxInput("filter3req",
                                                              "Add third filter?")),
                 conditionalPanel(condition = 'input.filter3req &
                                       input.filter2req',
                                         shiny::uiOutput("filter3eval"),
                                         shiny::uiOutput("filter3choice")),
                 uiOutput("go_button"),
                 materialSwitch(
                   inputId = "mapdatabase_filter_select",
                   label = "Use filtered data:",
                   value = FALSE,
                   status = "primary"
                 ),
                 downloadButton('download_filtered', 'Download Filtered Data')
               ))
        ),
      fluidRow(
        column(12,
               DT::dataTableOutput("filtered_table")
        )
      )
    ),
    tabItem(tabName = "insightplots",
            tabsetPanel(
              tabPanel('Plot Inputs',
                       fluidRow(
                         column(3, uiOutput("barplot_selector")),
                         column(4, uiOutput("location_plot_selector"))
                       ),
                       fluidRow(
                         materialSwitch(
                           inputId = "barplots_filter_select",
                           label = "Use filtered data:",
                           value = FALSE,
                           status = "primary"
                         )
                       ))
            ),
            wellPanel(
              plotOutput("plot1"),
              downloadButton("save_plot_1")
            ),
            wellPanel(
              plotOutput("plot2"),
              downloadButton("save_plot_2")
            )
    ),
    tabItem(tabName = "heatmap",
            fluidRow(
              uiOutput("heatmap_selector")),
              fluidRow(
                materialSwitch(
                inputId = "heatmap_filter_select",
                label = "Use filtered data:",
                value = FALSE,
                status = "primary"
              )
            ),
            fluidRow(
              wellPanel(
                plotOutput("heatmap", width = "100%", height = "75vh"),
                downloadButton("save_heatmap")
              )
            )
    )
  )
  )


ui <- shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "eviatlas"),
  sidebar,
  body
)
