### Author : Markos Viggiato
### Date : August 23rd, 2018

#################

library("shiny")
library("shinyalert")

# ui object
ui <- fluidPage(
    useShinyalert(),

        headerPanel("The lastest information about Donald Trump!"),

        sidebarPanel(selectInput(inputId = "source", label = "Select what you wish to see",
                                             choices =  c("CNN news" = "CNN news",
                                                          "Tweets" = "Tweets"),
                                             selectize = TRUE, width = NULL, size = NULL)),

        mainPanel("Click on the item you wish to see",
                  dataTableOutput("result")
        )


)
# 
# server <- function(input, output) {
#     source("twitterCrawler.R")
#     source("CNNCrawler.R")
#     mytwt <- twitterCrawler()
#     mycnn <- CNNCrawler()
#     
#     observeEvent(input$preview, {
#         # Show a modal when the button is pressed
#         shinyalert("Oops!", "show text")
#     })
#     
#     output$result <- renderDataTable(
#         
#         if(input$source == 'Tweets'){
#             #url <- a(mytwt$text, href=paste0("https://twitter.com/realDonaldTrump/status/", mytwt$id))
#             #as.data.frame(mytwt$text)
#             data <- character(length(mytwt$text))
#             data[1] <- a(mytwt$text[1], href=paste0("https://twitter.com/realDonaldTrump/status/", mytwt$id[1]))
#             as.data.frame(data)
#             
#         }
#         else{
#             url <- a(mycnn$title, href=mycnn$url)
#             tagList("URL link:", url)
#             #as.data.frame(mycnn$title)
#         }
#     )
#     
# }
# 
server <- function(input, output) {
    source("twitterCrawler.R")
    source("CNNCrawler.R")
    mytwt <- twitterCrawler()
    mycnn <- CNNCrawler()
    
    output$result <- renderDataTable({
        if(input$source == 'CNN news'){
            my_table <- cbind(mycnn[,4], mycnn[,5])
            View(my_table)
            colnames(my_table) <- c("Title", "URL")
            #my_table$link <- sprintf('<a href=%s" target="_blank" class="btn btn-primary">Info</a>',as.data.frame(my_table$url))
            #my_table$link <- a("info", href="https://edition.cnn.com/2018/08/23/politics/trump-flipping-outlawed/index.html")
            return(my_table)
        }
        else{
            #url <- a(mytwt$text, href=mycnn$url)
            #tagList("URL link:", url)
            datatwet <- as.data.frame(mytwt$text)
            colnames(datatwet) <- "Post"
            return(datatwet)
        }
    }, escape = FALSE)
}

shinyApp(ui = ui, server = server)


# library(shiny)
# 
# createLink <- function(val) {
#     sprintf('<a href="https://www.google.com/#q=%s" target="_blank" class="btn btn-primary">Info</a>',val)
# }
# 
# ui <- fluidPage(  
#     titlePanel("Table with Links!"),
#     sidebarLayout(
#         sidebarPanel(
#             h4("Click the link in the table to see
#          a google search for the car.")
#         ),
#         mainPanel(
#             dataTableOutput('table1')
#         )
#     )
# )
# 
# server <- function(input, output) {
#     
#     output$table1 <- renderDataTable({
#         
#         my_table <- cbind(rownames(mtcars), mtcars)
#         colnames(my_table)[1] <- 'car'
#         my_table$link <- createLink(my_table$car)
#         return(my_table)
#         
#     }, escape = FALSE)
# }
# 
# shinyApp(ui, server)