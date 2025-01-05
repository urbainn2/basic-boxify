# from .config import *
from random import shuffle
from rich import print
from .utils import divide_chunks, get_docs, batch_commit
from firebase_admin import firestore
from datetime import datetime
import eyed3  # For MP3s
from eyed3.id3 import Tag
from eyed3.id3 import ID3_V1_0, ID3_V1_1, ID3_V2_3, ID3_V2_4
import os
import pathlib
from common_env.env import *
eyed3.log.setLevel(
    "ERROR"
)  # https://stackoverflow.com/questions/22403189/python-eyed3-warning


class LocalObject():
    def __init__(self, path, localpath):
        self.path = path
        self.localpath = localpath
        self.filename = localpath.split("\\")[-1]
        self.source = get_source(localpath)
        self.filename
        self.tag = self.source.tag
        self.utfs = self.tag.user_text_frames
        self.uuid = get_uuid(self.utfs)


def assign_sequence(all_updates, start=100):
    """assign_sequence from {start}. Reserve the first {start} for szns or special songs."""

    print("\nassign_sequence")

    shuffle(all_updates)
    for i, fu in enumerate(all_updates, start=100):

        fu["field_updates"]["sequence"] = i
        # print(fu)
    return all_updates


def create_database_rows_from_files(db, root: str, demo_tablename: str):
    """
    If there are any files that haven't been added to the tracks collection yet, this function will add them. Just uuid field for now.
    """
    print("\ncreate_database_rows_from_files", root, demo_tablename)
    print("Note: if you're adding a new track to a Weezify bundle, make sure you set its bundle property in Mp3Tag. Also consider setting its release_date to an empty string.")
    collection = db.collection(demo_tablename)

    records = collection.stream()
    dicts = [x.to_dict() for x in records]
    print(len(dicts))

    existing_uuids = [x["uuid"] for x in dicts if "uuid" in x]

    docs = []

    for path, subdirs, files in os.walk(root):
        for filename in files:
            if ".MP3" in filename:
                print(f"you should convert to lowercase mp3: {filename}")
                exit()

            localpath = str(pathlib.PurePath(path, filename))

            if localpath[-4:] != ".mp3":
                # print(f"{localpath} is not an mp3, so skipping")
                continue

            # create an eyed3 object to represent the file info
            source = get_source(localpath)

            tag = source.tag
            utf = tag.user_text_frames
            uuid_frame = utf.get("uuid")

            try:
                if uuid_frame is None:
                    raise Exception(
                        f"WARNING. uuid_frame {uuid_frame} not found in local_uuid_dict for {localpath}: Did you mean to add this file to the database? Maybe did you convert it with WAV Sound Converter? Exiting!!")
            except Exception as e:
                print(e)

            uuid = uuid_frame.text

            if uuid in existing_uuids:
                # print(f"{uuid} already has a row in the database, so skipping....")
                continue

            print(
                f"{filename} does not have a row in the database, so adding....")

            # ref = collection.document()
            data = {"uuid": uuid}

            # refs.append((ref, data))
            docs.append(data)

    if not docs:
        print("no new files on your local computer so nothing added to the database")
        return

    # refs is a list of dictionaries. Each ref dictionary contains a single key-value pair. "uuid": uuid.

    # I have not tested this yet
    batch_commit(db, demo_tablename, docs, "create")

    # This old commit def works

    # chunks = divide_chunks(refs, 500)

    # for chunk in chunks:

    #     batch = db.batch()

    #     for tup in chunk:
    #         print(tup[1])

    #         # Add the ref and the data (containing only the localpath)
    #         batch.set(tup[0], tup[1])

    #     print("Please wait while commiting  new objects to database...")
    #     batch.commit()
    print("Done!")


def delete_db_rows_without_local_files(db, root, demo_tablename):
    """
    Will delete any rows in a table that don't a matching file in a particular root on your computer.
    Get the names of all the files in the root
    and then delete any db rows that aren't contained in that list.
    """
    print("\ndelete_db_rows_without_local_files")

    all_updates = []
    local_objects = get_local_demo_objects(root)
    local_uuids = [x.uuid for x in local_objects]
    print("local_uuids", len(local_uuids))

    docs = get_docs(db, demo_tablename)
    print('docs', len(docs))
    # for d in docs:
    #     track = {}
    #     ddict = d.to_dict()

    # if "title" not in ddict or "localpath" not in ddict:
    #     print("no title or localpath, so skipping")
    #     continue

    docs = [
        {
            "id": x.id,
            # "localpath": x.to_dict()["localpath"],
            "uuid": x.to_dict()["uuid"]
            if "uuid" in x.to_dict()
            else None,
        }
        for x in docs
    ]
    batch = db.batch()
    count = 0
    for doc in docs:
        # If you've gone through the entire filelist and haven't found a local match for this db row
        if doc["uuid"] not in local_uuids or doc["uuid"] is None:
            print(
                f"uuid {doc['uuid']} doesn't a local file with the same uuid, so deleting from firestore...")
            count += 1
            ref = db.collection(demo_tablename).document(doc["id"])
            batch.delete(ref)
    if count == 0:
        print("No rows to delete")
        return
    else:
        print(f"{count} rows to delete")
        batch.commit()
        print("deleted!")


