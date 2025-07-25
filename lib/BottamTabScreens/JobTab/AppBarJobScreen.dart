import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/AllFilters/JobListFilters.dart';
import 'package:sk_loginscreen1/blocpage/JobApiBloc/job_event.dart';
import '../../blocpage/jobFilterBloc/jobFilter_event.dart';
import '../../blocpage/jobFilterBloc/jobFilter_logic.dart';
import '../../blocpage/jobFilterBloc/jobFilter_state.dart';

class Appbarjobscreen extends StatefulWidget implements PreferredSizeWidget {
  const Appbarjobscreen({super.key});

  @override
  State<Appbarjobscreen> createState() => _AppbarjobscreenState();

  @override
  Size get preferredSize => const Size.fromHeight(75);
}

class _AppbarjobscreenState extends State<Appbarjobscreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<JobFilterBloc, JobFilterState>(
      listener: (context, state) async {
        if (state is JobFilterSheetVisible) {
          final selectedFilters = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const Joblistfilters(
              jobType: '',
              jobTitle: '',
              workCulture: '',
              courses: '',
              cities: '',
              states: '',
            ),
          );
          if (selectedFilters != null) {
            context.read<JobFilterBloc>().add(FetchJobsEvent() as JobFilterEvent);

          }
        }
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    iconCircleButton(
                      Icons.filter_list,
                      onTap: () {
                        context.read<JobFilterBloc>().add(ShowJobFilterSheet());
                      },
                    ),
                    iconCircleButton(Icons.notifications_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCircleButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 22, color: Colors.black),
      ),
    );
  }
}
