import 'package:flutter/material.dart';

class YeSuggestion extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String)? onTap;

  const YeSuggestion({
    Key? key,
    this.suggestions = const [],
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: const Text(
          '暂无推荐',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '猜你喜欢',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...suggestions.map(
          (item) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: ListTile(
              title: Text(item),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onTap?.call(item),
            ),
          ),
        ),
      ],
    );
  }
}
