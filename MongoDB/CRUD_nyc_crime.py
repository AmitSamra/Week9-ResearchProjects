import pandas as pd
from pymongo import MongoClient

client = MongoClient()
database = client['NYC_CRIME']
collection = database['nyc_crime']

collection.insert({'arrest_no' : 10, 'crime_id' : 110, 'crime_name': 'touching'})
collection.insert({'arrest_no' : 11, 'crime_id' : 110, 'crime_name': 'touching'})
collection.insert({'arrest_no' : 12, 'crime_id' : 110, 'crime_name': 'touching'})
#collection.delete_many({'crime_name':'touching'})

