### Author : Markos Viggiato
### Date : August 23rd, 2018
### This code makes use of Twitter API to collect data

#################

# useful packages
library("twitteR")

# main function to collect tweets from Donald Trump
twitterCrawler <- function(){
    
      # read access keys
      secret <- read.table("secret.file", stringsAsFactors = FALSE)
      consumer_key <- secret[[1]][[1]]
      consumer_secret <- secret[[1]][[2]]
      access_token <- secret[[1]][[3]]
      access_secret <- secret[[1]][[4]]
    
      # setup authentication information
      setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
    
      # get the 25 most recent tweets from the user specified n the first argument of 'userTimeline'
      tw <- userTimeline("realDonaldTrump", n = 25)
    
      # convert to dataframe
      dataTwitter = twitteR::twListToDF(tw)
    
      # return the data frame with the 25 latest tweets
      dataTwitter
}