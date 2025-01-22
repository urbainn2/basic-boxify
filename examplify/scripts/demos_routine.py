from dotenv import load_dotenv
# 1. Load .env first (before anything else uses os.environ)
load_dotenv()

# 2. Now import modules that rely on those environment vars
from boxify_scripts.demos_routine import daily_routine
from constants import best_of_playlist_ids, piano_playlist_id


def main():
    daily_routine()


if __name__ == "__main__":
    main()
