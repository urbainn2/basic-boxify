from dotenv import load_dotenv
# 1. Load .env first (before anything else uses os.environ)
load_dotenv()

# 2. Now import modules that rely on those environment vars
from boxify_scripts.playlists.playlist_scripts import update_best_of_playlists_tracks_and_total, update_all_playlists, daily_routine, update_new_releases_playlist_tracks_and_total
from boxify_scripts.playlists_one_times import add_highest_rated_playlist
from constants import best_of_playlist_ids, piano_playlist_id, rivers


def main():
    # update_best_of_playlists_tracks_and_total(best_of_playlist_ids)
    # update_all_playlists(piano_playlist_id)
    update_new_releases_playlist_tracks_and_total(rivers)
    # daily_routine(piano_playlist_id, best_of_playlist_ids)
    # add_highest_rated_playlist()


if __name__ == "__main__":
    main()
