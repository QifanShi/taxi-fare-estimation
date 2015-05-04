## Author Qifan Shi
## Reference: : https://github.com/vietexob/mobile-intelligence/

## load libraries
library(rmongodb)
library(plyr)

## login tokens
host <- "heinz-tjle.heinz.cmu.edu"
username <- "student"
password <- "helloWorld"
db <- "admin"

mongo <- mongo.create(host = host, db = db, username = username, password = password)
mongo.is.connected(mongo)

## get a list of all dataset under db "admin"
mongo.get.database.collections(mongo, db="admin")

## income
collection <- "income"
namespace <- paste(db, collection, sep=".")

## count number of rows
mongo.count(mongo, namespace)

## get a sample and view it
(sample <- mongo.find.one(mongo, namespace))

query <- mongo.bson.from.list(list("begin_date"="9/11/2009", "end_date"="9/11/2009"))

fields <- mongo.bson.buffer.create()

mongo.bson.buffer.append(fields, "_id", 1L)
mongo.bson.buffer.append(fields, "id", 1L)
mongo.bson.buffer.append(fields, "taxi_no", 1L)
mongo.bson.buffer.append(fields, "begin_date", 1L)
mongo.bson.buffer.append(fields, "begin_time", 1L)
mongo.bson.buffer.append(fields, "end_date", 1L)
mongo.bson.buffer.append(fields, "end_time", 1L)
mongo.bson.buffer.append(fields, "end_price", 1L)
mongo.bson.buffer.append(fields, "task_distance", 1L)
mongo.bson.buffer.append(fields, "task_amount", 1L)
mongo.bson.buffer.append(fields, "free_distance", 1L)
mongo.bson.buffer.append(fields, "company_id", 1L)
mongo.bson.buffer.append(fields, "taxi_type", 1L)


fields <- mongo.bson.from.buffer(fields)

cursor <- mongo.find(mongo, namespace, query=query, fields=fields)
## Define a master data frame to store results
income.data <- data.frame(stringsAsFactors=FALSE)
## Iterate over the cursor

while(mongo.cursor.next(cursor)) {
  
  
  ## Iterate and grab the next record
  value <- mongo.cursor.value(cursor);
  income <- mongo.bson.to.list(value);
  ## Make it a data frame
  income.df <- as.data.frame(t(unlist(income)), stringsAsFactors=FALSE);
  ## Bind to the master data frame
  income.data <- rbind.fill(income.data, income.df);
}
## Release the resources attached to cursor on both client and server
done <- mongo.cursor.destroy(cursor)

## View the created data frame
head(income.data)

## Export to a CSV file
write.csv(income.data, file = "C:/Users/Qifan/Documents/CMU/MIB/taxiIncome-2009-09-11-full.csv")

## close connection
mongo.disconnect(mongo)

