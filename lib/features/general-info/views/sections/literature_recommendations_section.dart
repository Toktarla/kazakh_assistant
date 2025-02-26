import 'package:flutter/material.dart';

import 'book_details_page.dart';

class LiteratureRecommendationsWidget extends StatelessWidget {
  final List<dynamic> literatureRecommendations;

  const LiteratureRecommendationsWidget(
      {Key? key, required this.literatureRecommendations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView.separated(
        itemCount: (literatureRecommendations.length / 3).ceil(),
        separatorBuilder: (context, index) => Column(
          children: [
            Divider(thickness: 5.0, color: Theme.of(context).primaryColor,),
            const SizedBox(height: 40),
          ],
        ),
        itemBuilder: (context, rowIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                    (columnIndex) {
                  final itemIndex = rowIndex * 3 + columnIndex;
                  if (itemIndex < literatureRecommendations.length) {
                    final bookData = literatureRecommendations[itemIndex];
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsPage(bookData: bookData),
                              ),
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: 0.7,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: bookData['imageUrl'] != null && bookData['imageUrl'].isNotEmpty
                                    ? Image.network(
                                  bookData['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                                )
                                    : const Center(child: Icon(Icons.book)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Expanded(child: SizedBox.shrink());
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}