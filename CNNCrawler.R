### This code makes use of CNN News API to collect data
### Author : Markos Viggiato
### Date : August 23rd, 2018
### Powered by CNN News API (newsapi.org)

#################

# package to access CNN News API and to make the http requests
library(newsAPI)
library("jsonlite")

CNNCrawler <- function(){
    
    # read access keys
    secret <- read.table("secret.file", stringsAsFactors = FALSE)
    apikey <- secret[[1]][[5]]
    
    # HTTP request to teh REST API
    repoInfo <- fromJSON(paste0("https://newsapi.org/v2/top-headlines?sources=cnn&q=Trump&apiKey=", apikey))
    d <- repoInfo$articles
    d <- d[d$source$name=="CNN",]
    d
    
}