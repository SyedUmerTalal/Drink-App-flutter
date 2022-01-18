part of 'complete_profile_bloc.dart';

abstract class CompleteProfileEvent extends Equatable {
  const CompleteProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends CompleteProfileEvent {
  const NameChanged(this.name);

  final String name;
  @override
  List<Object> get props => [name];
}

class ProfilePictureChanged extends CompleteProfileEvent {
  const ProfilePictureChanged(this.image);

  final File image;

  @override
  List<Object> get props => [image];
}

// class DOBChanged extends CompleteProfileEvent {
//   const DOBChanged(this.dateOfBirth);

//   final DateTime dateOfBirth;
//   @override
//   List<Object> get props => [dateOfBirth];
// }

// class GenderChanged extends CompleteProfileEvent {
//   const GenderChanged(this.gender);

//   final String gender;
//   @override
//   List<Object> get props => [gender];
// }

class Submitted extends CompleteProfileEvent {
  const Submitted({
    this.name,
    // this.gender,
    // this.dateofBirth,
    this.profilePicture,
    this.token,
  });
  final File profilePicture;
  final String name;
  // final String gender;
  // final DateTime dateofBirth;
  final String token;
}
