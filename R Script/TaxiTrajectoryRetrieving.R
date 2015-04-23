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


collection <- "taxi" ## taxi trajectory
namespace <- paste(db, collection, sep=".")


mongo.count(mongo, namespace)
(sample <- mongo.find.one(mongo, namespace))


## create a variable "namespace", the value is "admin.taxi"
collection <- "taxi"
namespace <- paste(db, collection, sep=".")

## get dataset size
mongo.count(mongo, namespace);

## get a random sample
sample <- mongo.find.one(mongo, namespace)

## view sample
(sample)

## create query with a certain date of 2009-09-8
## also only select those records with customer
query <- mongo.bson.from.list(list("date"="2009-09-08")

fields <- mongo.bson.buffer.create()

mongo.bson.buffer.append(fields, "_id", 0L)
mongo.bson.buffer.append(fields, "taxi_no", 1L)
mongo.bson.buffer.append(fields, "date", 1L)
mongo.bson.buffer.append(fields, "speed", 1L)
mongo.bson.buffer.append(fields, "time", 1L)
mongo.bson.buffer.append(fields, "lon", 1L)
mongo.bson.buffer.append(fields, "lat", 1L)
mongo.bson.buffer.append(fields, "occupy", 1L)
mongo.bson.buffer.append(fields, "unknown", 1L)

fields <- mongo.bson.from.buffer(fields)
cursor <- mongo.find(mongo, namespace, query=query, fields=fields)
## Define a master data frame to store results
taxi.data <- data.frame(stringsAsFactors=FALSE)
## Iterate over the cursor
while(mongo.cursor.next(cursor)) {
  
  
  ## Iterate and grab the next record
  value <- mongo.cursor.value(cursor);
  taxi <- mongo.bson.to.list(value);
  ## Make it a data frame
  taxi.df <- as.data.frame(t(unlist(taxi)), stringsAsFactors=FALSE);
  ## Bind to the master data frame
  taxi.data <- rbind.fill(taxi.data, taxi.df);
}

## Release the resources attached to cursor on both client and server
done <- mongo.cursor.destroy(cursor)

## View the retrieved data frame
(taxi.data)

## Export to a CSV file
write.csv(taxi.data, file = "C:/Users/Qifan/Documents/GitHub/taxi-fare-estimation/Data/taxi-gps-2009-09-08.csv")

## close connection with MongoDB
mango.disconnect(mongo)