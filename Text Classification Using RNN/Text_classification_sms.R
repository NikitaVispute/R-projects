#Team Members: Nikita Vispute, Arpita Dutta

#library
library(keras)
library(tensorflow)
library(cloudml)
library("tm")

#Reading the data from the cloud storage
#DATA SET USED FROM UCI TEXT DATASETS: SMS SPAM COLLECTION

#gs_rsync("gs://dataset_r/SMSSpamCollection", "/SMSSpamCollection")
#data_dir <- gs_data_dir("gs://dataset_r")
#SMSSpamCollection <- read.delim(file.path(data_dir, "SMSSpamCollection"), header=FALSE)

SMSSpamCollection <- read.delim("https://storage.googleapis.com/dataset_r/SMSSpamCollection", header=FALSE)
#View(SMSSpamCollection)

#Preprocessing and Cleaning the Data
colnames(SMSSpamCollection)<-c("score","Review")
levels(SMSSpamCollection$score)[levels(SMSSpamCollection$score)=="ham"] <- 0
levels(SMSSpamCollection$score)[levels(SMSSpamCollection$score)=="spam"] <- 1

docs<-VCorpus(VectorSource(SMSSpamCollection$Review))
docs[1:10]
docs<-tm_map(docs,stripWhitespace)
docs<-tm_map(docs,content_transformer(tolower))
#inspect(docs[[1]])

docs <- tm_map(docs, removeWords, stopwords("english"))
docs<-tm_map(docs,removePunctuation)
#inspect(docs[[1]])
clean_data<-data.frame(text=unlist(sapply(docs, `[`, "content")), stringsAsFactors=F)

text<-clean_data$text

tokenizer <- text_tokenizer(num_words = 10000) %>%
  fit_text_tokenizer(text)
sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
cat("Found", length(word_index), "unique tokens.\n")
data <- pad_sequences(sequences, maxlen = 50)
labels <- as.array(SMSSpamCollection$score)
cat("Shape of data tensor:", dim(data), "\n")
cat('Shape of label tensor:', dim(labels), "\n")

#Vectorize data sequence function
vectorize_sequences <- function(data,
                                dimension = 10000) {
  # Create an all-zero matrix of shape
  #      (len(data), dimension)
  
  results <- matrix(0, nrow = length(data),
                    ncol = dimension)
  for (i in 1:length(data))
    # Sets specific indices of results[i] to 1s
    results[i, data[[i]]] <- 1
  results
}

# Vectorized training data
x_train <- vectorize_sequences(data[1:2000])

# Vectorized test data
x_test <- vectorize_sequences(data[2001:3000])

# Vectorize Labels
y_train <- as.numeric(SMSSpamCollection$score[1:2000])
y_test <- as.numeric(SMSSpamCollection$score[2001:3000])

#------------------------------------------------------------------------------------------------

#MODEL 1:
#Parameters:
#Num_of_words = 10000
#Layers = input layer - 15 units, 1st hidden layer - 15 units, 2nd hidden layer - 10 units
#Activation function - relu,softmax
#optimizer = rmsProp,
#loss = binary_crossentropy
#epochs = 20
#batch_size = 512

