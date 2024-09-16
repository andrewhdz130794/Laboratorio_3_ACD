
library(shiny)
library(reticulate)
library(ggplot2)
library(dplyr)
library(tidyr)


np <- import("numpy")

source_python("lab3.py")

#tableOut, soluc = newtonSolverX(-5, "2x^5 - 3", 0.0001)

shinyServer(function(input, output) {
    
    #Evento y evaluación de metodo de newton para ceros
    newtonCalculate<-eventReactive(input$nwtSolver, {
        inputEcStr<-input$ecuacion[1]
        print(inputEcStr)
        initVal<-input$initVal[1]
        error<-input$Error[1]
        #outs<-add(initVal, error)
        outs<-newtonSolverX(initVal, inputEcStr, error)
        outs
    })
    
    #Evento y evaluación de diferencias finitas
    diferFinitCalculate<-eventReactive(input$diferFinEval, {
        inputEcStr<-input$difFinEcu[1]
        valX<-input$valorX[1]
        h<-input$valorH[1]
        outs<-evaluate_derivate_fx(inputEcStr, valX, h)
        as.character(outs)
    })
    
    
    #REnder metodo de Newton
    output$salidaTabla<-renderTable({
        newtonCalculate()
    })
    
    #Render Diferncias Finitas
    output$difFinitOut<-renderText({
        diferFinitCalculate()
    })
    
    # Evento y evaluación de método de Bisección
    bisectionCalculate <- eventReactive(input$bisectSolver, {
      inputEcStr <- input$ecuacionBisect[1]
      initA <- input$initA[1]
      initB <- input$initB[1]
      error <- input$ErrorBisect[1]
      k_max <- input$kMax[1]
      
      outs <- bisectionSolverX(initA, initB, inputEcStr, error, k_max)
      outs
    })
    
    # Render método de Bisección
    output$salidaBiseccion <- renderTable({
      bisectionCalculate()
    })
    
    newtonCalculate <- eventReactive(input$nwtSolver, {
      inputEcStr <- input$ecuacion[1]
      initVal <- input$initVal[1]
      error <- input$Error[1]
      k_max <- input$kMaxNewton[1]
      
      outs <- newtonSolverX(initVal, inputEcStr, error, k_max)
      outs
    })
    
    # Render método de Newton-Raphson
    output$salidaTabla <- renderTable({
      newtonCalculate()
    })
    
    ############# Problema 1 ######################
    problem1_solver <- eventReactive(input$p1Solver, {
      
      outs <- py$closed_form_solution()
      
      return(outs)
    })
    
    output$salidap1 <- renderTable({
      problem1_solver()
    })
    
    
    ############# Problema 1.2 ######################
    problem1_2_solver <- eventReactive(input$p12Solver, {
      
      outs <- py$executeGd()
      
      return(outs)
    })
    
    output$salidap12 <- renderTable({
      problem1_2_solver()
    })
    
    output$plotP12 <- renderPlot({
      results <- problem1_2_solver()
      
      results_long <- results %>%
        pivot_longer(cols = starts_with("Iter_"), names_to = "Iter", values_to = "Iter_value") %>%
        pivot_longer(cols = starts_with("f_x_"), names_to = "f_x", values_to = "f_x_value") %>%
        pivot_longer(cols = starts_with("Learning_rate_"), names_to = "Learning_rate", values_to = "Learning_rate_value")
      
      results_long <- results_long %>%
        mutate(Iter = as.numeric(gsub("Iter_", "", Iter)),
               f_x = as.numeric(gsub("f_x_", "", f_x)),
               Learning_rate = as.numeric(gsub("Learning_rate_", "", Learning_rate))) %>%
        filter(Iter == f_x & Iter == Learning_rate) %>%
        select(-Iter, -f_x, -Learning_rate)
      
      ggplot(results_long, aes(x = Iter_value, y = f_x_value, color = as.factor(Learning_rate_value))) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    
    
    output$plotP121 <- renderPlot({
      results <- problem1_2_solver()
      ggplot(results, aes(x = Iter_1, y = f_x_1)) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones LR = 0.00005",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    output$plotP122 <- renderPlot({
      results <- problem1_2_solver()
      ggplot(results, aes(x = Iter_2, y = f_x_2)) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones LR = 0.0005",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    output$plotP123 <- renderPlot({
      results <- problem1_2_solver()
      ggplot(results, aes(x = Iter_3, y = f_x_3)) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones LR = 0.0007",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    
    ############# Problema 1.3 ######################
    problem1_3_solver <- eventReactive(input$p13Solver, {
      
      outs <- py$executeSGd()
      
      return(outs)
    })
    
    output$salidap13 <- renderTable({
      problem1_3_solver()
    })
    
    output$plotP13 <- renderPlot({
      results <- problem1_3_solver()
      
      # Convertimos los datos a un formato largo para ggplot
      results_long <- results %>%
        pivot_longer(cols = starts_with("Iter_"), names_to = "Iter", values_to = "Iter_value") %>%
        pivot_longer(cols = starts_with("f_x_"), names_to = "f_x", values_to = "f_x_value") %>%
        pivot_longer(cols = starts_with("Learning_rate_"), names_to = "Learning_rate", values_to = "Learning_rate_value")
      
      # Extraemos el índice de cada columna para emparejar los valores
      results_long <- results_long %>%
        mutate(Iter = as.numeric(gsub("Iter_", "", Iter)),
               f_x = as.numeric(gsub("f_x_", "", f_x)),
               Learning_rate = as.numeric(gsub("Learning_rate_", "", Learning_rate))) %>%
        filter(Iter == f_x & Iter == Learning_rate) %>%
        select(-Iter, -f_x, -Learning_rate)
      
      ggplot(results_long, aes(x = Iter_value, y = f_x_value, color = as.factor(Learning_rate_value))) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    
    
    output$plotP131 <- renderPlot({
      results <- problem1_3_solver()
      ggplot(results, aes(x = Iter_1, y = f_x_1)) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones LR = 0.0005",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    output$plotP132 <- renderPlot({
      results <- problem1_3_solver()
      ggplot(results, aes(x = Iter_2, y = f_x_2)) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones LR = 0.005",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    output$plotP133 <- renderPlot({
      results <- problem1_2_solver()
      ggplot(results, aes(x = Iter_3, y = f_x_3)) +
        geom_line() +
        geom_point() +
        labs(title = "Valor de la función objetivo vs Iteraciones LR = 0.01",
             x = "Iteraciones", y = "f(x)",
             color = "Learning Rate") +
        theme_minimal()
    })
    
    ############# Problema 1.4 ######################
    
    
    
    
    output$plotGradNorm <- renderPlot({
      results <- problem1_solver()
      
      if (!is.null(results)) {
        plot(results$Iter, results$P_grad, type = "b", col = "blue", 
             xlab = "Iteraciones", ylab = "Norma del Gradiente", 
             main = "Comportamiento del Gradiente vs k")
      }
    })
    
    problem2_solver <- eventReactive(input$p2Solver, {
      vectorx <- as.numeric(unlist(strsplit(gsub("\\s", "", input$X0), ",")))
      alpha <- as.numeric(input$valorAlpha)
      tolerancia <- as.numeric(input$tolerancia)
      iteraciones <- as.integer(input$iteraciones)
      
      outs <- gradient_descent_rosenbrock(vectorx, alpha, tolerancia, iteraciones)
      outs
    })
    
    output$salidap2 <- renderTable({
      problem2_solver()
    })
    
    output$plotGradNorm2 <- renderPlot({
      results <- problem2_solver()
      
      if (!is.null(results)) {
        plot(results$Iter, results$P_grad, type = "b", col = "blue", 
             xlab = "Iteraciones", ylab = "Norma del Gradiente", 
             main = "Comportamiento del Gradiente vs k")
      }
    })
    
    
})
