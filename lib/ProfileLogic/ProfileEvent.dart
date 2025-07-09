import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileData extends ProfileEvent {}

class UpdateProfileData extends ProfileEvent {
  final String fullname;
  final String dob;
  final File? profileImage;

  const UpdateProfileData({
    required this.fullname,
    required this.dob,
    this.profileImage,
  });

  @override
  List<Object?> get props => [fullname, dob, profileImage];
}
