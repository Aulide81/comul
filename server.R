library(xlsx)
library(estadisticos)

grafico<-function (x, dim = c(1, 2), draw = c("col.sup", "row.sup"), select) {
    X <- factor(c(rep("col", nrow(x$col$coord)), rep("row", nrow(x$row$coord)), 
        rep("col.sup", nrow(x$col.sup$coord)), rep("row.sup", 
            nrow(x$row.sup$coord))), levels = c("col", "row", 
        "col.sup", "row.sup"))
    df <- data.frame(rbind(x$col$coord, x$row$coord, x$col.sup$coord, 
        x$row.sup$coord), Puntos = X)
    limx <- c(min(df[, dim[1]]), max(df[, dim[1]]))
    limy <- c(min(df[, dim[2]]), max(df[, dim[2]]))
    if (!missing(select)) 
        df <- df[unlist(as.vector((sapply(select, function(x) grep(x, 
            rownames(df), ignore.case = T))))), ]
    df <- df[df$Puntos %in% draw, c(dim, ncol(df)), drop = F]
    plot(df[, -ncol(df), drop = F], xlim = limx, ylim = limy, 
        cex = 0, cex.axis = 0.6, cex.lab = 0.6)
    text(df[, -ncol(df), drop = F], rownames(df), cex = 1, 
        col = rainbow(nlevels(df$Puntos), v = 0.6)[as.numeric(df$Puntos)])
    abline(h = 0, v = 0, lty = 3)
}

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
      grafico(resultado()[[1]],draw=input$draw,dim=input$dim)
    }else{
      grafico(resultado()[[1]],select=input$items,draw=input$draw,dim=input$dim)
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
