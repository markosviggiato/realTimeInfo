### Author : Markos Viggiato
### Date : August 24th, 2018
### Code developed using resources from 'http://www.rdatamining.com/docs/twitter-analysis-with-r', by Yanchang Zhao
### This code makes of of the 'tm' package to analyze the frequent terms from tweets

#################

# import of useful packages
library(twitteR)
library(ggplot2)
library(tm)

# main function to obtain the most frequent terms through text analysis
frequentTopics <- function(){
 
      # collect the 1000 most recent tweets from Donald Trump
      tweets <- userTimeline("realDonaldTrump", n = 1000)
      tweets.df <- twListToDF(tweets)

      # build a corpus with the text content from the tweet
      myCorpus <- Corpus(VectorSource(tweets.df$text))
      
      # convert to lower case
      myCorpus <- tm_map(myCorpus, function(x) iconv(enc2utf8(x), sub = "byte"))
      myCorpus <- tm_map(myCorpus, content_transformer(tolower))
    
      # remove URLs
      removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
      myCorpus <- tm_map(myCorpus, content_transformer(removeURL))
    
      # keep only Enlish letters and space
      removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
      myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))
    
      # remove stopwords
      myStopwords <- c(setdiff(stopwords('english'), c("r", "big")),
                     "use", "see", "used", "via", "amp", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
    
      myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
    
      # remove extra whitespace
      myCorpus <- tm_map(myCorpus, stripWhitespace)
      
      # keep a copy for stem completion later
      myCorpusCopy <- myCorpus
    
      myCorpus <- tm_map(myCorpus, stemDocument) # stem words

      stemCompletion2 <- function(x, dictionary) {
            x <- unlist(strsplit(as.character(x), " "))
            x <- x[x != ""]
            x <- stemCompletion(x, dictionary=dictionary)
            x <- paste(x, sep="", collapse=" ")
            PlainTextDocument(stripWhitespace(x))
      }
    
      myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=myCorpusCopy)
      myCorpus <- Corpus(VectorSource(myCorpus))

      # helper function to coun the frequency of words
      wordFreq <- function(corpus, word) {
            results <- lapply(corpus,
                  function(x) { grep(as.character(x), pattern=paste0("\\<",word)) }
            )
            sum(unlist(results))
      }
    
      tdm <- TermDocumentMatrix(myCorpus, control = list(wordLengths = c(1, Inf)))
      idx <- which(dimnames(tdm)$Terms %in% c("r", "data", "mining"))
      as.matrix(tdm[idx, 21:30])
    
      # inspect frequent words
      (freq.terms <- findFreqTerms(tdm, lowfreq = 20))
      term.freq <- rowSums(as.matrix(tdm))
      term.freq <- subset(term.freq, term.freq >= 20)
      df <- data.frame(term = names(term.freq), freq = term.freq)
    
      # plot the most frequent words using ggplot
      ggplot(df, aes(x=term, y=freq)) + geom_bar(stat="identity") +
        xlab("Terms") + ylab("Count") + coord_flip() +
        theme(axis.text=element_text(size=7))
}

