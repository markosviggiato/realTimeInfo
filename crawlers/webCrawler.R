### Author : Markos Viggiato
### Date : August 25th, 2018

#################

# import of useful library
library("rvest")

# crawl the specified url
webCrawler <- function(url){
scraping <- read_html(url,encoding =  "utf8")

# get the article's title
title <- scraping %>%
      html_nodes("h1.pg-headline") %>%
      html_text()

# get the first paragraph
text <- scraping %>%
      html_nodes("p.zn-body__paragraph.speakable") %>%
      html_text()

# get the rest of the paragraphs
text_part2 <- scraping %>%
      html_nodes("div.zn-body__paragraph") %>%
      html_text()

# combines the title, first paragraph and the other paragraphs
final_text <- c(title, text, text_part2)

}