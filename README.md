# Real Time News

<a href="https://edition.cnn.com/" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/b/b1/CNN.svg" alt="CNN" title="CNN" width=90 height=90></a>  <a href="https://twitter.com/" target="_blank"><img src="https://seeklogo.com/images/T/twitter-2012-negative-logo-5C6C1F1521-seeklogo.com.png" alt="Twitter" title="Twitter" width=90 height=90></a>



This is a real time web application developed in R to collect the latest information related to Donald Trump from CNN and Twitter.

Please use the following link to access the application: <a href="https://viggiato.shinyapps.io/real_time_news/" rel="external" target="_blank">Real Time News</a>

## Features

* Track what is new about Donald Trump. Access the news from the most recent ones to the oldest ones.
* Check the title of the 25 latest articles from CNN (or less if the 25 are not available). In addition, it is possible to read the article in the original website from CNN.
* Check the 25 latest tweets posted by Donald Trump. Also, it is possible to be redirected to the original post in Twitter.com.
* Check a cool sentiment analysis regarding the tweets from Mr. Trump. It is possible to see how many tweets lie within each sentiment, such as *fear*, *sadness*, *anger* and *trust*. For this analysis, the last 1000 tweets are analyzed.
* (Available soon) Check which topics are more frequent in Trump tweets. For instance, it is possible to check whether the latest tweets are related to economy, health or education. For this analysis, the last 1000 tweets are analyzed.

## Sentiment Analysis
Sentiment analysis is a recent field and has received much attention from researchers and practitioners. Despite the several challenges (e.g., identify sarcasm and irony), at this moment it is possible to identify many sentiments with relative ease.

This application relies on a third party R package developed to perform text mining, named *tm* (https://cran.r-project.org/web/packages/tm/index.html). Furthermore, a base code (https://github.com/susanli2016/Data-Analysis-with-R) was used to support the development of this feature in the application. 

In order to graphically see the sentiments, the user must click on the 'Show sentiments in tweets' button and wait for a popup window to load the graph. Then, it is possible to see the distribution of the sentiments. In this application, the following sentiments are analyzed: *anger*, *anticipation*, *disgust*, *fear*, *joy*, *negative*, *positive*, *sadness*, *surprise*, and *trust*.

## Frequent Topics in Trump's Tweets
This feature will allow the user to check which subjects have been twitted by Donald Trump. Through text mining  and word frequency analysis, the most frequent terms are selected and grouped into greater topics.

The user will be able to see graphically the most common topics, such as through a word cloud.


## Development Notes
This application makes use of several third party packages, most of which are available in the CRAN-project. In special, the following packages were used:

* twitteR - to collect data from Twitter.
* newsAPI - to collect news from several sources, such as CNN.
* shiny - to develop the web application in R language.

## General Questions
If you have any question or suggestion, please contact the repository owner.


