// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_password_cubit.dart';

class CreatePasswordState extends Equatable {
  final int step;
  final List<String> mnemonicWords;
  final List<String> selectedWords;

  const CreatePasswordState({
    required this.step,
    required this.mnemonicWords,
    required this.selectedWords,
  });

  @override
  List<Object> get props => [step, mnemonicWords, selectedWords];

  CreatePasswordState copyWith({
    int? step,
    List<String>? mnemonicWords,
    List<String>? selectedWords,
  }) {
    return CreatePasswordState(
      step: step ?? this.step,
      mnemonicWords: mnemonicWords ?? this.mnemonicWords,
      selectedWords: selectedWords ?? this.selectedWords,
    );
  }
}
