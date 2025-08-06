import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/features/widgets/custom_button.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/language_model.dart';
import '../../../../application/cubits/language_cubit.dart';
import '../../../../application/cubits/language_state.dart';
import '../../../../generated/l10n.dart';

class LanguageScreen extends StatelessWidget {
  final bool isFromHome;
  const LanguageScreen({super.key, this.isFromHome = false});

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      navigationBarColor: Colors.white,
      navigationBarIconBrightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    !isFromHome
                        ? const SizedBox()
                        : IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            onPressed: () => context.pop(),
                          ),
                    Text(
                      !isFromHome
                          ? "  ${S.of(context).selectLanguage}"
                          : S.of(context).selectLanguage,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: context.textScaler.scale(25),

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.screenHeight * 0.04),
                BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, state) {
                    String? currentLangCode;
                    if (state is LanguageChanged) {
                      currentLangCode = state.locale.code;
                    }
                    final langs = LanguageModel.supportedLanguages;
                    return Expanded(
                      child: ListView.separated(
                        itemCount: langs.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final language = langs[index];

                          return ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              language.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: CountryFlag.fromCountryCode(
                              language.flag,
                              shape: Circle(),
                            ),
                            trailing: Transform.scale(
                              scale: 1.1,
                              child: Radio<String>(
                                value: language.code,
                                groupValue: currentLangCode,

                                activeColor: AppColors.primaryColor,
                                onChanged: (_) {
                                  context.read<LanguageCubit>().changeLanguage(
                                    language,
                                  );
                                },
                              ),
                            ),
                            onTap: () {
                              context.read<LanguageCubit>().changeLanguage(
                                language,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                if (!isFromHome) ...[
                  Spacer(),
                  CustomButton(
                    title: S.of(context).next,
                    onPressed: () {
                      context.push(AppRouter.home);
                    },
                  ),
                  SizedBox(height: context.screenHeight * 0.05),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
