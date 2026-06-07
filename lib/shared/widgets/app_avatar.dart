import 'package:flutter/material.dart';
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final double radius;
  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.fullName,
    this.radius = 30.0,
  });
  String getInitials(String name) {
    if (name.trim().isEmpty) return "?";
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    } else {
      return nameParts[0].length >= 2
          ? nameParts[0].substring(0, 2).toUpperCase()
          : nameParts[0][0].toUpperCase();
    }
  }
  Color getAvatarColor(String name) {
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo
    ];
    int hash = name.hashCode;
    int index = hash.abs() % colors.length;
    return colors[index];
  }
  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Colors.transparent,
      );
    }
    // Following figma, and telegram-style random colors
    return CircleAvatar(
      radius: radius,
      backgroundColor: getAvatarColor(fullName),
      child: Center(
        child: Text(
          getInitials(fullName),
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.65,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
