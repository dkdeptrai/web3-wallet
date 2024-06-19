import 'dart:math';

class MnemonicUtil {
  static List<String> randomSixWords({required List<String> mnemonicWords, required String correctWord}) {
    // Create a random number generator
    final random = Random();
    // Create a new list to store selected words
    List<String> selectedWords = [];
    // Create a copy of the original list to manipulate
    List<String> tempList = List.from(mnemonicWords);
    tempList.remove(correctWord);

    for (int i = 0; i < 5; i++) {
      // Get a random index
      int randomIndex = random.nextInt(tempList.length);
      // Add the word at the random index to the selected words list
      selectedWords.add(tempList[randomIndex]);
      // Remove the word from the temporary list to avoid duplicates
      tempList.removeAt(randomIndex);
    }

    selectedWords.add(correctWord);
    selectedWords.shuffle();
    return selectedWords;
  }
}
