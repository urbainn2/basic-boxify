#Common

Python Scripts and functions that are common to RiverTunes and Weezify flutter packages.

20220-08-30
Fixed create_database_rows_from_files() to set the uuid in the database rows of tracks table. (It was still using localpath and therefore succeeding functions weren't finding the tracks.)