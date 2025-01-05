import 'package:flutter/material.dart';
import 'package:boxify/app_core.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<MyBadge> badges = [
  MyBadge(
    title: 'Biographical Researcher',
    description:
        "Combs the archives for rare Cuomo data. Stuff that even Rivers doesn't know or have.",
    powers: '',
    icon: const Icon(Icons.mp_rounded),
    color: Colors.yellow,
  ),
  MyBadge(
    title: 'Yuki',
    description:
        'Enigmatic take on reality. Impossible to pin down. Always surprising.',
    powers: '',
    icon: const Icon(Icons.five_g),
    color: Colors.yellow,
  ),
  MyBadge(
    title: 'Tour Guide',
    description: 'Shows Rivers around.',
    powers: '',
    icon: const Icon(Icons.person_outline),
    color: Colors.yellow,
  ),
  MyBadge(
    title: 'Setlist Expert',
    description: 'Completed the setlist survey.',
    powers: '',
    icon: const Icon(Icons.cell_wifi),
    color: Colors.yellow,
  ),
  MyBadge(
    title: 'Night Watchman',
    description: 'When others are asleep.',
    powers: 'Moderation',
    icon: const Icon(Icons.family_restroom_outlined),
    color: Colors.yellow,
  ),
  MyBadge(
    title: 'Calm',
    description:
        'not showing or feeling anger or other strong emotions. the absence of violent or confrontational activity within a place or group. makes us tranquil and quiet; soothes.',
    powers: 'Moderation',
    icon: const Icon(Icons.sledding_outlined),
    color: Colors.yellow,
  ),
  MyBadge(
    title: 'Court Stenographer',
    description:
        'A court reporter or court stenographer,[1] formerly referred to as a stenotype operator, shorthand reporter, or law reporter,[2] is a person whose occupation is to capture the live testimony in proceedings using voice writing and/or a stenographic machine, thereby transforming the proceedings into an official certified transcript by nature of their training, certification, and usually licensure.',
    powers: '',
    icon: const Icon(Icons.airline_seat_flat_angled),
  ),
  MyBadge(
    title: 'Supporter',
    description: 'Purchased 10 bundles.',
    powers: '',
    icon: const Icon(Icons.accessible_forward_outlined),
  ),
  MyBadge(
    title: 'Champion',
    description: 'Purchased 20 bundles.',
    powers: '',
    icon: const Icon(Icons.sailing),
  ),
  MyBadge(
    title: '100+',
    description: 'Has rated at least 100 demos in the Player.',
    powers: '',
    icon: Icon(MdiIcons.plus),
  ),
  MyBadge(
    title: '400+',
    description: 'Has rated at least 400 demos in the Player.',
    powers: '',
    icon: Icon(MdiIcons.plus),
  ),
  MyBadge(
    title: '1000+',
    description: 'Has rated at least 1000 demos in the Player.',
    powers: '',
    icon: Icon(MdiIcons.plus),
  ),
  MyBadge(
    title: 'Entertainer',
    description: 'Performs live on RiverTube.',
    powers: '',
    icon: Icon(MdiIcons.piano),
  ),
  MyBadge(
    title: 'Welcome Committee',
    description:
        'Welcome new chatters and help them. Set a neighborly example.',
    powers: '',
    icon: const Icon(Icons.emoji_people_outlined),
  ),
  MyBadge(
    title: 'Artist',
    description: 'Create visuals like the homepage and logo.',
    powers: '',
    icon: const Icon(Icons.image_outlined),
  ),
  MyBadge(
    title: 'Curator',
    description: 'Curate bundles. Rate songs.',
    powers: 'Edit SONG LIST.',
    icon: const Icon(Icons.star_rate),
  ),
  MyBadge(
    title: 'Camp Counselor',
    description:
        'Coordinates the efforts of the residents who wish to work. Go-between between them and Rivers.',
    powers: 'Edit to-do list. Can post links in the chat.',
    icon: const Icon(Icons.assignment),
  ),
  MyBadge(
    title: 'Eagle Ears',
    description:
        'Identify demos that should be moved from bundle to bundle or removed altogether.',
    powers: '',
    icon: const Icon(Icons.fact_check_outlined),
    color: Colors.red,
  ),
  MyBadge(
    title: 'Eagle Brain',
    description: 'Identifies security issues in the code.',
    powers: '',
    icon: const Icon(Icons.fact_check_outlined),
    color: Colors.red,
  ),
  // MyBadge(
  //   title: "Technical Advisor",
  //   description:
  //       "Identifies security issues in the code.",
  //   powers: "",
  //   icon: Icon(Icons.fact_check_outlined),
  // ),
  MyBadge(
    title: 'Librarian',
    description:
        'Keep track of Rivers related stories. Create new articles. Correct errors. Maintain consistent formatting across the library.',
    powers:
        'Create articles without approval.  Approve, revert, and delete articles. Delete bad tags at /tags.',
    icon: const Icon(Icons.local_library_outlined),
    // oldId: "244",
    // # "users" : [
    // #     "Olivia",
    // #     "Tiffany",
    // #     "TragicGurl",
    // #     'geewiz',
    // #     "parkerthegreat",

    // #     ]
  ),
  MyBadge(
    title: 'Archivist',
    description: 'Maintains the Song List spreadsheet. Adds tag information.',
    powers: 'Edit the Song List spreadsheet.',
    icon: const Icon(Icons.school_outlined),
    // oldId: "245",
    // # "users" : [
    // #     "geewiz",
    // #     "Tiffany",
    // #     "brokenbeatendown",
    // #     ]
  ),
  MyBadge(
    title: 'Customer Service',
    description:
        'Handles email coming into riverscuomo.com, especially problems with bundle orders.',
    powers: 'Has a riverscuomo.com email address. And has access to my email.',
    icon: const Icon(Icons.question_answer_outlined),
    // oldId: "246",
    // # "users" : [
    // #     "lisa",
    // #     ]
  ),
  MyBadge(
    title: 'HTML/CSS Expert',
    description: 'Helps other neighbors decorate their homes.',
    powers: '',
    icon: const Icon(Icons.line_style_outlined),
    // oldId: "247",
    // # "users" : [
    // #     "M3D",
    // #     "sarahdanielle",
    // #     "gracz"
    // #     ],
  ),
  MyBadge(
    title: 'Developer',
    description: 'Writes programs to augment the Neighborhood.',
    powers: '',
    icon: const Icon(Icons.block_outlined),
    // oldId: "248",
    // # "users" : [
    // #     "gracz"
    // #     ],
  ),
  MyBadge(
    title: 'Creative Director',
    description: 'Style/panache',
    powers: '',
    icon: const Icon(Icons.self_improvement_outlined),
    // oldId: "249",
    // # "users" : [
    // #     "Evangeline",
    // #     ],
  ),
  MyBadge(
    title: 'Poet',
    description: 'Has a way with words.',
    powers: 'Squiggles',
    icon: const Icon(Icons.nights_stay_outlined),
    // oldId: "poet",
    // # "users" : [
    // #     "cephEid",
    // #     ],
  ),
  MyBadge(
    title: 'D.J.',
    description: 'Plays our songs on the radio.',
    powers: '',
    icon: const Icon(Icons.radio_outlined),
  ),
  MyBadge(
    title: 'Mayor',
    description:
        "Serves the people. Oversees the neighborhood's main departments, including the police, fire, education, housing and transportation departments. ",
    powers: '',
    icon: const Icon(Icons.sports_kabaddi_outlined),
    // oldId: "251",
    // # "users" : [
    // #     "Rivers",
    // #     ],
  ),
  MyBadge(
    title: 'Coach',
    description:
        'Assist neighbors in developing to their full potential. He is responsible for training neighbors by analyzing their performances, instructing in relevant skills and by providing encouragement. But he is also responsible for the guidance of the neighbor in life.',
    powers: '',
    icon: const Icon(Icons.psychology_outlined),
    // oldId: "252",
    // # "users" : [
    // #     "Rivers",
    // #     ],
  ),
  MyBadge(
    title: 'Marketing Director',
    description: 'Make memes.',
    powers: '',
    icon: const Icon(Icons.rowing_outlined),
    // oldId: "253",
    // # "users" : [
    // #     "Tiffany",
    // #     "nikki"
    // #     ],
  ),
  MyBadge(
    title: 'Parental Advisory',
    description: 'Mark files with explicit lyrics.',
    powers: 'Edit the Song List',
    icon: const Icon(Icons.shield),
    // oldId: "254",
    // # "users" : [
    // #     "natkat128",
    // #     ],
  ),
  MyBadge(
    title: 'Eagle Eyes',
    description:
        "Report accidental leakage of content to Rivers' email rivers@riverscuomo.com. Without discussing with anyone else.",
    powers: '',
    icon: const Icon(Icons.security),
    color: Colors.red,
    // oldId: "255",
    // # "users" : [
    // #     "Tiffany",
    // #     "nikki"
    // #     ],
  ),
];

// rc._getBadgeColor(rc.MyBadgerc.badge) {
//     if (rc.badge.col)
//     if (rc.badge.powers == '') {
//       return Colors.blue[800];
//     } else {
//       return Colors.blueAccent;
//     }
//   }
