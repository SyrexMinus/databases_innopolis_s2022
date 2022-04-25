from pymongo import MongoClient


def delete_single_manhatten_restaurant(collection):
    return collection.delete_one({"borough": "Manhattan"})


def delete_all_thai_cuisines(collection):
    return collection.delete_many({"cuisine": "Thai"})


client = MongoClient("mongodb://localhost:27017")

db = client["db_name"]
collection = db.collection_name
delete_all_thai_cuisines(collection)
