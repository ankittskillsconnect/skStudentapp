import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileDataLoaded extends ProfileState {
  final String fullname;
  final int age;
  final String dob;
  final File? profileImage;

  ProfileDataLoaded({
    required this.fullname,
    required this.age,
    required this.dob,
    required this.profileImage,
  });

  @override
  List<Object?> get props => [fullname, age, dob, profileImage];
}
