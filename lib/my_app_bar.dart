import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;

  const CustomAppBar({super.key, required this.title, this.extraActions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        // unpack collection that always has a value.
        if(extraActions != null) ...extraActions!,
        IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
            tooltip: 'Logout',
          ),
      ],
      backgroundColor: const Color(0xFF121212),
      foregroundColor: const Color(0xFFA7A7A7),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}