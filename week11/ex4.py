from datetime import datetime

from pymongo import MongoClient


def query_rogers_avenue_and_process(collection):
    many_c_restaurants = [
        *filter(lambda restaurant: len([*filter(lambda grade: grade["grade"] == "C", restaurant["grades"])]) > 1,
                [*collection.find({"$and": [{"address.street": "Rogers Avenue"}, {"grades.grade": "C"}]})])]
    for restaurant in many_c_restaurants:
        collection.delete_one({"_id": restaurant["_id"]})
    for restaurant in collection.find({"address.street": "Rogers Avenue"}):
        collection.delete_one({"_id": restaurant["_id"]})
        restaurant["grades"].append({'date': datetime(2014, 11, 28, 0, 0), 'grade': 'C', 'score': 13})
        collection.insert_one(restaurant)


client = MongoClient("mongodb://localhost:27017")

db = client["db_name"]
collection = db.collection_name
print(len([*collection.find({"address.street": "Rogers Avenue"})]))
query_rogers_avenue_and_process(collection)
print(len([*collection.find({"address.street": "Rogers Avenue"})]))
