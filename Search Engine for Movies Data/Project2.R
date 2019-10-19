#Team Members
#Arpita Dutta AXD170025
#Nikita Vispute NXV170005

library(tm)
library(dplyr)
library("SnowballC")
library("tidytext")
library(tidyverse)

#plot_summaries <- read.delim("E:/Data Science with R/MovieSummaries/plot_summaries.txt", header=FALSE)
plot_summaries <- read_delim("http://www.utdallas.edu/~nxv170005/plot_summaries.txt", 
                                  "\t", escape_double = FALSE, col_names = FALSE, 
                                   trim_ws = TRUE)

colnames(plot_summaries)<-c("ID","Text")

plot_summaries <- plot_summaries %>% 
  mutate(rowIndex=as.numeric(row.names(.))) %>%
  select("Text","ID",rowIndex)


doc.list <- as.list(plot_summaries$Text)
N.docs <- length(doc.list)
names(doc.list) <- paste0("doc", c(1:N.docs))
N.docs


#query <- "Seventh-day Adventist Church"


QrySearch <- function(query) {
  

  my.docs <- VectorSource(c(doc.list, query))
  my.docs$Names <- c(names(doc.list), "query")
  
  my.corpus <- VCorpus(my.docs)
  #my.corpus
  #inspect(my.corpus[[42304]])
  
  my.corpus <- tm_map(my.corpus, removePunctuation)
  my.corpus <- tm_map(my.corpus, removeNumbers)
  #remove numbers, uppercase, additional spaces
  my.corpus <- tm_map(my.corpus, content_transformer(tolower))
  my.corpus <- tm_map(my.corpus, stripWhitespace)
  my.corpus<- tm_map(my.corpus,stemDocument)
  my.corpus = tm_map(my.corpus,removeWords,stopwords("english"))
  
  
  #inspect(my.corpus[[42303]])
  
  term.doc.matrix.stm <- TermDocumentMatrix(my.corpus,
                                            control=list(
                                              weighting=function(x) weightSMART(x,spec="ltc"),
                                              wordLengths=c(1,Inf)))
  
  #inspect(term.doc.matrix.stm[0:14, ])

  
  # Transform term document matrix into a dataframe
  term.doc.matrix <- tidy(term.doc.matrix.stm) %>% 
    group_by(document) %>% 
    mutate(vtrLen=sqrt(sum(count^2))) %>% 
    mutate(count=count/vtrLen) %>% 
    ungroup() %>% 
    select(term:count)
  
  docMatrix <- term.doc.matrix %>% 
    mutate(document=as.numeric(document)) %>% 
    filter(document<N.docs+1)
  qryMatrix <- term.doc.matrix %>% 
    mutate(document=as.numeric(document)) %>% 
    filter(document>=N.docs+1)
  
  
  searchRes <- docMatrix %>% 
    inner_join(qryMatrix,by=c("term"="term"),
               suffix=c(".doc",".query")) %>% 
    mutate(termScore=round(count.doc*count.query,4)) %>% 
    group_by(document.query,document.doc) %>% 
    summarise(Score=sum(termScore)) %>% 
    filter(row_number(desc(Score))<=10) %>% 
    arrange(desc(Score)) %>% 
    left_join(plot_summaries,by=c("document.doc"="rowIndex")) %>% 
    ungroup() %>% 
    select("Text","Score","ID") %>% 
    data.frame()
  
  print(searchRes)

}

fun<-function(){
  
  x<-readline(prompt="Enter search Keyword: ");
  if(x=="q")
    print("Bye!!")
  else
  {
    QrySearch(x)
    fun()
  }
}

fun()
