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
  final String dob;
  final int age;
  final File? profileImage;

  ProfileDataLoaded({
    required this.fullname,
    required this.dob,
    required this.age,
    required this.profileImage,
  });
}

