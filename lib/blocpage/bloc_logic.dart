// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
// import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
//
// class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
//   NavigationBloc() : super(initalState()) {
//     on<GoToForgotPassword>((event, emit) {
//       emit(NavigatetoForgotPassword());
//     });
//     on<SplashToLogin>((event, emit) {
//       emit(NavigateToLoginPage());
//     });
//     on<GotoHomeScreen>((event, emit) {
//       emit(NavigateToHomeScreen());
//     });
//     on<GoHomeToLogin>((event, emit) {
//       emit(NavigateHometoLogin());
//     });
//     on<GoToApplicationPage>((event, emit) {
//       emit(NavigatetoApplicationPage());
//     });
//     on<GoToCollegeInnerScreen>((event, emit) {
//       emit(NavigateToCollegeInnerScreen());
//     });
//     on<GoTOStudentApplicationDetailScreen>((event, emit) {
//       emit(NavigateToStudentApplicationDetailScreen());
//     });
//
//     // navigation for bottom bar Screens
//     on<GotoHomeScreen2>((event, emit) => emit(NavigateToHomeScreen()));
//     on<GoToInterviewScreen2>((event, emit) => emit(NavigateToInterviewScreen()),);
//     on<GoToContactsScreen2>((event, emit) => emit(NavigateToContactsScreen()));
//     on<GotoJobScreen2>((event, emit) => emit(NavigateToJobSecreen2()));
//     on<GoToAccountScreen2>((event, emit) => emit(NavigateToAccountScreen()));
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const initalState()) {
    on<GoToForgotPassword>((event, emit) {
      print('Handling GoToForgotPassword');
      emit(const NavigatetoForgotPassword());
      // emit(NavigationIdle());
    });
    on<SplashToLogin>((event, emit) {
      print('Handling SplashToLogin');
      emit(const NavigateToLoginPage());
    });
    on<GobackToLoginPage>((event, emit) {
      print('Handling GobackToLoginPage');
      emit(const NavigateBacktoLoginin());
    });
    on<GotoHomeScreen>((event, emit) {
      print('Handling GotoHomeScreen');
      emit(const NavigateToHomeScreen());
    });
    on<GoHomeToLogin>((event, emit) {
      print('Handling GoHomeToLogin');
      emit(const NavigateHometoLogin());
    });
    on<GoToApplicationPage>((event, emit) {
      print('Handling GoToApplicationPage');
      emit(const NavigatetoApplicationPage());
    });
    on<GoToCollegeInnerScreen>((event, emit) {
      print('Handling GoToCollegeInnerScreen');
      emit(const NavigateToCollegeInnerScreen());
    });
    on<GoTOStudentApplicationDetailScreen>((event, emit) {
      print('Handling GoTOStudentApplicationDetailScreen');
      emit(const NavigateToStudentApplicationDetailScreen());
    });

    // Navigation for bottom bar screens
    on<GotoHomeScreen2>((event, emit) {
      print('Handling GotoHomeScreen2');
      emit(const NavigateToHomeScreen2());
    });
    on<GotoJobScreen2>((event, emit) {
      print('Handling GotoJobScreen2');
      emit(const NavigateToJobSecreen2());
    });
    on<GoToInterviewScreen2>((event, emit) {
      print('Handling GoToInterviewScreen2');
      emit(const NavigateToInterviewScreen());
    });
    on<GoToContactsScreen2>((event, emit) {
      print('Handling GoToContactsScreen2');
      emit(const NavigateToContactsScreen());
    });
    on<GoToAccountScreen2>((event, emit) {
      print('Handling GoToAccountScreen2');
      emit(const NavigateToAccountScreen());
    });
    on<GoToJobDetailScreenBT>((event, emit) {
      print('Handling NavigateToJobDetailScreenBT');
      emit(NavigateTOJobDetailBT(jobToken: event.jobToken));
    });

    on<GoToMyAccountScreen>((event, emit) {
      print('Handling NavigateToMyAccount');
      emit(const NavigateToMyAccount());
    });
    on<GoToMyInterviewVideosScreen>((event, emit) {
      print('Handling NavigateToMyInterviewVideos');
      emit(const NavigateToMyInterviewVideos());
    });
    on<GoToJobListFilters>((event, emit) {
      print('Handling NavigateToJobListFilters');
      emit(const NavigateToJobListFilters());
    });
    on<GoToMyJobs>((event, emit) {
      print('Handling NavigateToMyJob');
      emit(const NavigateToMyJob());
    });
  }
}