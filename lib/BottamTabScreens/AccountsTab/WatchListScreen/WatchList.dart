import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocpage/BookmarkBloc/bookmarkLogic.dart';
import '../../../blocpage/BookmarkBloc/bookmarkState.dart';
import '../../../blocpage/BookmarkBloc/bookmarkEvent.dart';
import '../../JobTab/JobCardBT.dart';
import '../../JobTab/JobdetailPage/JobdetailpageBT.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Color(0xFF003840),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF003840)),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state.bookmarkedJobs.isEmpty) {
            return const Center(
              child: Text(
                "No bookmarked jobs yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.bookmarkedJobs.length,
            itemBuilder: (context, index) {
              final job = state.bookmarkedJobs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailPage2(jobToken: job.jobToken),
                      ),
                    );
                  },
                  child: Dismissible(
                    key: ValueKey(job.jobToken),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red.shade100,
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    onDismissed: (_) {
                      context.read<BookmarkBloc>().add(RemoveBookmarkEvent(job.jobToken));
                    },
                    child: JobCardBT(
                      jobTitle: job.jobTitle,
                      company: job.company,
                      location: job.location,
                      salary: job.salary,
                      postTime: job.postTime,
                      expiry: job.expiry,
                      tags: job.tags,
                      logoUrl: job.logoUrl,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
