# Market Basket Challenge (Kaggle)

**Technology: R** <br>
•	**Pre-processed the datasets obtained from Kaggle and generated valuable data and plots for frequent item-sets of customer orders and useful association rules by using apriori algorithm.**<br>
•	**This helped in identifying relationships between items that people buy in frequently.**<br>

Dataset:<br>
Original datasets link:<br>
https://www.kaggle.com/c/instacart-market-basket-analysis/overview<br>
1. order_products__prior.csv<br>
2. products.csv<br>
3. departments.csv<br>

Steps:<br>
Free to choose min support, confidence, lift values<br>
1. Frequent itemsets for products in orders dataset. You have to output product names and not just product id.<br>
2. Association rules for products in orders dataset. You have to output product names and not just product id.<br>
3. Frequent itemsets for departments in orders dataset (i.e which departments have highest number of orders). <br>
4. Association rules for departments in orders dataset (e.g. frozen -> groceries).<br>

This folder contains<br>
1. Report<br>
2. R code<br>

The original datasets have been downloaded from the link and read into the code. Path must be changed accordingly in the code.<br>
Newly created merged datasets were first written into a file in a local location and then pushed onto the UTD personal website. <br>
These new datasets are directly read into the R code from the UTD personal website.<br>
These new datasets were named as following in the code <br>
1. market_basket_transactions zipped folder<br>
2. market_basket_transactions1 zipped folder<br>

Path must be changed accordingly in the code at the appropriate lines to retrieve the new data into the code.<br>

Report contains detailed explanation and plots and output for each of the 4 steps.<br>
