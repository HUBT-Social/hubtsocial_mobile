import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/quiz/presentation/widgets/quiz_card.dart';
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
        actions: const [],
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (_, state) async {
          if (state is QuizError) {
            _pagingController.error = state.message;
          } else if (state is FetchQuizSuccess) {
            if (state.listQuiz.isEmpty) {
              _pagingController.error = "items isEmpty";
            } else {
              pageKey++;
              _pagingController.appendPage(state.listQuiz, pageKey);
            }
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
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
                              style: context.textTheme.titleLarge,
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
                    itemBuilder: (context, item, index) => QuizCard(
                      item: item,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 100.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
