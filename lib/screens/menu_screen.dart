import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_book_screen.dart';
import 'retrieve_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AyBook')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9EFE4), Color(0xFFF2E1CF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Your Book Command Center',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      height: 1.1,
                      color: const Color(0xFF6F4E37),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add fresh titles or browse your live Firestore records.',
                    style: TextStyle(
                      color: Color(0xFF5A5A5A),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _MenuTile(
                    icon: Icons.edit_note_rounded,
                    title: 'Add Book',
                    subtitle: 'Create a new Firestore record',
                    accentColor: const Color(0xFF6F4E37),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddBookScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _MenuTile(
                    icon: Icons.collections_bookmark_rounded,
                    title: 'Retrieve Books',
                    subtitle: 'View all saved records instantly',
                    accentColor: const Color(0xFF8D6747),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RetrieveScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6D4C3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF616161)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: accentColor),
          ],
        ),
      ),
    );
  }
}
