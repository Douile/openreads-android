import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openreads/model/book.dart';
import 'package:openreads/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/constants.dart/enums.dart';

class BookCubit extends Cubit {
  final Repository repository = Repository();

  final BehaviorSubject<List<Book>> _booksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<Book>> _finishedBooksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<Book>> _inProgressBooksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<Book>> _toReadBooksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<Book>> _deletedBooksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<Book>> _unfinishedBooksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<Book>> _searchBooksFetcher =
      BehaviorSubject<List<Book>>();
  final BehaviorSubject<List<int>> _finishedYearsFetcher =
      BehaviorSubject<List<int>>();
  final BehaviorSubject<List<String>> _tagsFetcher =
      BehaviorSubject<List<String>>();
  final BehaviorSubject<Book?> _bookFetcher = BehaviorSubject<Book?>();

  Stream<List<Book>> get allBooks => _booksFetcher.stream;
  Stream<List<Book>> get finishedBooks => _finishedBooksFetcher.stream;
  Stream<List<Book>> get inProgressBooks => _inProgressBooksFetcher.stream;
  Stream<List<Book>> get toReadBooks => _toReadBooksFetcher.stream;
  Stream<List<Book>> get deletedBooks => _deletedBooksFetcher.stream;
  Stream<List<Book>> get unfinishedBooks => _unfinishedBooksFetcher.stream;
  Stream<List<Book>> get searchBooks => _searchBooksFetcher.stream;
  Stream<List<int>> get finishedYears => _finishedYearsFetcher.stream;
  Stream<List<String>> get tags => _tagsFetcher.stream;

  Stream<Book?> get book => _bookFetcher.stream;

  BookCubit() : super(null) {
    getFinishedBooks();
    getInProgressBooks();
    getToReadBooks();
    getAllBooks();
  }

  getAllBooks({bool tags = false}) async {
    List<Book> books = await repository.getAllNotDeletedBooks();
    _booksFetcher.sink.add(books);
    if (tags) return;
    _tagsFetcher.sink.add(_getTags(books));
  }

  removeAllBooks() async {
    await repository.removeAllBooks();
  }

  getAllBooksByStatus() async {
    getFinishedBooks();
    getInProgressBooks();
    getToReadBooks();
    getUnfinishedBooks();
  }

  getFinishedBooks() async {
    List<Book> books = await repository.getBooks(0);

    _finishedBooksFetcher.sink.add(books);
    _finishedYearsFetcher.sink.add(_getFinishedYears(books));
  }

  getInProgressBooks() async {
    List<Book> books = await repository.getBooks(1);
    _inProgressBooksFetcher.sink.add(books);
  }

  getToReadBooks() async {
    List<Book> books = await repository.getBooks(2);
    _toReadBooksFetcher.sink.add(books);
  }

  getDeletedBooks() async {
    List<Book> books = await repository.getDeletedBooks();
    _deletedBooksFetcher.sink.add(books);
  }

  getUnfinishedBooks() async {
    List<Book> books = await repository.getBooks(3);
    _unfinishedBooksFetcher.sink.add(books);
  }

  getSearchBooks(String query) async {
    if (query.isEmpty) {
      _searchBooksFetcher.sink.add(List.empty());
    } else {
      List<Book> books = await repository.searchBooks(query);
      _searchBooksFetcher.sink.add(books);
    }
  }

  addBook(Book book, {bool refreshBooks = true}) async {
    await repository.insertBook(book);

    if (refreshBooks) {
      getAllBooksByStatus();
      getAllBooks();
    }
  }

  updateBook(Book book) async {
    repository.updateBook(book);
    getBook(book.id!);
    getAllBooksByStatus();
    getAllBooks();
  }

  updateBookType(Set<int> ids, BookType bookType) async {
    repository.updateBookType(ids, bookType);
    getAllBooksByStatus();
    getAllBooks();
  }

  deleteBook(int id) async {
    repository.deleteBook(id);
    getAllBooksByStatus();
    getAllBooks();
  }

  getBook(int id) async {
    Book book = await repository.getBook(id);
    _bookFetcher.sink.add(book);
  }

  clearCurrentBook() {
    _bookFetcher.sink.add(null);
  }

  List<int> _getFinishedYears(List<Book> books) {
    final years = List<int>.empty(growable: true);

    for (var book in books) {
      if (book.finishDate != null) {
        years.add(DateTime.parse(book.finishDate!).year);
      }
    }

    years.sort((a, b) => b.compareTo(a));

    return years;
  }

  List<String> _getTags(List<Book> books) {
    final tags = List<String>.empty(growable: true);

    for (var book in books) {
      if (book.tags != null) {
        for (var tag in book.tags!.split('|||||')) {
          if (!tags.contains(tag)) {
            tags.add(tag);
          }
        }
      }
    }

    tags.sort((a, b) => a.compareTo(b));

    return tags;
  }
}
