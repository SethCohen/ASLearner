class FlashcardModel {
  String cardId;
  String deckId;
  String title;
  String instructions;
  String image;

  FlashcardModel(
      {required this.cardId,
      required this.deckId,
      required this.title,
      required this.instructions,
      required this.image});

  factory FlashcardModel.fromMap(
    Map<String, dynamic> data,
    String cardId,
    String deckId,
  ) {
    return FlashcardModel(
      cardId: cardId,
      deckId: deckId,
      title: data['title'] as String,
      instructions: data['instructions'] as String,
      image: data['image'] as String,
    );
  }
}
