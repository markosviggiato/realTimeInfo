### Author : Markos Viggiato
### Date : August 23rd, 2018
### This code makes use of CNN News API to collect data
### Powered by CNN News API (newsapi.org)

#################

# useful packages
library(newsAPI)
library("jsonlite")

# main function to search for articles
CNNCrawler <- function(){
      
      # read access keys
      secret <- read.table("secret.file", stringsAsFactors = FALSE)
      apikey <- secret[[1]][[5]]
    
      # HTTP request to the REST API - articles containing the word 'Trump'
      repoInfo <- fromJSON(paste0("https://newsapi.org/v1/articles?source=cnn&q=trump&apiKey=",apikey))
      dataCNN <- repoInfo$articles
      
      # keep only articles with keywords 'Trump' or 'trump' in the title or description
      dataCNN <- dataCNN[ which(grepl("Trump", dataCNN$title) | grepl("trump", dataCNN$title) |
                               grepl("Trump", dataCNN$description) | grepl("trump", dataCNN$description)),]

      #select the latest 25 articles
      if(length(dataCNN$title) > 25)
            dataCNN <- dataCNN[1:25,]
      
      # return the data frame with article's information
      dataCNN
}