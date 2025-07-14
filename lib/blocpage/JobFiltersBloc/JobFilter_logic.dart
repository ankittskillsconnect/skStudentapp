import 'JobFilter_event.dart';
import 'JobFilter_state.dart';
import 'package:bloc/bloc.dart';

class JobFilterBloc extends Bloc<JobFilterEvent, JobFilterState> {
  JobFilterBloc() : super(JobFilterInitial()) {
    on<ShowJobFilterSheet>((event, emit) {
      emit(JobFilterSheetVisible());
    });
  }
}