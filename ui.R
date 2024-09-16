library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
    dashboardHeader(title = "Algoritmos en la Ciencia de Datos"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Problema 1 | Solucion Cerrada", tabName = "problema_1"),
            menuItem("Problema 1 | GD ", tabName = "problema_1_2"),
            menuItem("Problema 1 | SGD ", tabName = "problema_1_3"),
            menuItem("Problema 1 | MBGD ", tabName = "problema_1_4"),
            menuItem("Problema 1 | Comparaciones", tabName = "problema_1_5")
        ) 
    ),
    dashboardBody(
        tabItems(
            tabItem("Ceros",
                    h1("Método de Newton"),
                    box(textInput("ecuacion", "Ingrese la Ecuación"),
                        textInput("initVal", "X0"),
                        textInput("Error", "Error")),
                    actionButton("nwtSolver", "Newton Solver"),
                    tableOutput("salidaTabla")),
            
            tabItem("Derivacion",
                    h1("Diferencias Finitas"),
                    box(textInput("difFinEcu", "Ingrese la Ecuación"),
                    textInput("valorX", "x"),
                    textInput("valorH", "h")),
                    actionButton("diferFinEval", "Evaluar Derivada"),
                    textOutput("difFinitOut")),
            
            tabItem("Biseccion",
                    h1("Método de Bisección"),
                    box(textInput("ecuacionBisect", "Ingrese la Ecuación"),
                        textInput("initA", "Valor de a"),
                        textInput("initB", "Valor de b"),
                        textInput("ErrorBisect", "Error"),
                        textInput("kMax", "Máximo de Iteraciones")),
                    actionButton("bisectSolver", "Resolver"),
                    tableOutput("salidaBiseccion")),

            tabItem("newton-raphson",
                    h1("Método de Newton-Raphson"),
                    box(textInput("ecuacion", "Ingrese la Ecuación"),
                        textInput("initVal", "X0"),
                        textInput("Error", "Error"),
                        textInput("kMaxNewton", "Máximo de Iteraciones")),
                    actionButton("nwtSolver", "Resolver"),
                    tableOutput("salidaTabla")),
            tabItem("problema_1",
                    h1("GD Variants | Solucion Cerrada"),
                    actionButton("p1Solver", "Resolver"),
                    tableOutput("salidap1")),
            tabItem("problema_1_2",
                    h1("GD Variants | GD"),
                    actionButton("p12Solver", "Resolver"),
                    plotOutput("plotP12"),
                    plotOutput("plotP121"),
                    plotOutput("plotP122"),
                    plotOutput("plotP123"),
                    tableOutput("salidap12")
                    ),
            tabItem("problema_1_3",
                    h1("GD Variants | SGD"),
                    actionButton("p13Solver", "Resolver"),
                    plotOutput("plotP13"),
                    plotOutput("plotP131"),
                    plotOutput("plotP132"),
                    plotOutput("plotP133"),
                    tableOutput("salidap13")
            ),
            tabItem("problema_1_4",
                    h1("GD Variants | MBGD"),
                    actionButton("p14Solver", "Resolver"),
                    plotOutput("plotP14"),
                    plotOutput("plotP141"),
                    plotOutput("plotP142"),
                    plotOutput("plotP143"),
                    plotOutput("plotP144"),
                    plotOutput("plotP145"),
                    plotOutput("plotP146"),
                    plotOutput("plotP147"),
                    plotOutput("plotP148"),
                    plotOutput("plotP149"),
                    tableOutput("salidap14")
            ),
            tabItem("problema_1_5",
                    h1("GD Variants | Comparaciones"),
                    actionButton("p15Solver", "Resolver"),
                    tableOutput("salidap15")),
            tabItem("problema_2",
                    h1("Rosenbrock's Function: f(x_1,x_2) = 100(x_2 x_1^2)^2 + (1 x_1)^2 "),
                    box(
                      textInput("X0", label = "Ingrese el vector X:", value = "0,0"),
                      numericInput("valorAlpha", label = "Valor de alpha:", value = 0.05),
                      textInput("tolerancia", label = "Ingrese el Error:", value = 0.00000001),
                      textInput("iteraciones", label = "Número máximo de iteraciones:", value = 30),
                      ),
                    actionButton("p2Solver", "Resolver"),
                    tableOutput("salidap2"),
                    plotOutput("plotGradNorm2"))
        )
    )
)
