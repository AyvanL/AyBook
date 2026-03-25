import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class RetrieveScreen extends StatelessWidget {
  RetrieveScreen({Key? key}) : super(key: key);

  final BookService _bookService = BookService();

  Future<void> _deleteBook(BuildContext context, Book book) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Book'),
          content: Text('Delete "${book.name}" from records?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await _bookService.deleteBook(book.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted "${book.name}".')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AyBook')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9EFE4), Color(0xFFF1E0CD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Book>>(
          stream: _bookService.getBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No books found yet.\nAdd your first title from the menu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF606060), fontSize: 16),
                ),
              );
            }

            final books = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Library',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            color: const Color(0xFF6F4E37),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Browse and manage your book collection.',
                          style: TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = books[index];
                        return _ModernBookCard(
                          book: book,
                          onDelete: () => _deleteBook(context, book),
                        );
                      },
                      childCount: books.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModernBookCard extends StatelessWidget {
  const _ModernBookCard({required this.book, required this.onDelete});

  final Book book;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DCC8), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F4E37).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF6F4E37),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.name,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            height: 1.2,
                            color: const Color(0xFF6F4E37),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_rounded,
                                size: 14, color: Color(0xFF8D6747)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                book.author,
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete Book',
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD9534F),
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Color(0xFFF0E5D3), height: 1),
              ),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.tag_rounded,
                      label: book.id,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.calendar_today_rounded,
                      label: book.datePublished,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _InfoChip(
                icon: Icons.business_rounded,
                label: book.publisher,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.isFullWidth = false,
  });

  final IconData icon;
  final String label;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9E8971)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5ED),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFE6D8)),
      ),
      child: content,
    );
  }
}
