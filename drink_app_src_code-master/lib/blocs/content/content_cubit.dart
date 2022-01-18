import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/repositories/content_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit(this.contentRepository) : super(ContentInitial());
  final ContentRepository contentRepository;

  Future<void> getContent(bool isPrivacyPolicy) async {
    try {
      dynamic content;
      emit(ContentLoading());
      if (isPrivacyPolicy) {
        content = await contentRepository.getPrivacyPolicy();
      } else {
        content = await contentRepository.getTermsAndConditions();
      }
      print(content.toString());
      emit(Contentloaded(content));
    } on PlatformException catch (e) {
      emit(ContentLoadFailure(e.message));
    } on SocketException catch (e) {
      emit(ContentLoadFailure(e.message));
    } on AuthException {
      emit(UnAuthenticated());
    } catch (e) {
      emit(ContentLoadFailure(e.message));
    }
  }
}
