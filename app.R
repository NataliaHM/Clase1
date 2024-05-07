
# pkgs --------------------------------------------------------------------


library(shiny)
library(tidyverse)
library(tidyquant)


# UI --------------------------------------------------------------------

# CTRL + SHIFT + R

ui <- fluidPage(

    titlePanel("Descarga de datos desde Yahoo Finance"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
            inputId = "ticket",
            label = "Escoge la serie a graficar",
            choices = c(Ethereum = "ETH-USD", 
                        Banorte = "GFNORTEO.MX", 
                        Dólar = "MXN=X"),
            selected = "MXN=X"
        ),
        dateInput(
          inputId = "fecha",
          label = "Selecciona la fecha de inicio",
          value = today() - 365,
          max = today() - 1,
          format = "dd-mm-yyyy",
          startview = "year",
          language = "es"
        )
      ),
      mainPanel(
        plotOutput(outputId = "grafica"),
        p("Esto es texto")
      )
    )
  )


# SERVER ------------------------------------------------------------------


server <- function(input, output, session) {
  output$grafica <- renderPlot({
    tq_get(
      x = input$ticket,
      get = "stock.prices",
      from = input$fecha,
      to = today() - 1
    ) |>
      ggplot(aes(x = date, y = close))+
      geom_candlestick(aes(open = open,
                           high = high,
                           low = low,
                           close = close),
                       colour_up = "dodgerblue",
                       colour_down = "orange",
                       fill_up = "darkgreen",
                       fill_down = "firebrick")+
      theme_tq_dark()
  })
}

shinyApp(ui, server)