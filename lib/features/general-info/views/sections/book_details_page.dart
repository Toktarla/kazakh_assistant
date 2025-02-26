import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final dynamic bookData;

  const BookDetailsPage({Key? key, required this.bookData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookData['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bookData['imageUrl'] != null && bookData['imageUrl'].isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    bookData['imageUrl'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.7,
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              bookData['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${bookData['author'] ?? 'Unknown Author'}',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              bookData['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (bookData['link'] != null && bookData['link'].isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // Implement link opening logic here
                  // For example, use url_launcher package
                },
                child: const Text('Read More'),
              ),
          ],
        ),
      ),
    );
  }
}