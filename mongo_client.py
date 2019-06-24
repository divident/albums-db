from pymongo import MongoClient


class MongoConnection:
    def __init__(self):
        self._client = None

    @property
    def client(self):
        if not self._client:
            self._client = MongoClient('localhost', 27017)
        return self._client

    def get_db(self, db_name):
        return self.client.db[db_name]
