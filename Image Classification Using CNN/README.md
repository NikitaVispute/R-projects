# Image Classification on Dogs-Cats Image Dataset Using Convolution Neural Network

Dataset:<br>
https://www.kaggle.com/c/dogs-vs-cats/data<br>

Technology: R, Keras<br>
•	Built a CNN model with keras package after pre-processing the ‘dogs and cats’ dataset from Kaggle. <br>
•	Changed various parameters of the model to improve the performance based on train and test accuracy. <br>
•	Also rendered the images on Google Cloud with their true and predicted labels and plots of their accuracies.<br>

Steps:<br>
1. Download the images and split them in the ratio 80:20 for training and test parts. <br>
2. After getting the data, you can do any pre-processing required, such as making them the same size, etc.<br>
3. Next you will create a Keras model using alternating Conv2D and maxpool layers. It is up to you to design the network, including things such as input image size, output size, number of layers, etc. You need to tune as many of the following parameters as possible:<br>
 Number of layers<br>
  • Kernel (filter size)<br>
  • Number of filters in each layer<br>
  • How many neurons in the last dense layer<br>
  • Activation function<br>
  • How to compile and which error function to use (such as binary crossentropy,etc)<br>
  • Batch size<br>
4. Run on Google Cloud.<br>
5. Output<br>
  History plots showing training and testing accuracy and loss as a function of number of iterations. <br>
  Example of at least 25 images arranged in 5x5 from test dataset, showing the following<br>
    • Image<br>
    • True Label<br>
    • Predicted Label<br>
  3. A table containing details of parameter testing and tuning.<br>


This entire folder contains:<br>

1. R script file for image classification on dogs-cats dataset <br>
2. "Runs" folder -> cloudml_2019_03_28_010219272 project folder -> tfruns.d folder -> view.html	to view the report run on Google cloud<br>
4. Report file<br>

The first entry in the parameter testing and tuning table of the report file is seen in the SUMMARY tab of the view.html page.<br>
