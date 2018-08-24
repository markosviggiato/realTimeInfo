### Author : Markos Viggiato
### Date : August 24th, 2018
### Code developed using resources from 'https://github.com/susanli2016/Data-Analysis-with-R',
### by Susan Li

#################

# import of useful packages
library(tidytext)
library(syuzhet)
library(twitteR)
library(ggplot2)
library(tm)

# main function to obtain the sentiment
sentiment <- function(){
      
      # collect the 1000 most recent tweets from Donald Trump
      tweets <- userTimeline("realDonaldTrump", n = 1000)
      tweets.df <- twListToDF(tweets)
      
      # remove some special characters
      tweets.df$text <- sapply(tweets.df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
      Trump_sentiment <- get_nrc_sentiment(tweets.df$text)
      
      # bind tweets and sentiment scores
      tweets.df <- cbind(tweets.df, Trump_sentiment)
      sentiment_total <- data.frame(colSums(tweets.df[,c(17:26)]))
      names(sentiment_total) <- "count"
      sentiment_total <- cbind("sentiment" = rownames(sentiment_total), sentiment_total)
      
      # visualization of the sentiment in the tweets
      ggplot(aes(x = sentiment, y = count, fill = sentiment), data = sentiment_total) +
            geom_bar(stat = 'identity') + ggtitle('Sentiment Score for Trump Latest Tweets') + theme(legend.position = "none")

}
