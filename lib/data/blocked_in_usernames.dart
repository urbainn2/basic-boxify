import 'package:boxify/data/replace_tuples.dart';

import 'bad_strings.dart';

const blockedInUserNamesOnly = [
  'fart',
  '69',
  'ass',
  'anger',
  'gay',
  'ball',
  'simp',
  'rights',
  'feg',
  'egg',
  'ryd',
  'yder',
  'cropper',
  'sharp',
  'wilson',
  'bell',
  'shriner',
// # "pee",
// # "poo",
  'cuomo',
  'kyoko',
  'river',
  'booger',
  'weez',
  'brian',
  'pat',
  'matt',
  'scott',
  'jason',
  'mia',
  'leo',
  'karl'
];

final blockedInUsernames =
    (blockedInUserNamesOnly + allBadStrings + allBadReplaceWithSpecificKeys)
        .map((x) => x.replaceAll(' ', ''))
        .toList();
