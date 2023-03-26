class ReviewModel {
  final String deckId;
  final String deckTitle;
  final String cardId;
  final String cardTitle;
  final String cardInstructions;
  final String cardImage;

  ReviewModel({
    required this.cardTitle,
    required this.cardInstructions,
    required this.cardImage,
    required this.deckTitle,
    required this.cardId,
    required this.deckId,
  });

  factory ReviewModel.fromMap(cardId, Map<String, dynamic> data) => ReviewModel(
        cardId: cardId,
        cardTitle: data['title'],
        cardInstructions: data['instructions'],
        cardImage: data['image'],
        deckTitle: data['deckTitle'],
        deckId: data['deckId'],
      );
}
