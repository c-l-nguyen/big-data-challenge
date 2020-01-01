# big-data-challenge

Many of Amazon's shoppers depend on product reviews to make a purchase. Amazon makes these datasets [publicly available](https://s3.amazonaws.com/amazon-reviews-pds/tsv/index.txt). However, they are quite large and can exceed the capacity of local machines to handle. In this analysis, I use the Databricks Community Edition to be able to run PySpark ETL commands and load large datasets of Amazon reviews (two were chosen here: video game purchase reviews and software purchase reviews) up into an AWS RDS PostgreSQL instance. The data was then analyzed using SQL to see if there was any bias in Amazon Vine reviews.

## Dependencies
* Databricks 6.1 (includes Apache Spark 2.4.4, Scala 2.11)
    * Driver type: 6.0 GB Memory, 0.88 Cores, 1 DBU
    * *Databricks will need a config file uploaded that contains AWS connection information such as access key and secret key
* PostgreSQL version 11.5-R1
* AWS RDS to host PostSQL database

## Analysis

An analysis was done using SQL queries to compare Vine and non-Vine reviews for both datasets. The queries contain comments on results along the way. The results for both datasets was very similar and the following discoveries were found:

* Only a small fraction of reviews were Vine reviews so this shows that the Vine program does only include a specific subset of reviewers.
* The reviews with the most total votes and the most total helpful votes are not Vine reviews in either case. 
* Vine reviews are not always positive judging by the number of stars given to products. But most are by a large margin.
* Reviews date back to the 90s. The date cutoff for reviews was set to 2010 to keep only more recent reviews because they would be more useful for up to date products.
* Vine reviews are considered more helpful than non-Vine reviews so it does look like users take them more seriously when they exist.
* The average number of total votes on reviews is very similar between Vine and non-Vine reviews. One could be slightly higher than the other, but not substanially so to make much of a difference,
* Basically no difference between star rating for Vine and non-Vine reviews (although video game ratings are higher than software star ratings).
* There are actually a significant number of Vine reviews that come from customers that bought 5 or less products within the category. This does not seem to satisfy the claim from Amazon that Vine reviewers are users who have bought many products within the same category.

From this analysis, it doesn't seem like there is a big difference between Vine and non-Vine reviewers. Most analyses found that they are very similar to each other so bias likely is not a big factor in Vine reviews. However, one could argue that the Vine program is not that useful since they produce qualities that nearly match non-Vine reviewers. We would need more information, such as if the existence of Vine reviews made purchases of products higher after they were submitted, to determine if the Vine program is truly useful.