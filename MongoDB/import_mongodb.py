import pandas as pd
from pymongo import MongoClient

client = MongoClient()
database = client['NYC_CRIME']
collection = database['nyc_crime2']

def csv_to_json(filename):
    data = pd.read_csv(filename, low_memory=False)
    return data.to_dict('records')

collection.insert_many(csv_to_json('/Users/asamra/dev/MongoDB_Project/NYPD_small.csv'))