def fetch_tracks(db, to_table_name, test_file_id=None, limit=None):
    print("fetching firestore tracks")
    if test_file_id:
        tracks_ref = db.collection(to_table_name).document(test_file_id)
        return [tracks_ref.get()]
    else:
        tracks_ref = db.collection(to_table_name).limit(limit)
        return list(tracks_ref.stream())


def get_updates(local_object, fields):
    # print("get_updates")

    tag = local_object.tag
    localpath = local_object.localpath
    source = local_object.source
    path = local_object.path
    utf = local_object.utfs
    string_fields, int_fields, float_fields = fields
    # print(path)

    field_updates = {
        "title": tag.title,
        "localpath": localpath,
        "album": tag.album,
        "composer": tag.composer,
        "artist": tag.artist,
        "bpm": tag.bpm,

        # When the mp3 file was last processed
        # by tracks.py on your local computer
    }

    if source.info:
        field_updates["length"] = int(source.info.time_secs)
    else:
        print(
            f"WARNING. could not get info for eyed3 object for {localpath}"
        )

    if utf.get("url"):
        field_updates["link"] = utf.get("url").text.replace(
            "dl=0", "raw=1"
        )

    # Fields that can only be updated on my computer (That is, that can't be set from the app)
    # and will be deleted from firestore # if they're not in the local file.
    for f in string_fields:

        if utf.get(f) and utf.get(f).text != "":
            text = utf.get(f).text
            field_updates[f] = text
        else:
            field_updates[f] = firestore.DELETE_FIELD

    for f in int_fields:
        if utf.get(f) and utf.get(f).text != "":
            try:
                text = utf.get(f).text
                field_updates[f] = int(text)
            except ValueError:
                print(
                    f"WARNING. {f} is not an integer in {localpath}"
                )
                # field_updates[f] = None
        else:
            field_updates[f] = firestore.DELETE_FIELD

    for f in float_fields:
        if utf.get(f) and utf.get(f).text != "":
            field_updates[f] = float(utf.get(f).text)
        else:
            field_updates[f] = firestore.DELETE_FIELD

    # This has to come after the more generic 'string_fields_to_copy_from_files_to_firestore' otherwise it will be overwritten
    if utf.get("BUNDLE"):
        # print("BIG BUNDLE" + utf.get("BUNDLE").text)
        field_updates["bundle"] = utf.get("BUNDLE").text
    # # Deprecated
    # field_updates["BUNDLE"] = firestore.DELETE_FIELD

    field_updates["releaseDate"] = get_date_field(utf)

    # emergency fix to be undone after all clients can handle "YYYY-MM-DD" format
    field_updates["privateReleaseDate"] = datetime.now()
    # field_updates["privateReleaseDate"] = get_date_field(
    #     utf, "private_release_date")

    if utf.get("explicit"):
        field_updates["explicit"] = (
            utf.get("explicit").text.lower() == "y"
        )
    if utf.get("COPY_TO_BEST_OF") and (
        utf.get("COPY_TO_BEST_OF").text.lower() == "x"
    ):
        field_updates["best_of"] = True
    else:
        field_updates["best_of"] = firestore.DELETE_FIELD

    if tag.comments:
        comment = "".join(
            c.text for c in source.tag.comments if c.text != ""
        )
        field_updates["comment"] = comment

    if utf.get("image"):
        field_updates["image"] = utf.get("image").text

    # When the record was last updated on firestore
    field_updates["updated"] = firestore.SERVER_TIMESTAMP

    """ OTHER PATHS """
    # print(path)
    # print(path.split("\\")[-1])

    # This is the name of the last directory the file is actually in
    field_updates["directory"] = path.split("\\")[-1]

    folder = path.replace(
        DROPBOX_HOME, ""
    )

    # Really only used for Private? SZNS/1. Spring--Stress Free
    field_updates["folder"] = folder

    if "\\Boxify\\" in folder:

        role = None

        role_folder = folder.split("\\")[3]

        if role_folder == "Admin":
            role = "admin"
        elif role_folder == "Weezer":
            role = "weezer"
        elif role_folder == "Collaborators":
            role = "collaborator"
        if role:
            field_updates["role"] = role

    return field_updates


today_string = datetime.today().strftime("%Y-%m-%d")


