# Text Classification Using RNN on UCI Text dataset

Technology: R <br>
• Pre-processed the SMS Spam Collection dataset obtained from UCI Repository by removing stop words, punctuations, white spaces, split the dataset into train and test and vectorized it. <br>
• Applied deep learning models (RNN) with varying parameters (#input layers, hidden layers, activation function, optimizers, #epochs, batch-size)  to the train set and then tested the model’s performance on the test set based on its accuracy. <br>

Steps<br>

1. Identify a text classification problem and dataset from UCI text datasets. You are responsible for splitting the data into two parts: train and test.<br>
2. Preprocess the data. It involves removing stop words, converting words to vectors, choosing how many words you would like to use and finally make the data suitable for being used as an input layer.<br>
3. Create a deep network using Keras package. Design the output layer based on the data features.<br>
4. Run your code on Google Cloud with GPU enabled. <br>
5. Split the train data into train and validation parts. Use the fit function to build and validate your data and create a plot of the history.<br>
6. Apply the model on the test part and see how well it does. <br>
7. How can you improve the performance. Vary the parameters and run your code at least 5 times and report the parameters used and accuracy obtained.<br>


Dataset used:
https://archive.ics.uci.edu/ml/datasets.php?format=&task=cla&att=&area=&numAtt=&numIns=&type=text&sort=nameUp&view=table <br>
Also uploaded the data file

This entire folder contains:

1. R script file for text classification on SMS Spam Collection Data set. <br>
2. "Runs" folder -> cloudml_2019_03_10_050100333 project folder -> tfruns.d folder -> view.html
	to view the report run on Google cloud <br>

Download the data set and and add appropriate path to retrieve from there in the code.<br>
The libraries are to be installed first locally in R studio after which google cloud platform needs to be initiated and then the code can executed using cloudml_train() command.<br>
The location of the code must be the same as the working directory in R studio.<br>

The entire code along with the five models compiles and run and produce an output succesfully, although only the last one is seen in the SUMMARY tab.<br>
