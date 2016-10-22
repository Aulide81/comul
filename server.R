library(xlsx)
library(estadisticos)

#shinyServer(function(input, output, session) {

#sdasdas
# archivo<-eventReactive(input$archivo,{
#   Filters<-rbind(Filters,xlsx=c("Excel files (*.xlsx,*xls)","*.xlsx;*xls" ))
#   dir<-choose.files(filters = Filters[c("xlsx"),])
#   wb<-loadWorkbook(dir)
#   hojas<-names(getSheets(wb))
#   list(dir=dir,hojas=hojas)
# 
# })
# 
# observe({
#   updateSelectInput(session, "hojas",
#                     label = "Seleccionar hoja(s)",
#                     choices = archivo()$hojas
#   )
# })
# 
# tablas<-eventReactive(input$hojas,{
# lista<-list()
# for(i in 1:length(input$hojas)){
#   lista<-c(lista,list(read.xlsx(archivo()[[1]],sheetName=input$hojas[i])))
# }
# 
# lista<-lapply(lista,function(k){
#   rownames(k)<-k[,1]
#   k<-k[,-1]})
# })
# 
# 
# resultado<-eventReactive(input$compute,{
#    comul(tablas(),sufix=input$hojas)
#    })
# 
# observe({
#   updateSelectInput(session, "items",
#                     label = "Seleccionar item(s)",
#                     choices =c(rownames(tablas()[[1]]),names(tablas()[[1]])),
#                     select =c(rownames(tablas()[[1]]),names(tablas()[[1]]))
#   )
# })
# 
# 
# output$ruta<-renderText(paste("Archivo Cargado:",archivo()$dir))
# output$plot1<-renderPlot({
#   if(is.null(input$items)){
#     plot(resultado(),draw=input$draw)
#   }else{
#     plot(resultado(),select=input$items,draw=input$draw)
#   }
# })


#})

shinyServer(function(input, output, session) {  
  
  archivo<-eventReactive(input$archivo,{
    Filters<-rbind(Filters,xlsx=c("Excel files (*.xlsx,*xls)","*.xlsx;*xls" ))
    dir<-choose.files(filters = Filters[c("xlsx"),])
    wb<-loadWorkbook(dir)
    hojas<-names(getSheets(wb))
    list(dir=dir,hojas=hojas)

  })

  observe({
    updateSelectInput(session, "hojas",
                      label = "Seleccionar hoja(s)",
                      choices = archivo()$hojas
    )
  })

  resultado<-eventReactive(input$compute,{
    lista<-list()
    for(i in 1:length(input$hojas)){
      lista<-c(lista,list(read.xlsx(archivo()[[1]],sheetName=input$hojas[i])))
    }

    lista<-lapply(lista,function(k){
      rownames(k)<-k[,1]
      k<-k[,-1]})
    items<-c(rownames(lista[[1]]),names(lista[[1]]))

    list(comul(lista,sufix=input$hojas),items)
  })

  observe({
    updateSelectInput(session, "items",
                      label = "Seleccionar item(s)",
                      choices =resultado()[[2]],
                      select =resultado()[[2]]
    )
  })

 output$ruta<-renderText(paste("Archivo Cargado:",archivo()$dir))
  output$plot1<-renderPlot({
    if(is.null(input$items)){
      plot(resultado()[[1]],draw=input$draw,dim=input$dim)
    }else{
      plot(resultado()[[1]],select=input$items,draw=input$draw,dim=input$dim)
    }
  })
  
  
  
output$descarga <- downloadHandler(
    filename = function() { 
      c("Output.doc")
    },
    content = function(file) {
    summary(resultado()[[1]],nbelements=Inf,ncp=input$ndim,file=file)
   }
  )
})

