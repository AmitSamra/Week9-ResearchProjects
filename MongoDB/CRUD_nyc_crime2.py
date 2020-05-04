import pandas as pd
from pymongo import MongoClient

client = MongoClient()
database = client['NYC_CRIME']
collection = database['nyc_crime2']

collection.delete_many({"PERP_SEX":"F"})

