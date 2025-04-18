import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/models/quiz_response_model.dart';
import '../bloc/quiz_bloc.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int pageKey = 0;
  final _pagingController = PagingController<int, QuizResponseModel>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      this.pageKey = pageKey;
      context.read<QuizBloc>().add(FetchQuizEvent(page: pageKey));
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          "Ôn thi",
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              //     child: TextField(
              //       decoration: InputDecoration(
              //         hintText: "Search...",
              //         hintStyle: TextStyle(color: Colors.grey.shade600),
              //         prefixIcon: Icon(
              //           Icons.search,
              //           color: Colors.grey.shade600,
              //           size: 20,
              //         ),
              //         filled: true,
              //         fillColor: Colors.grey.shade100,
              //         contentPadding: EdgeInsets.all(8),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(20),
              //           borderSide: BorderSide(color: Colors.grey.shade100),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              PagedSliverList(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<QuizResponseModel>(
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.loc.no_messages,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            context.loc.click_to_try_again,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 48.h,
                          ),
                          SizedBox(
                            width: 200.w,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _pagingController.retryLastFailedRequest,
                              icon: const Icon(Icons.refresh),
                              label: Text(
                                context.loc.try_again,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  animateTransitions: true,
                  transitionDuration: const Duration(milliseconds: 500),
                  itemBuilder: (context, item, index) => Text(item.id),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 100.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
