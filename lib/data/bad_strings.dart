// """ ALL USERS """
// WILL PRINT MESSAGE WITHOUT STRING
// RIGHT NOW THIS IS CASE SENSTITIVE
List<String> stringsToDelete = [
  '<',
  ':)',
  '):',
  ': )',
  ';)',
  '：）',
  '(:',
  ':-)',
  ':O)',
  '=)',
  ';×',
  ';)',
  '; )',
  '{:',
  ':/ ',
  ':/.',
  ':D',
  ':(',
  ';(',
  '~_-',
  'tm)',
  'TM)',
  ':p',
  ':]',
  '[:',
  '<3',
  '^_^',
  ':}',
  "}':",
  ':-[',
  ':-]',
  ': ]',
  ':[',
  ' xo',
  'emoji',
  'E m o j i s',
  ' emoticon',
  'youtu.be',
  'open.spotify',
  'smiley face',
  'imgur',
  'twitter.com/',
  '/status/',
  '*exclamation*',
];

List<String> stringsToDeleteCaseInsensitive = [
  // "LOL",
  // "L0L",
  // "l.0.L",
  // "L o l",
  // "Lol",
  // "L. O . L.",
  // "l.o.l.",
  'lmfao',
  'lmao',
  'LMFÀO',
  'elle oh elle',
  'omg',

// These prepend Rivers
  // "robo",
  // "r0bo",
  // "rob0",
  // "r0b0",

  'fuck',
  'titty', 'tiddy', 'tittie',
  'fck', 'fûck', '4uck',
];

List<String> squiggles = [
  '‽',
  '☆',
  '✧',
  '┊',
  '❀',
  '-_-',
  ':D',
  '㋛',
  '.:',
  '³',
  '˘',
  '♡',
  '^',
  '▽',
  'ノ',
  '‿',
  ' ｡^‿^｡',
  '⊡',
  ' ⸌⍤⃝⸍',
  '･゜ﾟ･*^O^/*･゜ﾟ･*',
  '°͜ ',
  'ʖ',
  '.｡.',
  '≧',
  '▽',
  '≦',
  '.｡.:*',
  '￣^ゞ',
  '⁎⁍̴̆Ɛ⁍̴̆⁎',
  '╰*´︶`*╯♡',
  '.°ಗдಗ。°.',
  'ʕ',
  'ᴥ',
  '•',
  'ʔ',
  '。-∀-)',
  '● ˃̶͈̀ロ˂̶͈́)੭ꠥ⁾⁾',
  '꒳',
  '（ゝ。∂',
  '´-`',
  '◕',
  '△',
  '0_0',
  '°',
  ':|',
  '._.',
  '/:',
  '(_O_)',
  '(__+__)',
];

List<String> wordsWithoutPunctuation = [
  'whats',
  ' im ',
  'youre',
  'theyre',
  'dont',
  ' cant',
  'didnt',
];

List<String> spamToReplaceWithComposer = [
  '100 gecs',
  '100 geckos',
  'one hundred gecs',
  'billie joe ',
  // "billie joe armstrong",
  'pete wentz',
  'patrick stump',
  'tre cool',
  'tres cool',
  'mike dirnt',
  'mike durnt',
];

List<String> verbsToReplace = [
  'censor',
  'subs out',
  'simp ',
  'gatekeep',
  'fuckwit',
  'block'
];
// # https://studentsandwriters.com/2018/02/09/funny-mad-libs-word-lists-adjectives-nouns-and-verbs-2/

List<String> adjectivesToReplace = [
  'toxic',
  'greyed out',
  'replaced',
];

// # ALL USERS, IN MESSAGE.LOWER()
List<String> nounsToReplace = [
  'weezercord',
  'exclamation point',
  'chungus',
  'discord',
  'disc*rd',
  'disschord',
  'noob',
  'newb',
  'censorship',
  'text substitution',
  'fonts',
  'subreddit',
  'r e d d i t',
  'reddit',
];

List<String> bandsToReplace = [
  'green day',
  'fall out boy',
  'gd',
  'fob',
  'f o b'
];

// # ALL USERS, IN MESSAGE.LOWER()
List<String> phrasesToReplaceWithRandom2 = [
  'asswipe',
  'random phrase',
  'random word',
  'asian fetish',
];

// # ALL USERS, IN MESSAGE.LOWER()
List<String> phrasesToReplaceWithRandom4 = [
  // "greeen",
  // "green",
  // "grean",
  // "greeeen",
  // "graen",

  // 'bawt',
  // " bt",
  // " ai ",
  // " bot ",
  // "bôt"
  //     "b0+",
  // "riversbot",

  // "R0b0",
  // "R0-b0",
  // "r 0 b 0",
  // "ロボ",
  // "b o t",
  // "b 0 t",
  // "b0t",
  // "bot ",
  // "bot.",
  // "robot.",
  // "ro bo t",
  // "bot?",
  // "b*t",
  // "b.o.t",
  // "bo.t",
  // "b^t",
  // "b-oh-t",
  // "baht",
  // "botrivers",
  // "algorivm",
  // "robut",
  ' troll',
  'tr oll',
  't r o l l i n g'
      'tr0ll',
  'T R 0 L L',
  // "AI",
  'mlp mason jar',
  ' sim ',
  // "fall out boy"
];

List<String> allBadStrings = stringsToDelete +
    stringsToDeleteCaseInsensitive +
    // wordsWithoutPunctuation +
    spamToReplaceWithComposer +
    verbsToReplace +
    adjectivesToReplace +
    nounsToReplace +
    phrasesToReplaceWithRandom2 +
    phrasesToReplaceWithRandom4;
