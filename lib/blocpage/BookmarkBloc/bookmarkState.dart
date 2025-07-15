import 'package:equatable/equatable.dart';
import '../../Model/Job_Model.dart';

class BookmarkState extends Equatable {
  final List<JobModel> bookmarkedJobs;

  const BookmarkState({this.bookmarkedJobs = const []});

  @override
  List<Object> get props => [bookmarkedJobs];
}
