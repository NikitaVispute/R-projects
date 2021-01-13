# Search Engine For Movies Dataset

**Technology: R**<br>

**Pre-processed the movie summary dataset from Carnegie Movie Summary Corpus and built a search engine for the data using the tf-idf technique by MapReduce for each document pair. The query is of two types: single term or multiple terms and this would display the appropriate movies when entered in the search engine.**<br>

Steps:<br>
1. For this project, worked with a dataset of movie plot summaries that is available from the Carnegie Movie Summary Corpus site: http://www.cs.cmu.edu/~ark/personas/. Downloaded the version “Dataset [46 M]”.<br>
2. Built a search engine for the plot summaries that are available in the file “plot summaries.txt” using the tf-idf technique.<br>
3. First need to remove stop words.<br>
4. Next, word stemming. <br>
5. After the above pre-processing steps, compute tf-idf values for each document-term pair. <br>
6. Your program should read query phrases (which could be multiple terms such as “action movies with comedy scenes”) from the command line and should return the top 10 documents matching the user’s queries. The program should terminate when the user presses the “q” key.<br>
7. The query could be of two types:<br>
• Single terms: such as “Dallas”. Simply return the top 10 documents with the highest tf-idf values for this term.<br>
• Multiple terms: such as “movies starring Brad Pitt”. Compute cosine similarity between the query and each of the documents, and return the top 10 most similar documents.<br>
