library(tidyverse)
library(tidytext)

fn  <- read_csv("folknotes.csv")

View(fn)

rm_fn <- tibble(id = fn$id, text = (str_remove_all(fn$FolkNotes, "\\?")))

View(rm_fn)

tidy_fn <- rm_fn %>%
  unnest_tokens(word, text)

data(stop_words)

tidy_fn <- tidy_fn %>%
  anti_join(stop_words)

fn_words <- tidy_fn %>%
  count(id, word, sort = TRUE)

head(fn_words)

dtm <- fn_words %>%
  cast_dtm(id, word, n)

require(topicmodels)

K <- 15
set.seed(9161)
topicModel <- LDA(dtm, K, method="Gibbs", control=list(iter = 500, verbose = 25))

tmResult <- posterior(topicModel)

attributes(tmResult)

ncol(dtm)

beta <- tmResult$terms   
dim(beta)

theta <- tmResult$topics
dim(theta)        

top5termsPerTopic <- terms(topicModel, 10)
topicNames <- apply(top5termsPerTopic, 2, paste, collapse=" ")
topicNames

fn$decade <- paste0(substr(fn$Case_date, 0, 3), "0")
topic_proportion_per_decade <- aggregate(theta, by = list(decade = fn$decade), mean)
colnames(topic_proportion_per_decade)[2:(K+1)] <- topicNames

library("reshape2")

View(topic_proportion_per_decade)
vizDataFrame <- melt(topic_proportion_per_decade, id.vars = "decade")
View(vizDataFrame)


library(streamgraph)

stepVisual <- streamgraph(vizDataFrame, key="variable", value="value", date="decade", width = "700", height = "500") 
stepVisual

library(htmlwidgets)
saveWidget(stepVisual, file=paste0( getwd(), "/streamgraph.html"))
