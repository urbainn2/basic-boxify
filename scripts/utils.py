import os
import pathlib
# from services.fbdb import db, firestore
from rich import print
from google.cloud.firestore import Client

import asyncio
import concurrent.futures
from typing import Generator, List, Any


def batch_commit(db: Client, collection: str, documents: list, operation_type: str = "update"):
    """
    Commits a batch of creations, updates, or deletes to a Firestore collection.

    Args:
    db (Client): Firestore client instance.
    collection (str): Name of the Firestore collection to commit operations on.
    documents (list): List of document information for the operations to be performed. 
    operation_type (str, optional): Type of operation to commit. Can be 'update', 'delete', or 'create'. Defaults to 'update'.
        - For 'create' operation, it's a list of dictionaries, each representing a document to be created. this actually calls .set()
        - For 'update' or 'delete' operation, each item is a dictionary containing 'id' 
            and 'field_updates' for 'update' operation.

    Example:

    documents = [{'field1':'value1'}, {'field1':'value1', 'field2':'value2'}]
    batch_commit(db, 'myCollection', documents, 'create')

    documents = [{'id':'doc1', 'field_updates':{'field1':'updatedValue1'}}, {'id':'doc2', 'field_updates':{'field2':'updatedValue2'}}]
    batch_commit(db, 'myCollection', documents, 'update')

    documents = [{'id':'doc1'}, {'id':'doc2'}]
    batch_commit(db, 'myCollection', documents, 'delete')

    Note:
    Due to Firestore's limit of 500 writes per batch, this function divides operations into chunks of 500.
    This function is async-compatible and runs in a separate thread pool.
    """

    print(f"..batch_commit: {len(documents)} {operation_type}s")

    # Divide the operations into chunks of 500, as Firestore has a limit of 500 writes per batch
    chunks = divide_chunks(documents, 500)
    chunk_count = (len(documents) // 500) + 1

    # Prepare list to store all WriteBatch instances
    batches = []

    # Process each chunk of operations
    for i, chunk in enumerate(chunks, start=1):
        print(f"processing batch {i} of {chunk_count}")

        # Create a new WriteBatch instance for each chunk
        batch = db.batch()

        for doc in chunk:

            # Note, in the case of 'create' operation, no 'id' is provided, so doc_id will be None
            # and doc_ref will be a new document with a randomly generated ID
            doc_id = doc["id"] if "id" in doc else None
            doc_ref = db.collection(collection).document(doc_id)

            if operation_type == "create":
                fields = doc
                batch.set(doc_ref, fields, merge=True)

            elif operation_type == "update":

                """
                I ended up removing this block because Rivify was creating new documents
                when I accidentally were looking up tracks with an id that had been set with its uuid.

                If Rivify can't find a matching track document, it should not create a new one.
                """

                # if not doc_ref.get().exists:  # Check if the document exists
                #     fields = doc["field_updates"]
                #     batch.set(doc_ref, fields, merge=True)
                # # If not, create it
                # else:
                field_updates = doc["field_updates"]
                batch.update(doc_ref, field_updates)

            elif operation_type == "update-or-create":
                field_updates = doc["field_updates"]
                batch.set(doc_ref, field_updates, merge=True)

            elif operation_type == "delete":
                batch.delete(doc_ref)

        # Append WriteBatch to the batches list
        batches.append(batch)

    loop = asyncio.get_event_loop()
    # Use a thread pool, as Firestore client isn't asyncio-compatible
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [loop.run_in_executor(
            executor, b.commit) for b in batches]
    # Run all batch.commit concurrently and wait for all to finish.
    loop.run_until_complete(asyncio.gather(*futures))


# @deprecating in favor of GPT's above to handle delelte operations


def batch_commit_old(db, collection: str, all_updates: list):
    """
    Use this one.
    collection: str, all_updates: list

    It calls batch.update()
    which does not create? but not auto merge
    """

    chunks = divide_chunks(all_updates, 500)
    chunk_count = len(all_updates) / 500

    print(f"batch_commit: {len(all_updates)} updates")

    for i, all_updates in enumerate(chunks):
        print(f"updating batch {i} of {chunk_count}")

        batch = db.batch()

        for job in all_updates:
            # pprint(job)
            # pprint(job["field_updates"]["id"])
            batch.update(
                db.collection(collection).document(
                    job["id"]), job["field_updates"]
            )

        batch.commit()


def divide_chunks(l: List[Any], n: int) -> Generator[List[Any], None, None]:
    """
    Generator that yields successive n-sized chunks from the list.

    Args:
    l (List[Any]): The input list from which to generate chunks.
    n (int): The size of each chunk.

    Yields:
    Generator[List[Any], None, None]: A generator object which can be iterated  
    to get chunks of the list.

    Example:

    list = [1, 2, 3, 4, 5, 6]
    result = list(divide_chunks(list, 2))
    print(result)  # output: [[1, 2], [3, 4], [5, 6]]
    """

    # looping till length l
    for i in range(0, len(l), n):
        yield l[i: i + n]


def get_db_ids(db, collection):
    return [x.id for x in db.collection(collection).stream()]


def get_docs(db, collection, limit=None):
    """
    Get a list of firestore collection objects
    """
    print("..get_docs")
    return list(db.collection(collection).limit(limit).stream())


def get_docs_with_ids(db, collection: str, limit=None):
    docs = list(db.collection(collection).limit(limit).stream())

    response = []

    for doc in docs:
        data = {"id": doc.id, "data": doc.to_dict()}
        response.append(data)
    return response


def get_all_track_localpaths(root):
    localpaths = []

    for path, subdirs, files in os.walk(root):
        # print(files)
        # continue

        # Iterate through each file in the folder
        for filename in files:

            localpath = str(pathlib.PurePath(
                path, filename))

            localpaths.append(localpath)

    return localpaths


# deprecated
def batch_update(db, refs, all_updates, merge):
    """
    DEPRECATED
    THIS MIS-MATCHES THE REF.ID AND THE DOCUMENT

    Instead use batch_commit
    """

    print(len(refs)),
    print(len(all_updates))
    print(merge)

    ref_chunks = divide_chunks(refs, 500)
    field_chunks = divide_chunks(all_updates, 500)

    for refs, all_updates in zip(ref_chunks, field_chunks):
        batch = db.batch()
        for ref, field_updates in zip(refs, all_updates):
            # print(ref.id, field_updates["title"])

            # print(ref.id, field_updates)

            # Fantastic explanation of difference between set, update:
            # https://stackoverflow.com/questions/46597327/difference-between-set-with-merge-true-and-update

            # set without merge will overwrite a document or create it if it doesn't exist yet
            batch.set(ref, field_updates, merge=merge)

        # # set with merge will update fields in the document or create it if it doesn't exists,
        # # update will update fields but will fail if the document doesn't exist,
        # # batch.update(ref, field_updates)print(f"Please wait while committing  changes to demos db...")
        # batch.commit()
    print("Done!")
