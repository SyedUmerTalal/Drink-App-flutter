part of 'complete_profile_bloc.dart';

class CompleteProfileState extends Equatable {
  const CompleteProfileState(
      {@required this.isNameValid,
      // @required this.isGenderValid,
      // @required this.isDateOfBirthValid,
      @required this.isProfilePictureValid,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.isSubmitting,
      this.isAuthenticated,
      this.message});
  factory CompleteProfileState.empty() {
    return CompleteProfileState(
      isNameValid: true,
      // isGenderValid: true,
      // isDateOfBirthValid: true,
      isProfilePictureValid: true,
      isSuccess: false,
      isFailure: false,
      isSubmitting: false,
    );
  }
  factory CompleteProfileState.loading() {
    return CompleteProfileState(
      isNameValid: true,
      // isGenderValid: true,
      // isDateOfBirthValid: true,
      isProfilePictureValid: true,
      isSuccess: false,
      isFailure: false,
      isSubmitting: true,
    );
  }
  factory CompleteProfileState.success() {
    return CompleteProfileState(
      isNameValid: true,
      // isGenderValid: true,
      // isDateOfBirthValid: true,
      isProfilePictureValid: true,
      isSuccess: true,
      isFailure: false,
      isSubmitting: false,
    );
  }
  factory CompleteProfileState.failure(String message) {
    return CompleteProfileState(
      isNameValid: true,
      // isGenderValid: true,
      // isDateOfBirthValid: true,
      isProfilePictureValid: true,
      isSuccess: false,
      isFailure: true,
      isSubmitting: false,
      message: message,
    );
  }
  final bool isNameValid;
  // final bool isGenderValid;
  // final bool isDateOfBirthValid;
  final bool isProfilePictureValid;
  final bool isSuccess;
  final bool isFailure;
  final bool isSubmitting;
  final bool isAuthenticated;
  final String message;

  bool get isFormValid =>
      isNameValid &&
      //isGenderValid &&
      isProfilePictureValid;
  @override
  List<Object> get props => [
        isNameValid,
        // isGenderValid,
        // isDateOfBirthValid,
        isProfilePictureValid,
        isSuccess,
        isFailure,
        message
      ];

  CompleteProfileState update({
    bool isNameValid,
    bool isGenderValid,
    bool isDateOfBirthValid,
    bool isProfilePictureValid,
  }) {
    return copyWith(
      isNameValid: isNameValid,
      isGenderValid: isGenderValid,
      isDateOfBirthValid: isDateOfBirthValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  CompleteProfileState copyWith({
    bool isNameValid,
    bool isGenderValid,
    bool isDateOfBirthValid,
    bool isProfilePictureValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return CompleteProfileState(
      isNameValid: isNameValid ?? this.isNameValid,
      // isGenderValid: isGenderValid ?? this.isGenderValid,
      // isDateOfBirthValid: isDateOfBirthValid ?? this.isDateOfBirthValid,
      isProfilePictureValid:
          isProfilePictureValid ?? this.isProfilePictureValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
