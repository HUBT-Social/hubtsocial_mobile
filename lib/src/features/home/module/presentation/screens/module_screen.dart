import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/bloc/module_bloc.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/widgets/module_timeline.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  @override
  void initState() {
    context.read<ModuleBloc>().add(const GetModuleEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          context.loc.module,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
            () => context.read<ModuleBloc>().add(const GetModuleEvent())),
        child: BlocBuilder<ModuleBloc, ModuleState>(
          builder: (context, state) {
            if (state is ModuleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModuleLoaded) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.moduleData.length,
                      itemBuilder: (context, index) {
                        return ModuleTimeline(
                          moduleModel: state.moduleData[index],
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 100.h),
                  ),
                ],
              );
            } else if (state is ModuleLoadedError) {
              return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Text(
                        state.message,
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                  ]);
            }
            return const Center();
          },
        ),
      ),
    );
  }
}
