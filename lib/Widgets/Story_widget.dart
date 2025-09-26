import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Static demo stories
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      itemCount: 8,
      itemBuilder: (_, i) {
        return Container(
          width: 88,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(children: [
            CircleAvatar(radius: 32, child: Text('U$i')),
            const SizedBox(height: 6),
            Text('Story ${i + 1}', overflow: TextOverflow.ellipsis),
          ]),
        );
      },
    );
  }
}
