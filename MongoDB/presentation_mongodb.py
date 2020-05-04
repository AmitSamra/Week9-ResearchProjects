# Install
brew services stop mongodb
brew uninstall mongodb

brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community

# start mongo cli
mongo

# see databases
show dbs

# switch database or create new if it does not exist
use NYC_CRIME

# create collection with db.createCollection(name)
db.createCollection("nyc_crime")

# create collection 
# db.nyc_crime

# see collections
show collections

# insert document
# note how keys can either be in quotes or not
db.nyc_crime.insertOne({arrest_no : 1, crime_id : 100, crime_name: 'parking'})
db.nyc_crime.insertOne({'arrest_no' : 2, 'crime_id' : 101, 'crime_name' : 'speeding'})
db.nyc_crime.insertOne({'arrest_no' : 3, 'crime_id' : 103, 'crime_name' : 'DWI'})

# show document
db.nyc_crime.find()
# output:
{ "_id" : ObjectId("5eadf0eadf0ab7e8d06646ba"), "arrest_no" : 1, "crime_id" : 100, "crime_name" : "parking" }
{ "_id" : ObjectId("5eadf150df0ab7e8d06646bb"), "arrest_no" : 2, "crime_id" : 101, "crime_name" : "speeding" }
{ "_id" : ObjectId("5eadf600df0ab7e8d06646bd"), "arrest_no" : 3, "crime_id" : 103, "crime_name" : "DWI" }

# can also use .find().pretty() if dataset is difficult to read
db.nyc_crime.find().pretty()
# output:
{
	"_id" : ObjectId("5eadf0eadf0ab7e8d06646ba"),
	"arrest_no" : 1,
	"crime_id" : 100,
	"crime_name" : "parking"
}
{
	"_id" : ObjectId("5eadf150df0ab7e8d06646bb"),
	"arrest_no" : 2,
	"crime_id" : 101,
	"crime_name" : "speeding"
}
{
	"_id" : ObjectId("5eadf600df0ab7e8d06646bd"),
	"arrest_no" : 3,
	"crime_id" : 103,
	"crime_name" : "DWI"
}

# update document matching condition
db.nyc_crime.update({"crime_name":"DWI"}, {$set:{"crime_name":"DUI"}})
# output:
{ "_id" : ObjectId("5eadf0eadf0ab7e8d06646ba"), "arrest_no" : 1, "crime_id" : 100, "crime_name" : "parking" }
{ "_id" : ObjectId("5eadf150df0ab7e8d06646bb"), "arrest_no" : 2, "crime_id" : 101, "crime_name" : "speeding" }
{ "_id" : ObjectId("5eadf600df0ab7e8d06646bd"), "arrest_no" : 3, "crime_id" : 103, "crime_name" : "DUI" }

# remove specfic document
db.nyc_crime.remove({"_id" : ObjectId("5eadf600df0ab7e8d06646bd")})

# remove document matching condition
db.nyc_crime.remove({crime_name:'DUI'})

# show collection
db.nyc_crime.find()
# output
{ "_id" : ObjectId("5eadf0eadf0ab7e8d06646ba"), "arrest_no" : 1, "crime_id" : 100, "crime_name" : "parking" }
{ "_id" : ObjectId("5eadf150df0ab7e8d06646bb"), "arrest_no" : 2, "crime_id" : 101, "crime_name" : "speeding" }

