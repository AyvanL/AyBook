class Book {
  final String id;
  final String name;
  final String author;
  final String publisher;
  final String datePublished;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.publisher,
    required this.datePublished,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['bookId'] ?? '',
      name: map['bookName'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'] ?? '',
      datePublished: map['datePublished'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': id,
      'bookName': name,
      'author': author,
      'publisher': publisher,
      'datePublished': datePublished,
    };
  }
}
