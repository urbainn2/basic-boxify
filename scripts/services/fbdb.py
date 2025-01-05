import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os


credential_path = (
    r"C:\Users\aethe\Desktop\flutter-apps\boxify\secrets\rivers-private-f88a05678815.json"
)
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credential_path

project_id = "rivers-private"


def test_firestore_client(collection_name, doc_id):
    """
    Okay I'm trying this test function because yesterday I had the wrong credentials and the bad client used up my entire daily allowance after a few runs that produce no results. Hopefully this works. 
    I'm worried I'm going to have the same problem on collection.document.Get. it should air out and quit
    """
    print("Credentials path:", os.environ['GOOGLE_APPLICATION_CREDENTIALS'])

    db = firestore.Client()
    collection = db.collection(collection_name)
    # print(collection)
    document = collection.document(doc_id).get()
    # print(document)

    db.close()

    if document.exists:
        print("Document data:", document.to_dict())
        return True
    else:
        print("Document not found")
        return False
