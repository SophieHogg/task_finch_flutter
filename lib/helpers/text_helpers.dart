extension SentenceCasing on String {
  String toSentenceCase() {
    final String firstLetter = this.substring(0, 1).toUpperCase();
    final String restLetters = this.substring(1);
    return firstLetter + restLetters;
  }
}

extension TitleCasing on String {
  String toTitleCase() {
    final List<String> words = this.split(" ");
    final List<String> capitalisedWords = words.map((word) => word.toSentenceCase()).toList();
    return words.join(" ");
  }
}