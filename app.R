#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rmarkdown)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),

      sliderInput("rows",
                  "Table rows",
                  min = 1,
                  max = 50,
                  value = 30),
      downloadButton("downloadData", "Download Report")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      tableOutput("table")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  plot <- reactive({
    # generate bins based on input$bins from ui.R
    ggplot2::ggplot(faithful, aes(x = waiting)) +
      geom_histogram(bins = input$bins)
  })

  table <- reactive({faithful[1:input$rows, ]})

  output$distPlot <- renderPlot(plot())
  output$table <- renderTable(table())

  render_func <- function(file) {
    rmarkdown::render(input = "report.Rmd",
                      output_format = html_document(),
                      output_file = file,
                      params = list(table = table(),
                                    plot = plot()))
  }

  output$downloadData <- downloadHandler("report.html",
                                         content = render_func)
}

# Run the application
shinyApp(ui = ui, server = server)
