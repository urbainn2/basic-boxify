class SearchHelper {
  SearchHelper();

  String sanitizeQuery(String text, {int queryThreshold = 0}) {
    // Convert to lower case
    text = text.toLowerCase();

    text = text.replaceAll('.',
        ''); // Remove periods because the 'nonword' regex below doesn't get em

    // Always remove apostrophes
    text = text.replaceAll(RegExp(r"\'"), '');

    // // Remove all non-word characters (anything other than a-z, A-Z, 0-9, and _)
    // text = text.replaceAll(RegExp('r[^\w\s]'), '');

    // Finally, remove all white space characters
    text = text.replaceAll(RegExp(r'\s'), '');

    // if (text.length > queryThreshold) {
    //   // Remove 'the' at the start of the string, if the text length is more than `queryThreshold`
    //   text = text.replaceAll(RegExp(r'^the\b'), '');
    // }

    return text;
  }
}
