import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_password_state.dart';

class CreatePasswordCubit extends Cubit<CreatePasswordState> {
  CreatePasswordCubit()
      : super(const CreatePasswordState(
          step: 1,
          mnemonicWords: [],
          selectedWords: [],
        ));

  void nextStep() {
    if (state.step == 1) {
      emit(state.copyWith(step: state.step + 1));
    }
  }

  void setMnemonicWords(List<String> mnemonicWords) {
    emit(state.copyWith(mnemonicWords: mnemonicWords));
  }

  void resetSelectedWords() {
    emit(state.copyWith(selectedWords: []));
  }

  void onSelectMnemonicWord(String word) {
    final selectedWords = List.of(state.selectedWords);
    selectedWords.add(word);
    print("[CreatePasswordCubit] selectedWords: $selectedWords");
    emit(state.copyWith(selectedWords: selectedWords));
  }
}
