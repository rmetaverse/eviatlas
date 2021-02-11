## ui.R ##
# NOTE: this code isn't current yet, but is intended to:
  # 1. optionally update the default layout to a version based on shiny::navbarPage
  # 2. allow custom theme specification via bslib
  
library(leaflet)
library(shinyWidgets)
library(bslib)

easyprint_js_file <- "https://rawgit.com/rowanwins/leaflet-easyPrint/gh-pages/dist/bundle.js"

ui <- fluidPage(
  navbarPage(paste_user_title_here,
  theme = bs_theme(paste_bslib_theme_here),
  tabPanel()

# shinydashboard code below

header <- dashboardHeader(title = paste_user_title_here)

sidebar <- dashboardSidebar(

  # sidebarUserPanel("EviAtlas Nav"),
  sidebarMenu(id = "main_sidebar",
    menuItem("About EviAtlas", tabName = "about",
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


home <- tags$html(
  tags$head(
    tags$title(paste_user_title_here),
    tags$script(src=easyprint_js_file)
  ),
  tags$style(type="text/css",
             "#map {height: calc(100vh - 240px) !important;}"),
  tags$body(
    leafletOutput("map")
  )
)

body <- dashboardBody(
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
                    ")),
  tabItems(
    tabItem(tabName = "about",
            fluidRow(
              mainPanel(wellPanel(
                tabsetPanel(
                  tabPanel(title = 'About EviAtlas', htmlOutput("start_text")),
                  tabPanel(title = 'About Systematic Maps', htmlOutput("about_sysmap_text")),
                  tabPanel(title = 'How to Use EviAtlas', htmlOutput("how_works_text")),
                  tabPanel(title = 'How to Cite EviAtlas', htmlOutput("how_cite_text"))
                )),
                wellPanel(tabsetPanel(
                  tabPanel(title = 'Data Attributes', htmlOutput("uploaded_attributes"),
                           tableOutput("data_summary"))
                ))
              ),
              sidebar_inputs()
            )
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
                           shinyBS::bsTooltip("savemap_interactive",
                                     title = "Save an interactive HTML version of the map using the current display settings. This HTML map can then be easily hosted on your own website",
                                     placement = "bottom", trigger = "hover"),
                           shinyBS::bsTooltip("savemap_png",
                                     title = "Save a static version of the map using the current display settings.",
                                     placement = "bottom", trigger = "hover"),
                           shinyBS::bsTooltip("savemap_pdf",
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
                 shiny::uiOutput("filter1eval"),
                 # reference a uiOutput that will offer values for first column
                 shiny::uiOutput("filter1choice"),
                 # offer a checkbox to allow user to select a second filter
                 shiny::checkboxInput("filter2req", "Add second filter?"),
                 # set further conditional panels to appear in the same fashion
                 shiny::conditionalPanel(condition = 'input.filter2req',
                                         shiny::uiOutput("filter2eval"),
                                         shiny::uiOutput("filter2choice"),
                                         shiny::checkboxInput("filter3req",
                                                              "Add third filter?")),
                 shiny::conditionalPanel(condition = 'input.filter3req &
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

ui <- shinyUI(
  dashboardPage(
    header,
    sidebar,
    body
  ))
