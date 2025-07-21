import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/blocpage/jobFilterBloc/jobFilter_event.dart';
import 'package:sk_loginscreen1/blocpage/jobFilterBloc/jobFilter_state.dart';


class JobFilterBloc extends Bloc<JobFilterEvent, JobFilterState> {
  JobFilterBloc() : super(JobFilterInitial()) {
    on<ShowJobFilterSheet>((event, emit) {
      emit(JobFilterSheetVisible());
    });

    on<ApplyJobFilters>((event, emit) {
      emit(JobFilterApplied(event.filterData));
    });
  }
}
