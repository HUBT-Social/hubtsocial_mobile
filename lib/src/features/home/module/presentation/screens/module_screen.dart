import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/bloc/module_bloc.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/widgets/module_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  int pageKey = 0;
  final _pagingController = PagingController<int, ModuleResponseModel>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      this.pageKey = pageKey;
      context.read<ModuleBloc>().add(GetModuleEvent());
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
      body: BlocConsumer<ModuleBloc, ModuleState>(
        listener: (_, state) async {
          if (state is ModuleLoadedError) {
            _pagingController.error = state.message;
          } else if (state is ModuleLoaded) {
            if (state.moduleData.isEmpty) {
              _pagingController.error = "items isEmpty";
            } else {
              pageKey++;
              _pagingController.appendPage(state.moduleData, pageKey);
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
                  builderDelegate:
                      PagedChildBuilderDelegate<ModuleResponseModel>(
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
                    itemBuilder: (context, item, index) => ModuleCard(
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
