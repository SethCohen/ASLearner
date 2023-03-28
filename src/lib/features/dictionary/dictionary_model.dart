class DictionaryModel {
  String cardId;
  String title;
  String instructions;
  String image;

  DictionaryModel(
      {required this.cardId,
      required this.title,
      required this.instructions,
      required this.image});

  factory DictionaryModel.fromMap(
    String cardId,
    Map<String, dynamic> data,
  ) {
    return DictionaryModel(
      cardId: cardId,
      title: data['title'],
      instructions: data['instructions'],
      image: data['image'],
    );
  }
}
