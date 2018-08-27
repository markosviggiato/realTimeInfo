### Author : Markos Viggiato
### Date : August 23rd, 2018
### Web application developed using the Shiny package: 'https://shiny.rstudio.com/'

#################

# useful packages
library("shiny")
library("shinyalert")
library("shinyBS")
library(DT)
library(ggplot2)
library("shinydashboard")

# ui object - mandatory component to build an application using Shiny package
ui <- fluidPage(
      useShinyalert(),
      
      #headerPanel("Here you can find the latest news about Donald Trump!"),
      dashboardPage(
            title = "Real Time News - Donald Trump",
            dashboardHeader(title = "Find the Latest News About Donald Trump", titleWidth = 800), 
            dashboardSidebar(selectInput(inputId = "source", label = "Select what you would like to see",
                                         choices =  c("CNN news" = "CNN news", "Tweets" = "Tweets"), selectize = TRUE, width = NULL, size = NULL),
                             actionButton("butt", "Show sentiments in tweets")),
            
            dashboardBody("Select how many entries you wish to see", dataTableOutput("result"), shinycssloaders::withSpinner(uiOutput("out")))
      )
)

# server object - mandatory component to build an application using Shiny package
server <- function(input, output) {
      
      # load scripts to crawl Twitter and CNN.com
      source("twitterCrawler.R")
      source("CNNCrawler.R")
      mytwt <- twitterCrawler()
      mycnn <- CNNCrawler()
      
      # fill the output 'topicHist' defined in the UI object
      output$out <- renderUI({
            
            # load the script that analyze the frequent terms in Trump's tweets and display the plot in a popup window
            bsModal("modal", "Sentiments in Donald Trump tweets (wait to fully load)", "butt", size = "large",
                    renderPlot({
                          source("sentiment.R")
                          sentiment()
                    }))
            
      })
      
      
      # helper function to create inputs
      shinyInput <- function(FUN, len, id, ...) {
            inputs <- character(len)
            for (i in seq_len(len)) {
                  inputs[i] <- as.character(FUN(paste0(id, i), ...))
            }
            inputs
      }
      
      # create the data frame to display the CNN article' titles    
      dfCNN <- reactiveValues(data = data.frame(
            Articles = mycnn$title,
            Actions = shinyInput(actionButton, length(mycnn$title), 'button_', label = "Read", onclick = 'Shiny.onInputChange(\"select_button\",  this.id)' ),
            stringsAsFactors = FALSE,
            row.names = 1:length(mycnn$title)
      ))
      
      # create the data frame to display the Twitter posts    
      dfTwitter <- reactiveValues(data = data.frame(
            Posts = mytwt$text,
            Actions = shinyInput(actionButton, length(mytwt$text), 'button_', label = "Read", onclick = 'Shiny.onInputChange(\"select_button\",  this.id)' ),
            stringsAsFactors = FALSE,
            row.names = 1:length(mytwt$text)
      ))
      
      # Assemble the output depending on what the user want to see (CNN news or tweets)
      output$result <- renderDataTable({
            
            if(input$source == 'CNN news')
                  dfCNN$data
            else
                  dfTwitter$data
      },
      server = FALSE, escape = FALSE, selection = 'none')
      
      # monitoring the click event
      observeEvent(input$select_button, {
            selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
            
            # define the correct url based on the option selected by the user
            if(input$source == 'CNN news')
                  url <- mycnn[selectedRow,4]
            else
                  url <- paste0("https://twitter.com/realDonaldTrump/status/",mytwt[selectedRow,8])
            
            source("webCrawler.R")
            
            # create a popup window to display the tweet
            if(input$source == 'Tweets'){
                  showModal(modalDialog(
                        title = "Donald Trump Tweet",
                        h4(mytwt[selectedRow, 1]),
                        h5("--------------------------------------"),
                        h4( tags$strong("If you want to read in the original source, please click below") ),
                        tags$a(href=url, "Read in original source!", target="_blank"), easyClose = TRUE, footer = NULL
                  ))
            }
            
            # create a popup window to display the CNN article
            else{
                  # check if there is an article title; otherwise, it corresponds to a video
                  if( is.na(webCrawler(url)[1]) ){
                        showModal(modalDialog(
                              title = "Donald Trump Related News",
                              h3("This link corresponds to a video, please watch it in the original website."),
                              h5("--------------------------------------"),
                              h4( tags$strong("If you want to watch the video in the original source, please click below") ),
                              tags$a(href=url, "Watch video in the original source!", target="_blank"), easyClose = TRUE, footer = NULL
                        ))
                  }
                  else{
                        showModal(modalDialog(
                              title = "Donald Trump News",
                              lapply(webCrawler(url)[1], function(x){h3(tags$strong(x))}),
                              lapply(webCrawler(url)[-1], h4),
                              h5("--------------------------------------"),
                              h4( tags$strong("If you want to read in the original source, please click below") ),
                              tags$a(href=url, "Read in original source!", target="_blank"), easyClose = TRUE, footer = NULL
                        ))
                  }
            }
      })
}

# to execute the app
shinyApp(ui = ui, server = server)
