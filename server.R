library(xlsx)
library(estadisticos)

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
    #filename = function() { 
      #c("Output.doc")
    #},
    #content = function(file) {
    #summary(resultado()[[1]],nbelements=Inf,ncp=input$ndim,file=file)
   #}
  
    filename = function() { 
      c("Output.xlsx")
    },
  content = function(file) {
    write.xlsx(as.data.frame(resultado()[[1]][[1]]),file,sheetName="Eigenvalue",row.names=T)
    write.xlsx(as.data.frame(resultado()[[1]][[3]]),file,append=T,sheetName="Row",row.names=T)
    write.xlsx(as.data.frame(resultado()[[1]][[4]]),file,append=T,sheetName="Col",row.names=T)
    write.xlsx(as.data.frame(resultado()[[1]][[7]]),file,append=T,sheetName="Col.Sup",row.names=T)
    write.xlsx(as.data.frame(resultado()[[1]][[6]]),file,append=T,sheetName="Row.Sup",row.names=T)
    }
  )
  
output$descarga2 <- downloadHandler(
    filename = function() { 
      c("Plot.pdf")
      },
content = function(file) {
pdf(file=file,width=7,height=5)
  if(is.null(input$items)){
      plot(resultado()[[1]],draw=input$draw,dim=input$dim)
    }else{
      plot(resultado()[[1]],select=input$items,draw=input$draw,dim=input$dim)
    }
dev.off()
})
})
