import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  Future<void> addBook(Book book) async {
    await booksCollection.doc(book.id).set(book.toMap());
  }

  Future<void> deleteBook(String bookId) async {
    await booksCollection.doc(bookId).delete();
  }

  Stream<List<Book>> getBooks() {
    return booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