def get_date_field(utf, field="release_date"):
    """
    Returns a date string in the format YYYY-MM-DD.
    Spotify saves as string, so we'll save as string.
    """

    # Get the release date from the mp3 file
    date = utf.get(field).text if utf.get(
        field) else None

    # If there's no date, set it to today
    if not date or date == '':
        date = today_string

    # If the date is in the format 2021-01-01 00:00:00
    elif len(date) > 10:
        date = date[:10]

    # If the date is in the format 2021-01-01
    elif len(date) < 10:

        print(f"WARNING. {field} is not in the format %Y-%m-%d")

    return date


def get_local_demo_objects(root):
    """
    Just load them once before you iterate through firestore ojbects
    """
    print("get_local_demo_objects")
    local_objects = []
    for path, subdirs, files in os.walk(root):
        for filename in files:
            # print(path)
            localpath = str(pathlib.PurePath(path, filename))
            if localpath.endswith(".mp3"):
                local_objects.append(LocalObject(path, localpath))
    print(f"Found {len(local_objects)} local objects")
    # print([x.path for x in local_objects])
    return local_objects


def get_source(localpath):
    source = eyed3.load(localpath)

    if not source:
        print(
            f"\nWARNING. could not create an eyed3 object for {localpath}\nThe last time this happened, it turned out the file was empty.\n"
        )
        exit()

    if not source.tag:
        # print(f"WARNING. no tag for eyed3 object for {fullFilename}")
        print(f"\n{localpath} has no tag, so initializing tag now\n")
        source.initTag()
        # exit()
        # continue
    return source


def get_uuid(utfs):
    uuid_frame = utfs.get("uuid")
    if uuid_frame is None:
        raise Exception(
            f"WARNING.  has no uuid_frame {uuid_frame} You need to run demos.py first to create the uuid. Did you mean to add this file to the database?. Exiting!!")

    return uuid_frame.text

    def __str__(self):
        return f"{self.path}"


def update_database_rows_from_files(db, fields,
                                    root: str, demo_tablename: str, test_file_id=None, limit=None, sequence_these_tracks=False
                                    ):
    """
    Required arguments:
        root: the root folder of your dropbox folder
        demo_tablename: the name of the firestore collection
        fields: a list of lists of fields to update. The first list is string fields, the second is int fields, and the third is float fields.

    Optional arguments:
        test_file_id <pass a filename, including mp3 for testing>
        limit <to limit the number of demos you'll run from the demos table, starting at the first row.>

    This is the main function.
    It overwites data in the firestore database with the latest data
    from the mp3 file metadata on your computer.

    But I think it doesn't overwite fields not contained in this function,
    such as 'owner'?
    """
    print(
        f"update_database_rows_from_files({root}) to firestore: {demo_tablename} table | sequence_these_tracks: {sequence_these_tracks}"
    )

    tracks = fetch_tracks(db, demo_tablename, test_file_id, limit)

    all_updates = []
    local_objects = get_local_demo_objects(root)

    print(
        f"Processing field updates for {len(tracks)} rows in the firestore tracks table. This may take a while. Please be patient...")
    # Create a dictionary for quick lookups of 'local_objects' by 'uuid'.
    # This tries to optimize our function by reducing the original time complexity from O(n^2) to O(n),
    # where n is the number of total objects (tracks or local_objects). This means, for larger data sets,
    # the function's execution time will increase linearly, not exponentially, with the size of the data set.
    # In practice, with 3573 objects, it could speed up the function by approximately 3572 times.
    # This approach uses more memory to store the dictionary, but it generally shouldn't be a
    # problem unless the local objects are incredibly large or memory is particularly tight.
    # TL/DR was about 7 minutes, now instantaneous??
    local_uuid_dict = {
        local_obj.uuid: local_obj for local_obj in local_objects}

    for track in tracks:
        firestore_record = track.to_dict()
        firestore_uuid = firestore_record.get('uuid')
        # Check if the track's 'uuid' is in our 'local_uuid_dict' to avoid the time-consuming nested loop.
        if firestore_uuid and firestore_uuid in local_uuid_dict:

            field_updates = get_updates(
                local_uuid_dict[firestore_uuid], fields)

            ref = db.collection(demo_tablename).document(track.id)

            job = {
                "id": ref.id,
                "field_updates": field_updates,
            }
            all_updates.append(job)
        else:
            print(
                f"WARNING. firestore_uuid {firestore_uuid} not found in local_uuid_dict: {firestore_record}. This track will be deleted from firestore!!")

    if sequence_these_tracks == True:
        all_updates = assign_sequence(all_updates)

    # Had this as false but it was wiping out bundle image and bundle id.
    # With merge set to true, it will overwrite matching fields with new data here
    # but it won't delete fields that don't have data here.
    # I might want to add bundle id and bundle image to this function.
    # batch_update(refs, all_updates, merge=True)
    batch_commit(db, demo_tablename, all_updates, "update")
