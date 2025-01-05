// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class SmallBadgeCard extends StatelessWidget {
  const SmallBadgeCard({
    super.key,
    required this.openBadgePreview,
    required this.badge,
  });

  final Function openBadgePreview;
  final MyBadge badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openBadgePreview(badge),
      child: Card(
        shape: const BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.blueAccent,
            width: .3,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            badge.icon ?? const Icon(Icons.error),
            Text(
              badge.title!,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LargeBadgeCard extends StatelessWidget {
  const LargeBadgeCard({super.key, required this.badge});
  final badge;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          sizedBox16,
          Column(
            children: [
              Container(
                width: 132,
                height: 132,
                color: badge.color,
                child: Transform.scale(scale: 2, child: badge.icon!),
              ),
              sizedBox16,
              Text(
                badge.title!,
                style: boldWhite14,
              ),
            ],
          )
        ],
      ),
    );
  }
}
