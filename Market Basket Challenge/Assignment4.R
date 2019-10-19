#Team Members: Nikita Vispute (NXV170005)
#              Arpita Dutta (AXD170025)

#-----------------------------------------------------------------#

#libraries
library(arules)
library(plyr)
library(tidyverse)

#load the datasets
order_products_prior <- read_csv("http://www.utdallas.edu/~axd170025/order_products__prior.csv")
products <- read_csv("http://www.utdallas.edu/~axd170025/products.csv")
departments <- read_csv("http://www.utdallas.edu/~axd170025/departments.csv")

#----------------------------------------------------------------#

#Merge order_products_prior and products dataset
order_products<-merge(order_products_prior,products,by="product_id")
head(order_products)

#Grouping the items by product_name
transactionData <- ddply(order_products,"order_id",
                         function(df1)paste(df1$product_name,
                                            collapse = ","))

class(transactionData)
transactionData$order_id<-NULL
head(transactionData)

#Assigning column name as "items"
colnames(transactionData)<-"items"

#----------------------------------------------------------------------------#

#write the transactionData data frame to a local location into a file 
#after this it was pushed onto the UTD personal website
#write.csv(transactionData,"C://Users//Nikita Vispute//Desktop//market_basket_transactions.csv", quote = FALSE, row.names = FALSE)


#Reading the transactionData file from the UTD personal website zipped folder
download.file("http://www.utdallas.edu/~nxv170005/market_basket_transactions.zip", "market_basket_transactions.zip")
unzip("market_basket_transactions.zip")
tr <- read.transactions('market_basket_transactions.csv', format = 'basket', sep=',')

summary(tr)
inspect(head(tr))

#-----------------------------------------------------------------------#

#Q1
#Frequent itemsets for products in orders_products dataset
frequentItems <- eclat (tr,parameter = list(supp = 0.03, maxlen = 15))
inspect(frequentItems)

#Plot for frequent itemsets
itemFrequencyPlot(tr, topN=20,type="absolute", main="Item Frequency")

#------------------------------------------------------------------------#

#Q2
#Association rules for products in order_products dataset
item_rules <- apriori (tr,parameter = list(supp = 0.001, conf = 0.5))
summary(item_rules)
inspect(item_rules)
rules_conf <- sort (item_rules, by="confidence",decreasing=TRUE) # 'high-confidence' rules.

### show the support, lift and confidence for all item_rules
inspect(head(rules_conf, 20))

#------------------------------------------------------------------------------------#

#Removing certain columns from the order_products data frame before merging with the departments dataset.
order_products$add_to_cart_order<-NULL
order_products$reordered<-NULL
order_products$aisle_id<-NULL

#Merge order_products with departments
order_products_dept <- merge(order_products,departments,by="department_id")

#Grouping the items by department
transactionData1 <- ddply(order_products_dept,"order_id",
                         function(df1)paste(df1$department,
                                            collapse = ","))

class(transactionData1)
transactionData1$order_id<-NULL
head(transactionData1)

#Assigning column name as department
colnames(transactionData1)<-"departments"

#------------------------------------------------------------------#

#write the transactionData1 data frame to a local location into a file 
#after this it was pushed onto the UTD personal website
#write.csv(transactionData1,"C://Users//Nikita Vispute//Desktop//market_basket_transactions1.csv", quote = FALSE, row.names = FALSE)

#Reading the transactionData1 file from the UTD personal website zipped folder
download.file("http://www.utdallas.edu/~nxv170005/market_basket_transactions1.zip", "market_basket_transactions1.zip")
unzip("market_basket_transactions1.zip")
tr1 <- read.transactions('market_basket_transactions1.csv', format = 'basket', sep=',')

summary(tr1)
inspect(head(tr1))

#----------------------------------------------------------------------------------------------#

#Q3
#Frequent Department itemset for the order_products_dept dataset 
frequentDepts <- eclat (tr1,parameter = list(supp = 0.2, maxlen = 15))
inspect(frequentDepts)

#Plot for frequent department itemsets
itemFrequencyPlot(tr1, topN=20,type="absolute", main="Dept Frequency")

#----------------------------------------------------------------------------------------------#

#Q4
#Association rules for departments in order_products_dept dataset
dept_rules <- apriori (tr1,parameter = list(supp = 0.07, conf = 0.5))
summary(dept_rules)
inspect(dept_rules)
rules_conf <- sort (dept_rules, by="confidence",decreasing=TRUE) # 'high-confidence' rules.

### show the support, lift and confidence for all rules
inspect(head(rules_conf, 20))

#----------------------------------------------------------------------------------------------#