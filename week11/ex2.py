from datetime import datetime
from pymongo import MongoClient


def insert_restaurant(collection):
    post = {"address": {'building': '1480', 'coord': [-73.9557413, 40.7720266],
                        'street': '2 Avenue', 'zipcode': '10075'},
            'borough': 'Manhattan',
            'cuisine': 'Italian',
            'grades': [{'date': datetime(2014, 10, 1), 'grade': 'A', 'score': 11}],
            "name": "Vella",
            "restaurant_id": "41704620"}
    return [collection.insert_one(post).inserted_id]


client = MongoClient("mongodb://localhost:27017")

db = client["db_name"]
collection = db.collection_name
print(*insert_restaurant(collection), sep="\n")
