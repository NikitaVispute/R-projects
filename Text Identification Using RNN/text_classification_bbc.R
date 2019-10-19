#Team Members : Arpita Dutta AXD170025 , Nikita Vispute  NXV170005

#libraries
library("tm")
library(keras)
library(cloudml)

#read the BBC text challenge data set
response <- read.csv("http://www.utdallas.edu/~axd170025/bbc-text.csv")

#classification class and values
colnames(response)<-c("class","response_text")
levels(response$class)[levels(response$class)=="tech"] <- 0
levels(response$class)[levels(response$class)=="business"] <- 1
levels(response$class)[levels(response$class)=="sport"] <- 2
levels(response$class)[levels(response$class)=="entertainment"] <- 3
levels(response$class)[levels(response$class)=="politics"] <- 4

#preprocessing the data
docs<-VCorpus(VectorSource(response$response_text))
docs<-tm_map(docs,stripWhitespace)
docs<-tm_map(docs,content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs<-tm_map(docs,removePunctuation)
clean_data<-data.frame(text=unlist(sapply(docs, `[`, "content")), stringsAsFactors=F)


text<-clean_data$text

#Tokenizing the data

# Number of words to consider as features
tokenizer <- text_tokenizer(num_words = 10000) %>%
  fit_text_tokenizer(text)
sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
cat("Found", length(word_index), "unique tokens.\n")

# Cut texts after this number of words
# (among top max_features most common words)
data <- pad_sequences(sequences, maxlen = 1000)
labels <- as.array(response$class)
cat("Shape of data tensor:", dim(data), "\n")
cat('Shape of label tensor:', dim(labels), "\n")

#Partitioning the data set into train and test 
x_train <- data[1:1812,]
x_test <- data[1813:2225,]


num_classes <- max(as.numeric(response$class)) + 1

# Partitioning the labels into train and test
y_train <- to_categorical(response$class[1:1812], num_classes)
y_test<-to_categorical(response$class[1813:2225], num_classes)

#RNN Model

model1 <- keras_model_sequential() %>%
  layer_embedding(input_dim = 10000, output_dim = 32,input_length = 1000) %>%
  layer_flatten() %>%  
  layer_dense(units=512, activation = "relu") %>%
  layer_dense(units = num_classes) %>% 
  layer_activation(activation = 'softmax')

model2 <- keras_model_sequential() %>%
  layer_embedding(input_dim = 10000, output_dim = 32,input_length =1000) %>%
  #layer_flatten() %>%  
  layer_simple_rnn(units = 32) %>%
  layer_dense(units=512, activation = "relu") %>%
  layer_dense(units = num_classes) %>% 
  layer_activation(activation = 'sigmoid')
  
model3 <- keras_model_sequential() %>%
    layer_embedding(input_dim = 10000, output_dim = 32,input_length =1000) %>%
    #layer_flatten() %>%  
    layer_lstm(units = 32) %>%
    layer_dense(units=512, activation = "relu") %>%
    layer_dense(units = num_classes) %>% 
    layer_activation(activation = 'sigmoid') 


#---- eval=FALSE, message=FALSE------------------------------------------
model1 %>% compile(
  optimizer = "adam",
  loss = "categorical_crossentropy",
  metrics = c('accuracy')
)

model2 %>% compile(
  optimizer = "adam",
  loss = "categorical_crossentropy",
  metrics = c('accuracy')
)

model3 %>% compile(
  optimizer = "adam",
  loss = "categorical_crossentropy",
  metrics = c('accuracy')
)


#---- eval=FALSE, message=FALSE------------------------------------------
history1 <- model1 %>% fit(
  x_train,
  y_train,
  epochs = 10,
  batch_size = 32,
  validation_split = 0.1
)

history2 <- model2 %>% fit(
  x_train,
  y_train,
  epochs = 10,
  batch_size = 32,
  validation_split = 0.1
)

history3 <- model3 %>% fit(
  x_train,
  y_train,
  epochs = 10,
  batch_size = 32,
  validation_split = 0.1
)


history1
plot(history1)

history2
plot(history2)

history3
plot(history3)

#Model Evaluation on test data
score1 <- model1 %>% evaluate(
  x_test, y_test,
  epochs = 5,
  batch_size = 32,
  verbose = 1
)

score2 <- model2 %>% evaluate(
  x_test, y_test,
  epochs = 5,
  batch_size = 32,
  verbose = 1
)

score3 <- model3 %>% evaluate(
  x_test, y_test,
  epochs = 5,
  batch_size = 32,
  verbose = 1
)
#Display Test accuracy and score
cat('Test score for Model 1:', score1[[1]], '\n')
cat('Test accuracy for Model 1:', score1[[2]], '\n')

cat('Test score for Model 2:', score2[[1]], '\n')
cat('Test accuracy for Model 2:', score2[[2]], '\n')

cat('Test score for Model 3:', score3[[1]], '\n')
cat('Test accuracy for Model 3', score3[[2]], '\n')

# 25 test samples with their true and predicted value
x_test_op <- data[2201:2225,]
predictions<- model1 %>% predict_classes(x_test_op)
predictions<-as.vector(predictions)
true_labels<-as.numeric(response$class[2201:2225])
true_labels

result<-as.data.frame(true_labels)
result$predicted_labels<-predictions
result$text<-response$response_text[2201:2225]

result$predicted_labels[result$predicted_labels==0] <- "tech"
result$predicted_labels[result$predicted_labels==1] <- "business"
result$predicted_labels[result$predicted_labels==2] <- "sport"
result$predicted_labels[result$predicted_labels==3] <- "entertainment"
result$predicted_labels[result$predicted_labels==4] <- "politics"

result$true_labels[result$true_labels==5] <- "tech"
result$true_labels[result$true_labels==1] <- "business"
result$true_labels[result$true_labels==2] <- "sport"
result$true_labels[result$true_labels==3] <- "entertainment"
result$true_labels[result$true_labels==4] <- "politics"
result


gcloud_init()
cloudml_train("text_classification_bbc.R")
