// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResumeStore on _ResumeStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_ResumeStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ResumeStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$resumeAtom = Atom(name: '_ResumeStore.resume', context: context);

  @override
  Resume? get resume {
    _$resumeAtom.reportRead();
    return super.resume;
  }

  @override
  set resume(Resume? value) {
    _$resumeAtom.reportWrite(value, super.resume, () {
      super.resume = value;
    });
  }

  late final _$loadResumeAsyncAction =
      AsyncAction('_ResumeStore.loadResume', context: context);

  @override
  Future<void> loadResume() {
    return _$loadResumeAsyncAction.run(() => super.loadResume());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
resume: ${resume}
    ''';
  }
}
