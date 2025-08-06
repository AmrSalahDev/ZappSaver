import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/utils/app_utils.dart';

class CountryPickerCubit extends Cubit<CountryPickerState> {
  CountryPickerCubit()
    : super(
        CountryPickerState(
          country: 'Egypt (EG)',
          flag: AppUtils.countryCodeToEmoji('eg'),
          phoneCode: '+20',
        ),
      );

  void setCountry(String country) {
    emit(state.copyWith(country: country));
  }

  void setFlag(String flag) {
    emit(state.copyWith(flag: flag));
  }

  void setPhoneCode(String phoneCode) {
    emit(state.copyWith(phoneCode: phoneCode));
  }

  String getPhoneCode() => state.phoneCode;
}

class CountryPickerState {
  final String country;
  final String flag;
  final String phoneCode;

  const CountryPickerState({
    required this.country,
    required this.flag,
    required this.phoneCode,
  });

  CountryPickerState copyWith({
    String? country,
    String? flag,
    String? phoneCode,
  }) {
    return CountryPickerState(
      country: country ?? this.country,
      flag: flag ?? this.flag,
      phoneCode: phoneCode ?? this.phoneCode,
    );
  }
}
