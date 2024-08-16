import 'package:flutter/material.dart';
import 'package:notes/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const NoteTile(
      {super.key,
      required this.text,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
      child: ListTile(
          title: Text(text),
          trailing: Builder(builder: (context) {
            return IconButton(
              onPressed: () => showPopover(
                context: context,
                bodyBuilder: (context) => NoteSettings(onDelete: () {
                  Navigator.pop(context);
                  onDelete!();
                }, onEdit: () {
                  Navigator.pop(context);
                  onEdit!();
                }),
                width: 100,
                height: 100,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              icon: Icon(Icons.more_vert),
            );
          })),
    );
  }
}
