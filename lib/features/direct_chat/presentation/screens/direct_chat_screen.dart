import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/utils/whatsapp_utils.dart';
import 'package:flutter_status_up/features/direct_chat/presentation/cubit/country_picker_cubit.dart';
import 'package:flutter_status_up/features/widgets/custom_app_bar.dart';
import 'package:flutter_status_up/features/widgets/custom_button.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:flutter_status_up/generated/l10n.dart';

class DirectChatScreen extends StatefulWidget {
  const DirectChatScreen({super.key});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                CustomAppBar(title: S.of(context).directChat),
                SizedBox(height: context.screenHeight * 0.04),
                BlocProvider.value(
                  value: context.read<CountryPickerCubit>(),
                  child: CountryPickerSection(),
                ),
                SizedBox(height: context.screenHeight * 0.04),
                BlocProvider.value(
                  value: context.read<CountryPickerCubit>(),
                  child: MessageSendSection(
                    phoneController: _phoneController,
                    messageController: _messageController,
                    phoneFormKey: _phoneFormKey,
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.04),
                CustomButton(
                  title: S.of(context).send,
                  onPressed: () async {
                    String phoneNumber =
                        '${context.read<CountryPickerCubit>().getPhoneCode()}${_phoneController.text}';
                    debugPrint(phoneNumber);
                    if (_phoneFormKey.currentState!.validate()) {
                      await WhatsappUtils.openWhatsAppAndSend(
                        phoneNumber: phoneNumber,
                        message: _messageController.text,
                      );
                    }
                  },
                ),
                SizedBox(height: context.screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageSendSection extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final GlobalKey<FormState> phoneFormKey;

  const MessageSendSection({
    super.key,
    required this.phoneController,
    required this.messageController,
    required this.phoneFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: phoneFormKey,
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).enterYourNumber;
                  } else if (!WhatsappUtils.isPhoneNumberValid(
                    '${context.read<CountryPickerCubit>().getPhoneCode()}$value',
                  )) {
                    return S.of(context).enterValidNumber;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: S.of(context).enterYourNumber,
                  hintStyle: TextStyle(color: AppColors.textHintColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.textFieldBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.screenHeight * 0.03),
            TextField(
              controller: messageController,
              maxLines: 10,
              minLines: 10,
              decoration: InputDecoration(
                hintText: S.of(context).writeYourMessage,
                hintStyle: TextStyle(color: AppColors.textHintColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.textFieldBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryPickerSection extends StatefulWidget {
  const CountryPickerSection({super.key});

  @override
  State<CountryPickerSection> createState() => CountryPickerSectionState();
}

class CountryPickerSectionState extends State<CountryPickerSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          useSafeArea: true,
          showPhoneCode: true,
          onSelect: (Country country) {
            context.read<CountryPickerCubit>().setCountry(
              country.displayNameNoCountryCode,
            );
            context.read<CountryPickerCubit>().setPhoneCode(
              '+${country.phoneCode}',
            );
            context.read<CountryPickerCubit>().setFlag(country.flagEmoji);
          },
          moveAlongWithKeyboard: false,
          countryListTheme: CountryListThemeData(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            margin: EdgeInsets.all(20),
            inputDecoration: InputDecoration(
              hintText: S.of(context).typeCountryNameOrCode,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.grey.withAlpha(130)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.grey.withAlpha(130)),
              ),
            ),
            // Optional. Styles the text in the search field
            searchTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(50),
          borderRadius: BorderRadius.circular(10),
        ),
        child: BlocBuilder<CountryPickerCubit, CountryPickerState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state.flag,
                  style: TextStyle(fontSize: context.textScaler.scale(20)),
                ),
                Text('${state.country}  ${state.phoneCode}'),
                RotatedBox(
                  quarterTurns: context.isArabic ? 1 : 3,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
