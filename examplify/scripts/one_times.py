from dotenv import load_dotenv
import argparse


# 1. Load .env first (before anything else uses os.environ)
load_dotenv()

from boxify_scripts.firestore_one_times import *


# migrate_release_date_field()
# delete_release_date_field()