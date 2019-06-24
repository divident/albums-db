import random
import sys
from timeit import default_timer as timer

from faker import Faker

from mongo_client import MongoConnection

fake = Faker()


def merge(x, y):
    z = x.copy()
    z.update(y)
    return z


def generate_albums(n):
    for _ in range(n):
        album = {
            "name": fake.word(ext_word_list=None),
            "year": fake.date_time_this_decade(before_now=True, after_now=False, tzinfo=None),
            "author": {"name": fake.name()},
            "price": random.randint(0, 100),
            "tracks": [track for track in generate_tracks(random.randint(3, 10))],
            "scores": [merge(user, {"score": random.randint(1, 10)}) for user in generate_users(random.randint(0, 5))]
        }
        yield album


def generate_tracks(n):
    for _ in range(n):
        track = {
            "name": fake.word(ext_word_list=None),
            "duration": random.randint(0, 500),
            "scores": [merge(user, {"score": random.randint(1, 10)}) for user in generate_users(random.randint(0, 5))]
        }
        yield track


def generate_users(n):
    for _ in range(n):
        user = {
            "name": fake.first_name(),
            "lastname": fake.last_name(),
            "email": fake.email()
        }

        yield user


def test_performance(albums, n):
    for i, album in enumerate(generate_albums(n)):
        albums.insert_one(album)
        sys.stdout.write("\rInserted %d albums" % i)
        sys.stdout.flush()
    sys.stdout.write("\r%d\n" % n)
    sys.stdout.flush()

    start = timer()
    for album in albums.find():
        pass

    end = timer()
    print(f"Finished tests for {n} data size")
    return end - start


def main():
    conn = MongoConnection()
    db = conn.client.get_database("wat")
    db.albums.drop()
    albums = db.albums
    tests = (100000, 150000, 250000)
    results = []
    for test in tests:
        results.append(test_performance(albums, test))
    print(' '.join(map(str, results)))


if __name__ == "__main__":
    main()
