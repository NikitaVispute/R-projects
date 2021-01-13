# Text Classification and Identification on BBC Text Dataset (Kaggle)
**Technology: R<br>
•	Pre-processed the BBC text classification challenge dataset from Kaggle and build a deep learning neural network model (RNN) to fit the dataset and then test it on the test dataset.<br>
•	Varied the parameters of the model to improve the performance and rendered the results of the best model based on the accuracy and plots.<br>**

Dataset:<br>
BBC text classification challenge<br>
https://www.kaggle.com/yufengdev/bbc-fulltext-and-category<br>

Steps:<br>
1. Use any one of the deep learning techniques: RNN, CNN<br>
2. Run on Google Cloud using GPU.<br>
3. Divide the data into these train and test parts. It’s up to you to choose the ratio.<br>
4. You need to tune as many of the parameters as possible. <br>
5. Output:<br>
   History plots showing training and testing accuracy and loss as a function of number of iterations. <br>
   A table containing details of parameter testing and tuning.<br>

This entire folder contains:<br>

1. R script file for text classification Project (BBC Text Challenge Data set)<br>
2. cloudml_2019_04_02_041306029 project folder -> tfruns.d folder -> view.html to view the report run on Google cloud<br>
3. Report file<br>
4. Dataset zip folder <br>

Download the data set and and add appropriate path to retrieve from there in the code.<br>
The first entry in the parameter testing and tuning table of the report file, model3 in the code, is seen in the SUMMARY tab of the view.html page.<br>
3 models as described in the report are displayed with the history plots in the view.html page.<br>
The libraries are to be installed first locally in R studio after which google cloud platform needs to be initiated and then the code can executed using cloudml_train() command.<br>
The location of the code must be the same as the working directory in R studio.<br>

