import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc(
      {@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(CompleteProfileState.empty());
  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<Transition<CompleteProfileEvent, CompleteProfileState>>
      transformEvents(
    Stream<CompleteProfileEvent> events,
    TransitionFunction<CompleteProfileEvent, CompleteProfileState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! NameChanged;
    });
    final debounceStream = events.where((event) {
      return event is NameChanged
          // ||
          //     event is GenderChanged ||
          //     event is DOBChanged
          ;
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<CompleteProfileState> mapEventToState(
    CompleteProfileEvent event,
  ) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    }

    // else if (event is GenderChanged) {
    //   yield* _mapGenderChangedToState(event.gender);
    // } else if (event is DOBChanged) {
    //   yield* _mapDOBChangedToState(event.dateOfBirth);
    // }

    else if (event is ProfilePictureChanged) {
      yield* _mapProfilePictureChangedToState(event.image);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(
        event.name,
        // event.gender,
        // event.dateofBirth,
        event.profilePicture,
        event.token,
      );
    }
  }

  Stream<CompleteProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(isNameValid: name?.isNotEmpty ?? false);
  }

  // Stream<CompleteProfileState> _mapGenderChangedToState(String gender) async* {
  //   yield state.update(isGenderValid: gender?.isNotEmpty ?? false);
  // }

  // Stream<CompleteProfileState> _mapDOBChangedToState(DateTime dob) async* {
  //   yield state.update(isDateOfBirthValid: dob != null);
  // }

  Stream<CompleteProfileState> _mapProfilePictureChangedToState(
      File image) async* {
    yield state.update(isProfilePictureValid: image != null);
  }

  Stream<CompleteProfileState> _mapSubmittedToState(
      String name,
      //  String gender,
      //     DateTime dob,

      File image,
      String token) async* {
    // debugger();
    yield CompleteProfileState.loading();
    try {
      // debugger();
      if (image != null) {
        await _authenticationRepository.completeProfile(
          name: name,
          // gender: gender.toLowerCase(),
          // dateOfBirth:
          //     DateFormat(AppStrings.DATE_FORMAT_DOB_DATABASE).format(dob),
          imagePath: image.path,
          token: token,
        );
      } else {
        await _authenticationRepository.completeProfile(
          name: name,
          // gender: gender.toLowerCase(),
          // dateOfBirth:
          //     DateFormat(AppStrings.DATE_FORMAT_DOB_DATABASE).format(dob),
          // image: image,
          token: token,
        );
      }

      // debugger();
      yield CompleteProfileState.success();
    } on PlatformException catch (e) {
      yield CompleteProfileState.failure(e.message);
    } on SocketException catch (e) {
      yield CompleteProfileState.failure(e.message);
    } catch (e) {
      yield CompleteProfileState.failure(e.message);
    }

    // catch (e) {
    //   print(e.toString());
    //   yield CompleteProfileState.failure(e.message);
    // }
  }
}
