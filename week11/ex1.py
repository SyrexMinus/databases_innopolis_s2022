from pymongo import MongoClient


def query_all_indian_cuisines(collection):
    return collection.find({"cuisine": "Indian"})


def query_all_indian_and_thai_cuisines(collection):
    return collection.find({"$or": [{"cuisine": "Indian"}, {"cuisine": "Thai"}]})


def query_restaurant_with_address(collection):
    return collection.find({"$and": [{"address.building": "1115"}, {"address.street": "Rogers Avenue"},
                                     {"address.zipcode": "11226"}]})


client = MongoClient("mongodb://localhost:27017")

db = client["db_name"]
collection = db.collection_name
print(*query_restaurant_with_address(collection), sep="\n")
