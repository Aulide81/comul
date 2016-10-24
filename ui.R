library(xlsx)
library(estadisticos)

shinyUI(
  fluidPage(theme="slate.css",
    titlePanel(title=div("Comul by",img(src="logo.png",height = 35, width = 100,hspace=15)),
                   windowTitle = "Comul"),
                    sidebarLayout(
                              sidebarPanel(
                                actionButton("archivo","Cargar Archivo"),
                                br(),
                                br(),
                                selectInput("hojas","",choices=c(""),multiple=T),
                                actionButton("compute","Compute!"),
                                br(),
                                br(),
                                checkboxGroupInput("draw","Draw",
                                                   choices=c("Col"="col",
                                                             "Row"="row",
                                                             "Col.Sup"="col.sup",
                                                             "Row.Sup"="row.sup"),
                                                   selected = c("col.sup","row.sup"),
                                                   inline = FALSE),
                                selectInput("items","",choices=c(""),multiple=T),
                                br(),
                                sliderInput("dim","Dim Draw",min=1,max=10,value=c(1,2)),
                                br(),
                                numericInput("ndim", "Numero Dimensiones", 2, min = 1,width =100),
                                downloadButton("descarga","Dimensiones"),
                                downloadButton("descarga2","Gráfico"),
                                width=2
                              ),
                              mainPanel(
                                mainPanel(
                                plotOutput('plot1', width ="1500",height = "870px"),
                                textOutput("ruta")
                              )
                            )
                   )
                   
)
)
