# Market Basket Challenge (Kaggle)

Technology: R
•	Pre-processed the datasets obtained from Kaggle and generated valuable data and plots for frequent item-sets of customer orders and useful association rules by using apriori algorithm.
•	This helped in identifying relationships between items that people buy in frequently.

Dataset:
Original datasets link:
https://www.kaggle.com/c/instacart-market-basket-analysis/overview

Steps:
Free to choose min support, confidence, lift values
1. Frequent itemsets for products in orders dataset. You have to output product names and not just product id
2. Association rules for products in orders dataset. You have to output product names and not just product id
3. Frequent itemsets for departments in orders dataset (i.e which departments have highest number of orders). 
4. Association rules for departments in orders dataset (e.g. frozen -> groceries).

This folder contains
1. Report
2. R code
3. Data

The datasets have been uploaded in original datasets folder.Path must be changed accordingly in the code.
Newly created merged datasets were first written into a file in a local location and then pushed onto the UTD personal website. 
These new datasets are directly read into the R code from the UTD personal website.
These new datasets have also been uploaded to the Data folder as 
1. TransactionData-market_basket_transactions zipped folder
2. TransactionData1-market_basket_transactions1 zipped folder
Path must be changed accordingly in the code at the appropriate lines to retrieve the new data into the code.

Report contains detailed explanation and plots and output for each of the 4 steps.