#Define Deep Learning Model for the SMS Spam data
model1 <- keras_model_sequential() %>%
  layer_dense(units = 15, activation = "relu",
              input_shape = c(10000)) %>%
  layer_dense(units = 15, activation = "relu") %>%
  layer_dense(units = 10, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

#Compile Deep Learning Model for the SMS Spam data
model1 %>% compile(
  optimizer = "rmsProp",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

#Learn and Fit Deep Learning Model on the test data
model1 %>% fit(x_train, y_train, epochs = 20,
               batch_size = 512)
results1 <- model1 %>% evaluate(x_test, y_test)

model1
summary(model1)
results1


#Split Train Data into Train and Validation data
val_indices <- 1:1000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

#Fit the model on validation data and plot history
history1 <- model1 %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)

history1
plot(history1)

#-----------------------------------------------------------------------------------------------------

#MODEL 2:
#Parameters:
#Num_of_words = 10000
#Layers = input layer - 20 units, 1st hidden layer - 10 units, 2nd hidden layer - 5 units
#Activation function - tanh,sigmoid
#optimizer = rmsProp,
#loss = binary_crossentropy
#epochs = 10
#batch_size = 300

#Define Deep Learning Model for the SMS Spam data
model2 <- keras_model_sequential() %>%
  layer_dense(units = 20, activation = "tanh",
              input_shape = c(10000)) %>%
  layer_dense(units = 10, activation = "tanh") %>%
  layer_dense(units = 5, activation = "tanh") %>%
  layer_dense(units = 1, activation = "sigmoid")

#Compile Deep Learning Model for the SMS Spam data
model2 %>% compile(
  optimizer = "rmsProp",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

#Learn and Fit Deep Learning Model on the test data
model2 %>% fit(x_train, y_train, epochs = 10,
               batch_size = 300)
results2 <- model2 %>% evaluate(x_test, y_test)

model2
summary(model2)
results2


#Split Train Data into Train and Validation data
val_indices <- 1:1000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

#Fit the model on validation data and plot history
history2 <- model2 %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 10,
  batch_size = 300,
  validation_data = list(x_val, y_val)
)

history2
plot(history2)

#-------------------------------------------------------------------------------------------------

#MODEL 3:
#Parameters:
#Num_of_words = 10000
#Layers = input layer - 20 units, 1st hidden layer - 10 units, 2nd hidden layer - 5 units
#Activation function - sigmoid
#optimizer = rmsProp,
#loss = binary_crossentropy
#epochs = 20
#batch_size = 300

#Define Deep Learning Model for the SMS Spam data
model3 <- keras_model_sequential() %>%
  layer_dense(units = 20, activation = "sigmoid",
              input_shape = c(10000)) %>%
  layer_dense(units = 10, activation = "sigmoid") %>%
  layer_dense(units = 5, activation = "sigmoid") %>%
  layer_dense(units = 1, activation = "sigmoid")

#Compile Deep Learning Model for the SMS Spam data
model3 %>% compile(
  optimizer = "rmsProp",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

#Learn and Fit Deep Learning Model on the test data
model3 %>% fit(x_train, y_train, epochs = 20,
               batch_size = 300)
results3 <- model3 %>% evaluate(x_test, y_test)

model3
summary(model3)
results3

#Split Train Data into Train and Validation data
val_indices <- 1:1000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

#Fit the model on validation data and plot history
history3 <- model3 %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 300,
  validation_data = list(x_val, y_val)
)

history3
plot(history3)

#----------------------------------------------------------------------------------------------------

#MODEL 4:
#Parameters:
#Num_of_words = 10000
#Layers = input layer - 10 units, hidden layer - 10 units
#Activation function - relu,sigmoid
#optimizer = adam,
#loss = binary_crossentropy
#epochs = 20
#batch_size = 500

#Define Deep Learning Model for the SMS Spam data
model4 <- keras_model_sequential() %>%
  layer_dense(units = 10, activation = "relu",
              input_shape = c(10000)) %>%
  layer_dense(units = 10, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

#Compile Deep Learning Model for the SMS Spam data
model4 %>% compile(
  optimizer = "adam",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

#Learn and Fit Deep Learning Model on the test data
model4 %>% fit(x_train, y_train, epochs = 20,
               batch_size = 500)
results4 <- model4 %>% evaluate(x_test, y_test)

model4
summary(model4)
results4

#Split Train Data into Train and Validation data
val_indices <- 1:1000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

#Fit the model on validation data and plot history
history4 <- model4 %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 500,
  validation_data = list(x_val, y_val)
)

history4
plot(history4)

#-----------------------------------------------------------------------

#MODEL 5:
#Parameters:
#Num_of_words = 10000
#Layers = input layer - 16 units, 1 hidden layer - 16 units
#activation function - relu, sigmoid
#optimizer = rmsProp,
#loss = binary_crossentropy
#epochs = 20
#batch_size = 512

#Define Deep Learning Model for the SMS Spam data
model5 <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu",
              input_shape = c(10000)) %>%
  layer_dense(units = 16, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

#Compile Deep Learning Model for the SMS Spam data
model5 %>% compile(
  optimizer = "rmsProp",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

#Learn and Fit Deep Learning Model on the test data
model5 %>% fit(x_train, y_train, epochs = 20,
               batch_size = 512)
results5 <- model5 %>% evaluate(x_test, y_test)

model5
summary(model5)
results5


#Split Train Data into Train and Validation data

val_indices <- 1:1000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

#Fit the model on validation data and plot history
history5 <- model5 %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)

history5 
plot(history5)

#-------------------------------------------------------------------------

gcloud_install()

gcloud_init()
cloudml_train("Text_classification_sms.R")
