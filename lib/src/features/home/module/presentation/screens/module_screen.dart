import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/bloc/module_bloc.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/widgets/module_card.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/widgets/module_timeline.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  @override
  void initState() {
    context.read<ModuleBloc>().add(GetModuleEvent());

    super.initState();
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
      body: RefreshIndicator(
        onRefresh: () =>
            Future.sync(() => context.read<ModuleBloc>().add(GetModuleEvent())),
        child: BlocBuilder<ModuleBloc, ModuleState>(
          builder: (context, state) {
            if (state is ModuleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModuleLoaded) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ModuleTimeline(
                      title: '2024 - 2333',
                      children: [],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 100.h),
                  ),
                ],
              );
            } else if (state is ModuleLoadedError) {
              return Center(
                child: Text(
                  state.message,
                  style: context.textTheme.bodyLarge,
                ),
              );
            }
            return const Center();
          },
        ),
      ),
    );
  }
}
