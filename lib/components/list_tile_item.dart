import 'package:flutter/material.dart';

class ListTileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const ListTileItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
