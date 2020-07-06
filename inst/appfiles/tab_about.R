tabItem(
  tabName = "about",
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
    )
  )
)