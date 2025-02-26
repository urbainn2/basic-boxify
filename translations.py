
import json
import openai
import os


def fetch_openai_completion(text: str, lang: str):
    model = "gpt-3.5-turbo"

    prompt = ("I am developing a music player app similar to Spotify. I'm now doing the localizations and translations for all"
              f"text that appears in the app. Please translate the following English text to {lang} and try to use"
              f" terminology that most applications would use: {text}. As an example if we're translationg English to Spanish, instead of translating 'home' to 'hogar' use 'inicio'."
              "Return only the translated word, trimmed, without any other text. I'm going to paste your response into a JSON file.")

    messages = [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": prompt}
    ]

    try:
        response = openai.chat.completions.create(
            temperature=.3,
            max_tokens=100,
            model=model,
            messages=messages,
        )
        text = response.choices[0].message.content
        print(text)
        return text

    except openai.error.OpenAIError as e:
        text = f"An error occurred: {e}"
        print(text)


def process_languages2(supported_languages):

    openai.api_key = os.getenv('OPENAI_API_KEY')

    # Read the contents of the 'en' file as a JSON dictionary
    with open('boxify/assets/translations/en.json', 'r', encoding='utf-8') as f:
        en_dict = json.load(f)

    # Process each supported language
    for lang in supported_languages:
        print('Creating or updating file for language:', lang)

        # Load the current language's file if it exists, otherwise use an empty dictionary
        lang_file_path = f'boxify/assets/translations/{lang}.json'
        if os.path.exists(lang_file_path):
            with open(lang_file_path, 'r', encoding='utf-8') as f:
                lang_dict = json.load(f)
        else:
            lang_dict = {}

        # Determine which keys need to be translated
        keys_to_translate = [
            key for key in en_dict if key not in lang_dict or not lang_dict[key]]

        # Fetch translations for missing keys
        for key in keys_to_translate:
            print(f'Looking up translation for key: {key}', end='... ')
            lang_dict[key] = fetch_openai_completion(en_dict[key], lang)
            print('Done')

        # Save the updated dictionary back to the file
        with open(lang_file_path, 'w', encoding='utf-8') as f:
            json.dump(lang_dict, f, ensure_ascii=False, indent=4)


def process_languages(supported_languages):
    openai.api_key = os.getenv('OPENAI_API_KEY')

    # Open and read the contents of the 'en' file
    with open('boxify/assets/translations/en.json', 'r', encoding='utf-8') as f:
        # Use json.load to read the JSON contents
        en_dict = json.load(f)

        for lang in supported_languages:
            print('Creating or updating file for language:', lang)
            lang_file_path = f'boxify/assets/translations/{lang}.json'

            # Initialize an empty language dictionary
            lang_dict = {}

            # Check if language file exists and load it
            if os.path.exists(lang_file_path):
                try:
                    with open(lang_file_path, 'r', encoding='utf-8') as f:
                        # Use json.load to read the JSON contents
                        lang_dict = json.load(f)
                except json.JSONDecodeError:
                    pass

            # Add missing keys from the English dictionary
            for key, value in en_dict.items():
                if key not in lang_dict:
                    lang_dict[key] = ''

            # Fetch translations for empty strings
            for key, value in en_dict.items():
                if lang_dict[key] == '':
                    print(f'Looking up translation for key: {key}...', end=' ')
                    lang_dict[key] = fetch_openai_completion(value, lang)

            # Now save the updated dictionary to the file
            with open(lang_file_path, 'w', encoding='utf-8') as f:
                # Use json.dump to write the JSON contents
                json.dump(lang_dict, f, ensure_ascii=False, indent=4)


def main():

    supported_languages = ['es', 'fr', 'de', 'it', 'pt',  'zh', 'ja', 'ko', 'ar',
                           # filipino
                           'tl',
                           # indonesia
                           'id', 'cs', 'nl', 'pl', 'nn',

                           'sv']

    # let's start with just spanish and japanese
    # supported_languages = ['es', 'ja']

    # first let's get the contents of the 'en' file
    process_languages(supported_languages)

    # fetch_openai_completion('Home', 'de')


if __name__ == '__main__':
    main()
