#Team Members: Arpita Dutta (AXD170025), Nikita Vispute (NXV170005)


#libraries
library(cloudml)
library(keras)
library(tensorflow)

#Read the train and test datasets
#Since the imagenet website server was down , we downloaded the dogs and cats dataset from the kaggle website
#https://www.kaggle.com/c/dogs-vs-cats/data
# We have only used the train set from the kaggle website and split into train and test set for the assignment 
#as we needed the class labels for the images as well.


#train_dir <- "http://www.utdallas.edu/~nxv170005/dogs-vs-cats/train/"
#test_dir <- "http://www.utdallas.edu/~nxv170005/dogs-vs-cats/test/"

#train_dir <- "https://storage.googleapis.com/cnn_dogs_cats/train/"
#test_dir <- "https://storage.googleapis.com/cnn_dogs_cats/test/"

#train_dir <- "D://Nikita//Documents//UTD//Semester II//CS 6301//Datasets//dogs_vs_cats//train"
#test_dir <- "D://Nikita//Documents//UTD//Semester II//CS 6301//Datasets//dogs_vs_cats//test"

download.file("http://www.utdallas.edu/~axd170025/dogs-vs-cats.zip", "dogs-vs-cats.zip")
unzip("dogs-vs-cats.zip")
train_dir <- "dogs-vs-cats/train"
test_dir <- "dogs-vs-cats/test"

#CNN MODEL

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",
                input_shape = c(150, 150, 3)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 512, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")


model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_rmsprop(lr = 1e-4),
  metrics = c("acc")
)

#Preprocessing of data set images
train_datagen <- image_data_generator(rescale = 1/255)             
test_datagen <- image_data_generator(rescale = 1/255)        

train_generator <- flow_images_from_directory(
  train_dir,                                                       
  train_datagen,                                                   
  target_size = c(150, 150),                                       
  batch_size = 25,                                                 
  class_mode = "binary"
)

test_generator <- flow_images_from_directory(
  test_dir,
  test_datagen,
  target_size = c(150, 150),
  batch_size = 25,
  class_mode = "binary"
)

batch <- generator_next(train_generator)

#History plot and accuracy
history <- model %>% fit_generator(
  train_generator,
  steps_per_epoch = 100,
  epochs = 30,
  validation_data = test_generator,
  validation_steps = 50
)

history
plot(history)

#cat - 0, dog - 1
# Images, true and predicted label
batch <- generator_next(test_generator)
true_labels<-as.vector(batch[2])
predictions<- model %>% predict_classes(batch[1])
predictions<-as.vector(predictions)
predictions
true_labels
Sample_data<-as.data.frame((true_labels[1]))
Sample_data$predicted_label<-predictions
colnames(Sample_data)<-c("true_label","Predicted_label")
Sample_data


gcloud_init()
cloudml_train("CNN_Assignment4.R")
