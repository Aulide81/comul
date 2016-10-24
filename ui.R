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
                                downloadButton("descarga","Descargar"),
                                width=2
                              ),
                              mainPanel(
                                mainPanel(
                                plotOutput('plot1', width ="1500",height = "900px"),
                                textOutput("ruta")
                              )
                            )
                   )
                   
)
)


# Filters<-rbind(Filters,xlsx=c("Excel files (*.xlsx,*xls)","*.xlsx;*xls" ))
# dir<-choose.files(filters = Filters[c("xlsx"),])
# wb<-loadWorkbook(dir)
# hojas<-names(getSheets(wb))
# archivo<-list(dir=dir,hojas=hojas)
# rm(Filters,dir,wb,hojas)
# ls()
# 
# archivo[[2]]
# for(i in 1:length(input$hojas)){
# assign(paste0("tabla",i),read.xlsx(archivo[[1]],sheetName=input$hojas[i]))
# }
# 
# lista<-list()
# inputhojas<-archivo[[2]]
# for(i in 1:length(inputhojas)){
#   #assign(paste0("tabla",i),read.xlsx(archivo[[1]],sheetName=inputhojas[i]))
#   lista<-c(lista,list(read.xlsx(archivo[[1]],sheetName=inputhojas[i])))
# }
# lista<-lapply(lista,function(k){
#   rownames(k)<-k[,1]
#   k<-k[,-1]})
# resultado<-plot(comul(lista))
# resultado<-comul(lista)
# ls(resultado)
# summary(resultado)
# resultado$eig
# resultado$col.sup
