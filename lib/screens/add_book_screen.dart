import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final BookService _bookService = BookService();
  bool _isSubmitting = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6F4E37),
              onPrimary: Colors.white,
              onSurface: Color(0xFF4F4F4F),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6F4E37),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final book = Book(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        author: _authorController.text.trim(),
        publisher: _publisherController.text.trim(),
        datePublished: _dateController.text.trim(),
      );

      await _bookService.addBook(book);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Book uploaded to Firestore successfully.')),
      );

      _idController.clear();
      _nameController.clear();
      _authorController.clear();
      _publisherController.clear();
      _dateController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AyBook')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF0E5), Color(0xFFF0DFC9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Card(
                elevation: 8,
                shadowColor: const Color(0x22000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text(
                          'Create New Record',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            color: const Color(0xFF6F4E37),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Fill all fields and save to Firestore.',
                          style: TextStyle(color: Color(0xFF6A6A6A)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _idController,
                          decoration: const InputDecoration(
                            labelText: 'Book ID',
                            prefixIcon: Icon(Icons.tag_rounded),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Book ID' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Book Name',
                            prefixIcon: Icon(Icons.menu_book_rounded),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Book Name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _authorController,
                          decoration: const InputDecoration(
                            labelText: 'Author',
                            prefixIcon: Icon(Icons.person_rounded),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Author' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _publisherController,
                          decoration: const InputDecoration(
                            labelText: 'Publisher',
                            prefixIcon: Icon(Icons.business_rounded),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Publisher' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: const InputDecoration(
                            labelText: 'Date Published',
                            hintText: 'Select a Date',
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Select Date Published' : null,
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton.icon(
                          icon: _isSubmitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload_rounded),
                          onPressed: _isSubmitting ? null : _addBook,
                          label:
                              Text(_isSubmitting ? 'Uploading...' : 'Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
