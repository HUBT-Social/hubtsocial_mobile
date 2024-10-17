import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../bloc/localization_bloc.dart';
import '../models/language.dart';

final class LocalizatioUtils {
  LocalizatioUtils._();
  static void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.left,
                  context.loc.chooseLanguage,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: 16),
              BlocBuilder<LocalizationBloc, AppLocalizationState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: Language.values.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          context.read<LocalizationBloc>().add(ChangeLanguage(
                              selectedLanguage: Language.values[index]));
                          Future.delayed(const Duration(milliseconds: 300))
                              .then((value) => context.pop());
                        },
                        leading: Image.asset(
                          Language.values[index].image,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                        title: Text(Language.values[index].text),
                        trailing:
                            Language.values[index] == state.selectedLanguage
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: context.colorScheme.primary,
                                  )
                                : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: Language.values[index] == state.selectedLanguage
                              ? BorderSide(
                                  color: context.colorScheme.primary, width: 1)
                              : BorderSide(color: Colors.grey[300]!),
                        ),
                        tileColor:
                            Language.values[index] == state.selectedLanguage
                                ? context.colorScheme.primary.withOpacity(0.05)
                                : null,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
