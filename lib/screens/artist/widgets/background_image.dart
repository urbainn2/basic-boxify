import 'package:flutter/cupertino.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.profileImageUrl,
  });

  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: MediaQuery.of(context).size.width,
      child: Opacity(
        opacity: 0.7,
        child: Image.network(
          profileImageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
