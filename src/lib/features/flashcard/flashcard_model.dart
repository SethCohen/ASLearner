class FlashcardModel {
  String? deckTitle;
  String? cardId;
  String? deckId;
  String title;
  String instructions;
  String image;

  FlashcardModel({
    this.deckTitle,
    this.cardId,
    this.deckId,
    required this.title,
    required this.instructions,
    required this.image,
  });

  factory FlashcardModel.fromMap(
    Map<String, dynamic> data, [
    String? cardId,
    String? deckId,
    String? deckTitle,
  ]) {
    return FlashcardModel(
      deckTitle: deckTitle,
      cardId: cardId,
      deckId: deckId,
      title: data['title'],
      instructions: data['instructions'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instructions': instructions,
      'image': image,
    };
  }
}
